#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $usage = "Usage: $0 <options>
Options:
  -bcid     bcids.txt     (required, list with BCID codes)
  -template template.tex  (optional, default: bookcrossing-template.tex)
  -lprname  techinc-label (optional, name you gave to the printer, default: techinc-label)
  -print                  (set this flag if you want to print to the label printer, no flag = only generate latex files)

Required packages (Ubuntu): texlive-xetex texlive-latex-recommended texlive-latex-extra

Creates bookcrossing labels from a template and a list with BCID codes. This can be send to a label printer.
Example: $0 -bcid example-bcid.txt -lprname myprinter -print
";

# Get options
my %opt;
my $return = GetOptions (\%opt,
                         "template:s",
                         "bcid:s",
                         "lprname",
                         "print"
);

# Check options
die $usage if (! $opt{'bcid'});
$opt{'template'} = "bookcrossing-template.tex" if (! $opt{'template'});
$opt{'lprname'} = "techinc-label" if (! $opt{'lprname'});
#$opt{'print'} = "yes" if ($opt{'print'});

# Create temporary directory
my $tmpdir = "tmp";
unless(-d $tmpdir){
    mkdir $tmpdir or die;
}

### Do stuff ###

# Read template latex file
my $template = read_template($opt{'template'});

# Read list with BCID codes
open (FILE, $opt{'bcid'}) or die "cannot open file '$opt{'bcid'}' : $!\n";
while (<FILE>) {
  next if m/^$/;    #skip empty lines
  s/\r?\n//;  # remove return and newline

  # Store the template text in a new variable and replace all occurrences of BCID-HERE with the real bcid
  my $newlatex = $template;
  $newlatex =~ s/BCID-HERE/$_/g;

  # Create a new latex file $tmpdir/$bcid.tex
  my $latexfile = generate_latex($_, $newlatex);

  # Convert tex to pdf to ps, and send it to the label printer
  print_label($latexfile) if $opt{'print'};
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
  my $latexfile = "$tmpdir/$bcid.tex";

  open (OUT, ">$latexfile") or die "cannot create file '$latexfile' : $!\n";
  print OUT $latex;
  close (OUT);

  return $latexfile;
}

sub print_label {
  my $tex = shift;
  my $dirname = `dirname $tex`;
  $dirname =~ s/\r?\n//;
  my $basename = `basename $tex .tex`;
  $basename =~ s/\r?\n//;

  # latex to pdf
  execute("xelatex -output-directory=$dirname $tex");

  # pdf to ps
  execute("pdf2ps $dirname/$basename.pdf $dirname/$basename.ps");

  # print ps
  execute("lpr -P $opt{'lprname'} -h $dirname/$basename.ps");
}

sub execute {
  my $syscall = shift;

  print "SYSCALL: $syscall\n";
  my $sysreturn = system ($syscall);
  die "ERROR with syscall: $syscall\n$1\n" if $sysreturn>0;
}

