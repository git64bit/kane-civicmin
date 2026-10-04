#!/usr/local/bin/perl
# help.cgi
# Broker-resolved guidance for one discoverable Civic command.

require './civicmin-lib.pl';
require './civicmin-client.pl';
&ReadParse();

my $codename = $in{'codename'} || "";
my ($result, $help_error);

if ($codename !~ /^[a-z]{1,5}-[a-z]{1,5}$/) {
	$help_error = $text{'help_invalid'};
	}
else {
	eval {
		$result = &civicmin_command_help($codename);
		};
	if ($@) {
		$help_error = $@;
		$help_error =~ s/[\r\n]+/ /g;
		$help_error =~ s/\s+$//;
		}
	}

&ui_print_header(undef, $text{'help_title'}, "", undef, 0, 1);

print &ui_table_start($text{'help_header'}, undef, 2);
print &ui_table_row($text{'help_command'},
	"<tt>".&html_escape($codename)."</tt>");
if ($result) {
	print &ui_table_row($text{'index_participant'},
		"<tt>".&html_escape($result->{'participant_id'} || "")."</tt>");
	print &ui_table_row($text{'catalog_available'},
		$result->{'available_to_run'} ?
			$text{'catalog_yes'} : $text{'catalog_no'});
	}
print &ui_table_end();

print "<p>\n";
if ($help_error) {
	print &ui_table_start($text{'help_guidance'}, undef, 1);
	print &ui_table_row(undef, &html_escape($help_error));
	print &ui_table_end();
	}
else {
	my $body = &html_escape($result->{'help'});
	$body =~ s/\n/<br>\n/g;
	print &ui_table_start($text{'help_guidance'}, undef, 1);
	print &ui_table_row(undef, $body);
	print &ui_table_end();

	if ($codename eq "water-ants" && $result->{'available_to_run'}) {
		print "<p>\n";
		print &ui_form_start("water-ants.cgi", "get");
		print &ui_form_end([ [ undef, $text{'help_continue'} ] ]);
		}
	}

&ui_print_footer("index.cgi", $text{'help_return'},
		 "/", $text{'index_return'});
