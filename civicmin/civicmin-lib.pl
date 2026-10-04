# civicmin-lib.pl
# Minimal Usermin integration for the Civicmin thin-client shell.

BEGIN { push(@INC, ".."); };
use WebminCore;
&init_config();

# Civicmin is participant-facing. Drop the initial CGI privilege before
# rendering or performing any future local-client work.
if ($module_info{'usermin'}) {
	&switch_to_remote_user();
	}

1;
