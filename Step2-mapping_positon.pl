#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long;
use PerlIO::gzip;
my ($in_vcf, $out_vcf);

GetOptions(
	'i:s' => \$in_vcf,
	'o:s' => \$out_vcf,
) or die $!;

open IN,"zcat $in_vcf |" || die $!;
open OUT,">:gzip","$out_vcf" || die $!;
while (<IN>) {
	if (/^#/) {
		print OUT;
	}else{
		my @vcf = split/\s+/,$_,3;
		my @name = split/:/,$vcf[0];
		print OUT join("\t",($name[0],($name[1]=~/^(\d+)/)[0]+$vcf[1],$vcf[2]));
	}
}
close OUT;
