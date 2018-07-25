#!/usr/bin/env perl
#
#  This script takes output of cwltool --timestamps and introduces teamcity tags in the output stream
#

use strict;
use warnings;

{
    my $stack = [];
    my $header_printed = 0;
    while(<>) {
        chomp;
        my $k={}; 
        ($$k{curtime}, $$k{step}, $$k{message}) = m{\[([^\]]+)\] \[([^\]]+)\] (.*)}g;
        if (!defined $$k{message}) {
			print "$_\n";
			next;
		}
        if ($$k{message} =~ /^completed/) { # new step
            # my $kl = $$stack[scalar(@$stack)-1];
			print "$_\n";
			if( $$k{message} =~/permanentFail/ ) {
				&tc_failed($$k{step}, $$k{message});
			}
			else {
				&tc_finish($$k{step});
			}
            pop @$stack;
        }
        else {
			&tc_start($$k{step});
			print "$_\n";
            push @$stack, $k;
        }
    }
} exit 0;

sub tc_start
{
	my $name = shift;
    printf '%s%s%s', '#', '#', "teamcity[testStarted name='$name' captureStandardOutput='true']";
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
    printf '%s%s%s', '#', '#', "teamcity[testFinished name='$name']";
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
    printf '%s%s%s', '#', '#', "teamcity[testFailed name='$name' message='$message']";
	print "\n";
}