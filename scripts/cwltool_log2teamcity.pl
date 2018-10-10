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
    my $key;
    while(<>) {
        chomp;
        if (/Resolved '([^']+)'/ and not defined $test_suite) {
            $test_suite = $1;
        }
        my $k={}; 
        ($$k{curtime}, $$k{type}, $$k{step}, $$k{message}) = /\[(\d+-\d+-\d+ \d+:\d+:\d+)\] \[(workflow|step|job) ([^\]]+)\] (.*)/;
        if (!defined $$k{message}) {
			print "$_\n";
			next;
		}
        $key = $$k{type};
        $key .= " $$k{step}" if $$k{step};
        if ($$k{message} =~ /^completed/) { # Completed (success/permanentFail) what was started.
            # my $kl = $$stack[scalar(@$stack)-1];
            --$started{$key};
			print "$_\n";
			if( $$k{message} =~/permanentFail/ ) {
				&tc_failed($key, $$k{message});
			}
            &tc_finish($key);
            &tc_block_closed($key) unless $$k{type} eq "job";
            pop @$stack;
        }
        elsif ($$k{message} =~ /^start$/ or not defined $started{$key})  { # Starting new step/job.
            ++$started{$key};
            if (not $header_printed) {
                $header_printed = 1;
                $test_suite = 'cwltool' unless defined $test_suite;
                &tc_start_suite($test_suite);
            }
            &tc_block_opened($key, $$k{step}) unless $$k{type} eq "job";
            &tc_start($key);
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

sub tc_block_opened
{
    my ($name, $description) = @_;
    chomp $description;
    printf '%s%s%s', '#', '#', "teamcity[blockOpened name='$name' description='$description']";
    print "\n";
}

sub tc_block_closed
{
    my ($name) = @_;
    printf '%s%s%s', '#', '#', "teamcity[blockClosed name='$name']";
    print "\n";
}

