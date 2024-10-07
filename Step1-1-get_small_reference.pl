#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long;

my ($in_fasta, $out_fasta, $pos);

GetOptions(
	'fi:s' => \$in_fasta,
	'fo:s' => \$out_fasta,
	'pos:s' => \$pos,
) or die $!;

open POS,"$pos";
open BED_TMP,">$pos.tmp.bed";
while (<POS>) {
	chomp;
	my @a = split/\s+/;
	$a[1] -= 500;
	$a[1] = 0 if $a[1] < 0;
	print BED_TMP join("\t",(@a[0,1],$a[1]+1000)),"\n";
}
close BED_TMP;

system"bedtools merge -i $pos.tmp.bed > $pos.tmp1.bed";
system"bedtools getfasta -fi $in_fasta -bed $pos.tmp1.bed -fo $out_fasta";
unlink "$pos.tmp.bed","$pos.tmp1.bed";
