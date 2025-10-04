#!/usr/bin/perl
use strict; use warnings;
my ($log) = @ARGV or die "usage: $0 build/run.log\n";
open my $fh, '<', $log or die $!;
my ($pass,$fail)=(0,0);
my %cov;
while(<$fh>){
  $pass++ if /CHECK PASS/;
  $fail++ if /(?:ERROR|FAIL)/;
  if (/COVER:\s+(\S+)\s+hits=(\d+)/) { $cov{$1} = $2; }
}
print "SUMMARY: PASS=$pass FAIL=$fail\n";
for my $k (sort keys %cov) { print "SUMMARY: $k $cov{$k}\n"; }

# simple coverage gate: each opcode must appear at least 100 times
my $ok_cov = 1;
for my $req (qw(OP0_ADD OP1_SUB OP2_AND OP3_OR OP4_XOR OP5_SLT)) {
  if (!exists $cov{$req} or $cov{$req} < 100) { $ok_cov = 0; }
}
exit( ($fail==0 && $pass>0 && $ok_cov) ? 0 : 1 );
