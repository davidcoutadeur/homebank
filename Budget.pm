#!/usr/bin/perl
# Application budget IHM

package Budget;

use strict;
use warnings;

use Date::Calc qw(Delta_Days Time_to_Date);
use XML::Simple qw(:strict);
use Encode;


################################################################################
# Variables
################################################################################


################################################################################
# Functions
################################################################################


# Open homebank file to get categories
sub getXML {
  my $ref = shift;
  my $file = shift;

  my $xs = XML::Simple->new();
  $ref = $xs->XMLin( $file, ForceArray => 1, KeyAttr => [  ] );

  return $ref;
}


# Get categories from homebank XML structure
sub getCategories {
  my $ref = shift;
  my %cat;

  my $cat = $ref->{cat};

  foreach my $key ( @$cat ) {
    # don't consider top categories
    if ( $key->{flags} ne "0" ) {
      my $name = Encode::encode_utf8( $key->{name} );
      my $k = Encode::encode_utf8( $key->{key} );
      $cat{$k} = $name;
    }
  }

  return %cat;
}

# Get operations from homebank XML structure
sub getOperations {
  my $ref = shift;
  my $cat = shift;
  my $operations = [];

  my $ope = $ref->{ope};

  foreach my $key ( @$ope ) {
    my $date = Encode::encode_utf8( $key->{date} );
    my $amount = Encode::encode_utf8( $key->{amount} );
    my $category = Encode::encode_utf8( $cat->{$key->{category}} );
    my $wording = Encode::encode_utf8( $key->{wording} );
    
    push @$operations, {date => $date,
                        pdate => timestampToDate($date),
                        amount => $amount,
                        category => $category,
                        wording => $wording};
  }

  return $operations;
}

sub dateToTimestamp {
  my $myDate = shift;

  my ($year, $month, $day);
  my $da;

  ($day, $month, $year) = split(/\//, $myDate);

  return 0 if !defined $day or !defined $month or !defined $year;
  return 0 unless $day > 0 and $day < 32;
  return 0 unless $month > 0 and $month < 13;
  return 0 unless $year > 1900 and $year < 2100;

  # Compute operation timestamp
  my $days = Delta_Days( 1, 1, 1, $year, $month, $day);
  $da = $days + 1;

  return $da;

}

sub timestampToDate {
  my $ts = shift;
  $ts -= Delta_Days( 1, 1, 1, 1970, 1, 1) + 1;
  $ts *= 3600 * 24;
  my ($year, $month, $day);

  ($year, $month, $day) = Time_to_Date($ts);

  return "$day/$month/$year";

}

sub insertOperation {
  my $ref = shift;
  my $da = shift;
  my $am = shift;
  my $ac = shift;
  my $ca = shift;
  my $wo = shift;

  my $ope = {
              'wording' => Encode::decode_utf8( $wo ),
              'account' => Encode::decode_utf8( $ac ),
              'date' => Encode::decode_utf8( $da ),
              'dst_account' => '0',
              'amount' => Encode::decode_utf8( $am ),
              'category' => Encode::decode_utf8( $ca )
            };
 
  push @{$ref->{ope}}, $ope;

  return $ref;
}


sub writeXML {
  my $ref = shift;
  my $out = shift;

  my $xs = XML::Simple->new();
  my $xml = $xs->XMLout( $ref, KeyAttr => [  ], RootName => "homebank",
                         XMLDecl => '<?xml version="1.0"?>' );

  open(my $fh, '>', $out) or die "Could not open file '$out' $!";
  print $fh Encode::encode_utf8( $xml );
  close $fh;
}


################################################################################
# Entry point
################################################################################

1;

