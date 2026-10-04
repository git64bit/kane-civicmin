#!/bin/bash
# Kane Civicmin — portable Portal installer.
#
# Contract: run as root, with no arguments, from a pinned kane-civicmin
# release checkout after kane-orchestrator has created the civic-participants
# group and activated the Custom Command broker socket.
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export LANG=C
export LC_ALL=C

SUPPORTED_ID="ubuntu"
SUPPORTED_VERSION="24.04"
MIN_USERMIN_VERSION="2.550"
BROKER_SOCKET="/run/civic-orchestrator/custom-command.sock"
BROKER_GROUP="civic-participants"

# Immutable upstream repository-bootstrap script used for the v0.5.0 baseline.
WEBMIN_SETUP_COMMIT="84ea802947aaf45b102424322f4cb9c2999410ef"
WEBMIN_SETUP_URL="https://raw.githubusercontent.com/webmin/webmin/${WEBMIN_SETUP_COMMIT}/webmin-setup-repo.sh"

fail()
{
    echo "Civicmin install failed: $*" >&2
    exit 1
}

if [ "$#" -ne 0 ]; then
    fail "INSTALL/install.sh takes no arguments"
fi

if [ "$(id -u)" -ne 0 ]; then
    fail "run INSTALL/install.sh as root"
fi

if [ ! -r /etc/os-release ]; then
    fail "cannot identify operating system"
fi
. /etc/os-release
if [ "${ID:-}" != "$SUPPORTED_ID" ] || [ "${VERSION_ID:-}" != "$SUPPORTED_VERSION" ]; then
    fail "supported Portal baseline is Ubuntu $SUPPORTED_VERSION LTS"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$(cd "$SCRIPT_DIR/.." && pwd)"
[ -r "$SOURCE/civicmin/module.info" ] || fail "civicmin module source is missing"

getent group "$BROKER_GROUP" >/dev/null ||     fail "required group $BROKER_GROUP does not exist"
[ -S "$BROKER_SOCKET" ] ||     fail "required broker socket $BROKER_SOCKET is not active"

socket_group="$(stat -c '%G' "$BROKER_SOCKET")"
socket_mode="$(stat -c '%a' "$BROKER_SOCKET")"
[ "$socket_group" = "$BROKER_GROUP" ] ||     fail "broker socket group is $socket_group, expected $BROKER_GROUP"
[ "$socket_mode" = "660" ] ||     fail "broker socket mode is $socket_mode, expected 660"

tmpdir="$(mktemp -d)"
cleanup()
{
    rm -rf "$tmpdir"
}
trap cleanup EXIT HUP INT TERM

echo "== Webmin / Usermin"
need_repo=0
dpkg-query -W -f='${Status}' webmin 2>/dev/null | grep -qx 'install ok installed' || need_repo=1
dpkg-query -W -f='${Status}' usermin 2>/dev/null | grep -qx 'install ok installed' || need_repo=1

if [ "$need_repo" -eq 1 ]; then
    apt-get -o DPkg::Lock::Timeout=600 update -q
    apt-get -o DPkg::Lock::Timeout=600 install -y -q ca-certificates curl gnupg
    curl -fsSL "$WEBMIN_SETUP_URL" -o "$tmpdir/webmin-setup-repo.sh"
    sh "$tmpdir/webmin-setup-repo.sh" --force --stable
    apt-get -o DPkg::Lock::Timeout=600 install -y -q --install-recommends webmin usermin
fi

[ -r /usr/share/usermin/version ] || fail "Usermin version file is missing"
usermin_version="$(cat /usr/share/usermin/version)"
dpkg --compare-versions "$usermin_version" ge "$MIN_USERMIN_VERSION" ||     fail "Usermin $usermin_version is older than required $MIN_USERMIN_VERSION"

[ -r /etc/webmin/miniserv.conf ] || fail "Webmin configuration is missing"
[ -r /etc/usermin/miniserv.conf ] || fail "Usermin configuration is missing"

usermin_root="$(awk -F= '$1 == "root" { print $2; exit }' /etc/usermin/miniserv.conf)"
[ -n "$usermin_root" ] && [ -d "$usermin_root" ] ||     fail "cannot determine Usermin installation root"
[ -x "$usermin_root/install-module.pl" ] ||     fail "Usermin module installer is unavailable"

echo "== Civicmin module"
module_archive="$tmpdir/kane-civicmin.ubm.gz"
tar -C "$SOURCE" -czf "$module_archive" civicmin

install_output="$("$usermin_root/install-module.pl" "$module_archive" /etc/webmin 2>&1 || true)"
printf '%s\n' "$install_output"
case "$install_output" in
    *"Install failed :"*) fail "Usermin rejected the Civicmin module" ;;
esac

installed_info="$usermin_root/civicmin/module.info"
[ -r "$installed_info" ] || fail "installed Civicmin module.info is missing"
cmp -s "$SOURCE/civicmin/module.info" "$installed_info" ||     fail "installed Civicmin module does not match this checkout"

systemctl enable --now webmin.service usermin.service >/dev/null

echo "Civicmin installed."
echo "  Usermin version: $usermin_version"
echo "  Usermin root:    $usermin_root"
echo "  broker socket:   $BROKER_SOCKET"
echo "  mail:            unchanged"
