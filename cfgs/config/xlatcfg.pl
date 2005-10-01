#!/usr/bin/perl

# Generate xlatcharset directives for the config of Golded+
# using Golded+ charset conversion modules in text form (*.chs).
#
# Format:
# XLATCHARSET  RUS         IBMPC       RUS_IBM.CHS

if($#ARGV<1){
   die "Need two parameters: directory witn *.chs (1) and output file name (2)\n";
}

if( -f $ARGV[1] ){
   die "File '$ARGV[1]' is exists, exiting\n";
}

if( ! -d $ARGV[0] ){
   die "Directory '$ARGV[1]' is not exists, exiting\n";
}
my $dir=$ARGV[0], $out=$ARGV[1];

my @files=<$dir/*.chs>;

open OUT, ">$out" || die "Can't open/create file '$out': $!\n";

print "Found " . ($#files+1) . " *.CHS files in $dir\n";

foreach my $f (@files) {
  if( ! open( IN, "$dir/$f" ) ){ print STDERR "Can't open file '$dir/$f': $!\n"; next; }
  print "Proceed $dir/$f\n";
  my $count=1, $fromchs, $tochs;
  while( <IN> ) {
     next if( /^;/ ); # comment
     next if( m%^//% ); # comment
     next if( m%^#% ); # comment
     chomp;
     next if( m%^$% ); # empty line
     if( m%^([^\s]+)% ) {
       if($count==4){ $fromchs=$1; }
       elsif($count==5){
         $tochs=$1;
         printf OUT "XLATCHARSET %-12s %-12s %s\n", $fromchs, $tochs, $f;
       }
       $count++;
     }
  }
  close IN;
}

close OUT;
