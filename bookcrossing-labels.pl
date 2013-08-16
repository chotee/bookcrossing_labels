#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $usage = "Usage: $0 <options>
Options:
  -template template.tex (default: bookcrossing-template.tex, the string 'BCID-HERE' will be replaced by the bcid's given in the next file)
  -bcid     bcids.txt    (required, list with BCID codes)
  -print    no|yes       (no/yes, default: no)
";

# Get options
my %opt;
my $return = GetOptions (\%opt,
                         "template:s",
                         "bcid:s",
                         "print:s"
);

# Check options
die $usage if (! $opt{'bcid'});
$opt{'template'} = "bookcrossing-template.tex" if (! $opt{'template'});
$opt{'print'} = "no" if (! $opt{'print'});

### Do stuff ###

# Read template latex file
my $template = read_template($opt{'template'});

# Read list with BCID codes
open (FILE, $opt{'bcid'}) or die "cannot open file '$opt{'bcid'}' : $!\n";
while (<FILE>) {
  next if m/^$/;    #skip empty lines
  s/\r?\n//;  # remove return and newline

  my $newlatex = $template;
  $newlatex =~ s/BCID-HERE/$_/g;  # replace all occurrences of BCID-HERE with the real bcid

  my $latexfile = generate_latex($_, $newlatex);
  print_label($latexfile) if $opt{'print'} eq "yes";
}
close (FILE);

exit(0);

sub read_template {
  my $file = shift;

  my $template;
  open (FILE, $file) or die "cannot open file '$file' : $!\n";
  while (<FILE>) {
    $template .= $_;
  }
  close (FILE);

  return $template;
}

sub generate_latex {
  my $bcid = shift;
  my $latex = shift;
  my $latexfile = "tmp/$bcid.tex";

  open (OUT, ">$latexfile") or die "cannot create file '$latexfile' : $!\n";
  print OUT $latex;
  close (OUT);

  return $latexfile;
}

sub print_label {
  my $tex = shift;
  print "print label $tex: not implemented yet\n";

  # latex to pdf
  # pdf to ps
  # print ps
}

