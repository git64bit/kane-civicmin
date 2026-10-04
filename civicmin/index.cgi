#!/usr/local/bin/perl
# index.cgi
# Read-only Civicmin Usermin shell. No Civic broker or remote dispatch.

require './civicmin-lib.pl';

&ui_print_header(undef, $text{'index_title'}, "", undef, 0, 1);

print &ui_table_start($text{'index_header'}, undef, 2);
print &ui_table_row($text{'index_state'}, $text{'index_readonly'});
print &ui_table_row($text{'index_session'},
	"<tt>".&html_escape($remote_user)."</tt>");
print &ui_table_row($text{'index_dispatch'}, $text{'index_dispatch_none'});
print &ui_table_row($text{'index_effects'}, $text{'index_effects_none'});
print &ui_table_end();

&ui_print_footer("/", $text{'index_return'});
