#!/usr/local/bin/perl
# water-ants.cgi
# Command-specific local-stub form for Publish File.

require './civicmin-lib.pl';
require './civicmin-client.pl';

my ($help, $form_error);
eval {
	$help = &civicmin_command_help("water-ants");
	$help->{'available_to_run'} ||
		die "Publish File is not available to run for this Participant";
	};
if ($@) {
	$form_error = $@;
	$form_error =~ s/[\r\n]+/ /g;
	$form_error =~ s/\s+at\s+.+?\s+line\s+\d+\.?\s*$//;
	$form_error =~ s/\s+$//;
	}

&ui_print_header(undef, $text{'water_title'}, "", undef, 0, 1);

if ($form_error) {
	print &ui_table_start($text{'water_header'}, undef, 1);
	print &ui_table_row(undef, &html_escape($form_error));
	print &ui_table_end();
	}
else {
	print &ui_form_start("run-water-ants.cgi", "form-data");
	print &ui_table_start($text{'water_header'}, undef, 2);
	print &ui_table_row($text{'water_file'}, &ui_upload("artifact", 50));
	print &ui_table_row(
		$text{'water_confirm'},
		&ui_checkbox("confirm", 1, $text{'water_confirm_text'}, 0)
		);
	print &ui_table_end();
	print &ui_form_end([ [ undef, $text{'water_submit'} ] ]);
	}

&ui_print_footer("help.cgi?codename=water-ants", $text{'water_back'},
		 "index.cgi", $text{'help_return'});
