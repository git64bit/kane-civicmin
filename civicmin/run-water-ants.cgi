#!/usr/local/bin/perl
# run-water-ants.cgi
# Fixed water-ants local-stub invocation. No generic command selection.

require './civicmin-lib.pl';
require './civicmin-client.pl';
&ReadParseMime();

my ($result, $run_error);
my $filename = $in{'artifact_filename'} || "";

eval {
	$filename ne "" || die "Choose a file to validate";
	$in{'confirm'} || die "Explicit acknowledgement is required";
	defined($in{'artifact'}) || die "Uploaded file bytes are unavailable";
	length($in{'artifact'}) <= $CIVICMIN_MAX_ARTIFACT_BYTES ||
		die "Uploaded file exceeds $CIVICMIN_MAX_ARTIFACT_BYTES byte limit";

	$result = &civicmin_invoke_water_ants($in{'artifact'});
	};
if ($@) {
	$run_error = $@;
	$run_error =~ s/[\r\n]+/ /g;
	$run_error =~ s/\s+at\s+.+?\s+line\s+\d+\.?\s*$//;
	$run_error =~ s/\s+$//;
	}

&ui_print_header(undef, $text{'water_result_title'}, "", undef, 0, 1);

if ($run_error) {
	print &ui_table_start($text{'water_result_header'}, undef, 1);
	print &ui_table_row(undef, &html_escape($run_error));
	print &ui_table_end();
	}
else {
	my $artifact = $result->{'artifact'};
	print &ui_table_start($text{'water_result_header'}, undef, 2);
	print &ui_table_row($text{'water_result_file'}, &html_escape($filename));
	print &ui_table_row($text{'water_result_status'},
		&html_escape($result->{'status'} || ""));
	print &ui_table_row($text{'water_result_operation'},
		"<tt>".&html_escape($result->{'operation'} || "")."</tt>");
	print &ui_table_row($text{'water_result_media'},
		&html_escape($artifact->{'media_type'} || ""));
	print &ui_table_row($text{'water_result_size'},
		&html_escape($artifact->{'size_bytes'} || 0));
	print &ui_table_row($text{'water_result_sha'},
		"<tt>".&html_escape($artifact->{'sha256'} || "")."</tt>");
	print &ui_table_row($text{'index_dispatch'}, $text{'water_result_dispatch'});
	print &ui_table_row($text{'index_effects'}, $text{'water_result_effects'});
	print &ui_table_end();
	}

&ui_print_footer("water-ants.cgi", $text{'water_again'},
		 "index.cgi", $text{'help_return'});
