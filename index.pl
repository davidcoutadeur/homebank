#!/usr/bin/perl

use strict;
use warnings;

use HTML::Template;
use Budget;
use CGI;


# Variables
################################################################################

my $template_file = 'index.tpl';

my $homebank_file="budget.xhb";
my $ref; # hashref to store homebank XML structure

my %categories; # categories taken from homebank file
my $fileout = "budget.xhb";

# Operation variables to fill
my ( $date, $amount, $account, $category, $wording );

# Default values for top alert bar
my $alert = 0;
my $alertStyle = "";
my $alertRes = "";
my $alertMsg = "";

# cgi element for getting POST parameters
my $q = new CGI;

$date = $q->param('dateinput');
$amount = $q->param('textinput');
$category = $q->param('selectbasic');
$wording = $q->param('textinputdesc');

# account number is defined by default to 1
$account = 1;

# max printed operations
my $max_operations = 30;


# Functions
################################################################################



# Entry point
################################################################################


$ref = Budget::getXML($ref, $homebank_file);


if ( defined($date) and defined($amount) and 
     defined($category) and defined($wording) )
{
  ADDOPERATION:{
    # Add operation in homebank xml file
  
    # convert date to timestamp
    my $ts = Budget::dateToTimestamp($date);
    if( $ts == 0 )
    { # invalid date format
      $alert = 1;
      $alertStyle = "alert-danger";
      $alertRes = "Erreur !";
      $alertMsg = "Date invalide : $date";
      print STDERR "Homebank: Error: invalid date: $date\n";
      last ADDOPERATION;
    }
  
    # delete + symbol in operation
    $amount =~ s/\+//;
  
    # Insert new operation in xml
    $ref = Budget::insertOperation($ref, $ts, $amount, $account, $category, $wording);
    
    # Write new xml
    Budget::writeXML($ref, $fileout);

    # Checking if operation is correctly saved
    my $success = system("grep $ts $fileout | grep -q '".$wording."'");
  
    if( $success == 0 )
    { # operation saved with success
      $alert = 1;
      $alertStyle = "alert-success";
      $alertRes = "Succès !";
      $alertMsg = "L'opération a bien été enregistrée";
    }
    else
    { # operation failed
      $alert = 1;
      $alertStyle = "alert-danger";
      $alertRes = "Erreur !";
      $alertMsg = "L'opération n'a pas été enregistrée correctement";
      print STDERR "Homebank: Error: operation not correctly saved in xml file\n";
      last ADDOPERATION;
    }
  }
}

# get categories
%categories = Budget::getCategories($ref);
my $cat ="";
  
# format categories
foreach my $key ( sort {$a <=> $b} keys %categories ) {
  $cat.="      <option value=\"$key\">$categories{$key}</option>\n";
}

# get old operations
my $ope = Budget::getOperations($ref, \%categories);

# reverse sort operations and don't display too old operations
my @sorted_ope =  sort { $a->{date} <=> $b->{date} } @$ope;
my @rsorted_ope = reverse @sorted_ope;
splice @rsorted_ope, $max_operations;

  
# prepare template file
my $template = HTML::Template->new(filename => $template_file,);
 
# fill the categories in the template
$template->param( OPERATIONS => \@rsorted_ope,
                  CATEGORIES => $cat,
                  ALERT => $alert,
                  ALERT_STYLE => $alertStyle,
                  ALERT_RES => $alertRes,
                  ALERT_MSG => $alertMsg, );


# Write HTML page
print "Content-Type: text/html\n\n";
print $template->output;


