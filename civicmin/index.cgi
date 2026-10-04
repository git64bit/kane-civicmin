#!/usr/local/bin/perl
# index.cgi
# Access-resolved, read-only Civic command catalog.

require './civicmin-lib.pl';
require './civicmin-client.pl';

&ui_print_header(undef, $text{'index_title'}, "", undef, 0, 1);

my ($catalog, $catalog_error);
eval {
	$catalog = &civicmin_list_catalog();
	};
if ($@) {
	$catalog_error = $@;
	$catalog_error =~ s/[\r\n]+/ /g;
	$catalog_error =~ s/\s+$//;
	}

print &ui_table_start($text{'index_header'}, undef, 2);
print &ui_table_row($text{'index_session'},
	"<tt>".&html_escape($remote_user)."</tt>");
print &ui_table_row($text{'index_dispatch'}, $text{'index_dispatch_none'});
print &ui_table_row($text{'index_effects'}, $text{'index_effects_none'});
if ($catalog) {
	print &ui_table_row($text{'index_participant'},
		"<tt>".&html_escape($catalog->{'participant_id'} || "")."</tt>");
	}
print &ui_table_end();

print "<p>\n";
print &ui_table_start($text{'catalog_header'}, undef, 2);

if ($catalog_error) {
	print &ui_table_row($text{'catalog_state'},
		&html_escape($catalog_error));
	}
elsif (!@{$catalog->{'commands'}}) {
	print &ui_table_row($text{'catalog_state'}, $text{'catalog_none'});
	}
else {
	foreach my $command (@{$catalog->{'commands'}}) {
		my $raw_codename = $command->{'codename'} || "";
		my $name = &html_escape($command->{'display_name'} || "");
		my $codename = &html_escape($raw_codename);
		my $lifecycle = &html_escape($command->{'lifecycle'} || "");
		my $summary = &html_escape($command->{'summary'} || "");
		my $available = $command->{'available_to_run'} ?
			$text{'catalog_yes'} : $text{'catalog_no'};

		my $left;
		if ($raw_codename =~ /^[a-z]{1,5}-[a-z]{1,5}$/) {
			$left = "<b><a href=\"help.cgi?codename=$raw_codename\">$name</a></b>".
				"<br><tt>$codename</tt>";
			}
		else {
			$left = "<b>$name</b><br><tt>$codename</tt>";
			}

		my $right = $summary."<br>".
			$text{'catalog_lifecycle'}.": <tt>$lifecycle</tt><br>".
			$text{'catalog_available'}.": ".$available;
		print &ui_table_row($left, $right);
		}
	}
print &ui_table_end();

&ui_print_footer("/", $text{'index_return'});
