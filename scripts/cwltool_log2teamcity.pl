#!/usr/bin/env perl
#
#  This script takes output of cwltool --timestamps and introduces teamcity tags in the output stream
#

use strict;
use warnings;

{
    my $stack = [];
    my %started = (); # Count of times a step was started.
    my $header_printed = 0;
    my $test_suite;
    while(<>) {
        chomp;
        if (/Resolved '([^']+)'/ and not defined $test_suite) {
            $test_suite = $1;
        }
        my $k={}; 
        ($$k{curtime}, $$k{step}, $$k{message}) = /\[(\d+-\d+-\d+ \d+:\d+:\d+)\] \[((?:workflow|step|job) [^\]]+)\] (.*)/;
        if (!defined $$k{message}) {
			print "$_\n";
			next;
		}
        $$k{step} =~ s/\s+$//; # Remove trailing space in unnamed "[workflow ]".
        if ($$k{message} =~ /^completed/) { # Completed (success/permanentFail) what was started.
            # my $kl = $$stack[scalar(@$stack)-1];
            --$started{$$k{step}};
			print "$_\n";
			if( $$k{message} =~/permanentFail/ ) {
				&tc_failed($$k{step}, $$k{message});
			}
            &tc_finish($$k{step});
            pop @$stack;
        }
        elsif ($$k{message} =~ /^start$/ or not defined $started{$$k{step}})  { # Starting new step/job.
            ++$started{$$k{step}};
            if (not $header_printed) {
                $header_printed = 1;
                $test_suite = 'cwltool' unless defined $test_suite;
                &tc_start_suite($test_suite);
            }
            &tc_start($$k{step});
            print "$_\n";
            push @$stack, $k;
        }
        else {
            print "$_\n";
        }
    }
    if ($header_printed) {
        tc_finish_suite($test_suite);
    }
} exit 0;

sub tc_start
{
	my $name = shift;
    printf '%s%s%s', '#', '#', "teamcity[testStarted flowId='$name' name='$name' captureStandardOutput='true']";
	print "\n";
}

sub tc_start_suite
{
	my $name = shift;
    printf '%s%s%s', '#', '#', "teamcity[testSuiteStarted name='$name']";
	print "\n";
}

sub tc_finish
{
	my $name = shift;
    printf '%s%s%s', '#', '#', "teamcity[testFinished flowId='$name' name='$name']";
	print "\n";
}

sub tc_finish_suite
{
	my $name = shift;
    printf '%s%s%s', '#', '#', "teamcity[testSuiteFinished name='$name']";
	print "\n";
}

sub tc_failed
{
	my ($name, $message) = @_;
	chomp $message;
    printf '%s%s%s', '#', '#', "teamcity[testFailed flowId='$name' name='$name' message='$message']";
	print "\n";
}
