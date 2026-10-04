# civicmin-client.pl
# Thin client for the accepted local Civic Custom Command boundary.

use Socket qw(AF_UNIX SOCK_STREAM sockaddr_un);
use JSON::PP ();

$CIVICMIN_COMMAND_SOCKET = "/run/civic-orchestrator/custom-command.sock";
$CIVICMIN_MAX_RESPONSE_BYTES = 65536;
$CIVICMIN_MAX_ARTIFACT_BYTES = 262144;

sub civicmin_send_all
{
my ($sock, $data) = @_;
my $offset = 0;
while ($offset < length($data)) {
	my $written = syswrite($sock, $data, length($data) - $offset, $offset);
	defined($written) && $written > 0 ||
		die "failed to write local Civic request: $!";
	$offset += $written;
	}
}

sub civicmin_recv_exact
{
my ($sock, $length) = @_;
my $data = "";
while (length($data) < $length) {
	my $chunk = "";
	my $got = sysread($sock, $chunk, $length - length($data));
	defined($got) || die "failed to read local Civic response: $!";
	$got > 0 || die "local Civic response ended unexpectedly";
	$data .= $chunk;
	}
return $data;
}

sub civicmin_broker_exchange
{
my ($request_kind, $codename, $arguments, $payload) = @_;

ref($arguments) eq "HASH" || die "Civic request arguments must be an object";
defined($payload) || die "Civic request payload is undefined";
length($payload) <= $CIVICMIN_MAX_ARTIFACT_BYTES ||
	die "Civic payload exceeds $CIVICMIN_MAX_ARTIFACT_BYTES byte limit";

my $metadata = JSON::PP->new
	->utf8(1)
	->canonical(1)
	->allow_nonref(0)
	->encode({
		protocol_version => 2,
		request_kind => $request_kind,
		codename => $codename,
		arguments => $arguments,
	});

my $sock;
socket($sock, AF_UNIX, SOCK_STREAM, 0) ||
	die "cannot create local Civic socket: $!";

my $ok;
my $response;
eval {
	local $SIG{'ALRM'} = sub { die "local Civic request timed out" };
	alarm(3);

	connect($sock, sockaddr_un($CIVICMIN_COMMAND_SOCKET)) ||
		die "local Civic broker is unavailable: $!";

	civicmin_send_all($sock, pack("NN", length($metadata), length($payload)));
	civicmin_send_all($sock, $metadata);
	civicmin_send_all($sock, $payload) if length($payload);

	my $header = civicmin_recv_exact($sock, 4);
	my $length = unpack("N", $header);
	$length <= $CIVICMIN_MAX_RESPONSE_BYTES ||
		die "local Civic response is too large";

	my $raw = civicmin_recv_exact($sock, $length);
	$response = JSON::PP->new->utf8(1)->decode($raw);
	alarm(0);
	$ok = 1;
	};
my $error = $@;
alarm(0);
close($sock);

$ok || die $error || "local Civic request failed";
ref($response) eq "HASH" ||
	die "local Civic response is not an object";

if (($response->{'status'} || "") eq "rejected") {
	die $response->{'error'} || "local Civic request was rejected";
	}

return $response;
}

sub civicmin_readonly_request
{
my ($request_kind, $codename) = @_;

$request_kind eq "list" || $request_kind eq "help" ||
	die "unsupported Civicmin read-only request";
if ($request_kind eq "list") {
	defined($codename) &&
		die "Civic catalog list request must not include a command";
	}
else {
	defined($codename) && $codename =~ /^[a-z]{1,5}-[a-z]{1,5}$/ ||
		die "invalid Civic command identifier";
	}

my $response = civicmin_broker_exchange(
	$request_kind, $codename, {}, ""
);

($response->{'status'} || "") eq "ok" ||
	die "local Civic response has an unexpected status";
$response->{'remote_dispatch'} &&
	die "read-only Civic request unexpectedly reports remote dispatch";
$response->{'side_effects'} &&
	die "read-only Civic request unexpectedly reports side effects";

return $response;
}

sub civicmin_list_catalog
{
my $response = civicmin_readonly_request("list", undef);
ref($response->{'commands'}) eq "ARRAY" ||
	die "local Civic catalog response has no command list";
return $response;
}

sub civicmin_command_help
{
my ($codename) = @_;
my $response = civicmin_readonly_request("help", $codename);

($response->{'command'} || "") eq $codename ||
	die "local Civic help response command does not match request";
defined($response->{'help'}) && !ref($response->{'help'}) ||
	die "local Civic help response has no help text";

return $response;
}

sub civicmin_invoke_water_ants
{
my ($payload) = @_;
defined($payload) || die "Publish File payload is undefined";
length($payload) <= $CIVICMIN_MAX_ARTIFACT_BYTES ||
	die "Publish File exceeds $CIVICMIN_MAX_ARTIFACT_BYTES byte limit";

my $response = civicmin_broker_exchange(
	"invoke", "water-ants", {}, $payload
);

($response->{'status'} || "") eq "stub" ||
	die "Publish File returned an unexpected status";
($response->{'command'} || "") eq "water-ants" ||
	die "Publish File response command mismatch";
($response->{'operation'} || "") eq "publication.publish" ||
	die "Publish File response operation mismatch";
$response->{'remote_dispatch'} &&
	die "Publish File stub unexpectedly reports remote dispatch";
$response->{'side_effects'} &&
	die "Publish File stub unexpectedly reports side effects";
ref($response->{'artifact'}) eq "HASH" ||
	die "Publish File stub returned no artifact evidence";

return $response;
}

1;
