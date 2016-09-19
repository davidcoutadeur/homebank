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


# Functions
################################################################################



# Entry point
################################################################################

my $q = new CGI;

$date = $q->param('dateinput');
$amount = $q->param('textinput');
$account = 1;
$category = $q->param('selectbasic');
$wording = $q->param('textinputdesc');

$ref = Budget::getXML($ref, $homebank_file);


if ( defined($date) and defined($amount) and 
     defined($category) and defined($wording) )
{
  ADDOPERATION:{
    # Add a line in homebank xml file
  
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
    my $success = system("grep $ts $fileout | grep -q $wording");
  
    if( $success == 0 )
    { # operation saved with success
      $alert = 1;
      $alertStyle = "alert-success";
      $alertRes = "Succès !";
      $alertMsg = "L'opération a bien été sauvée";
    }
    else
    { # operation failed
      $alert = 1;
      $alertStyle = "alert-danger";
      $alertRes = "Erreur !";
      $alertMsg = "L'opération a été sauvée";
      print STDERR "Homebank: Error: operation not correctly saved in xml file\n";
      last ADDOPERATION;
    }
  }
}

%categories = Budget::getCategories($ref);
my $cat ="";
  
# Get categories
foreach my $key ( sort {$a <=> $b} keys %categories ) {
  $cat.="      <option value=\"$key\">$categories{$key}</option>\n";
}
  
# prepare template file
my $template = HTML::Template->new(filename => $template_file,);
 
# fill the categories in the template
$template->param( CATEGORIES => $cat,
                  ALERT => $alert,
                  ALERT_STYLE => $alertStyle,
                  ALERT_RES => $alertRes,
                  ALERT_MSG => $alertMsg, );

# Write HTML page
print "Content-Type: text/html\n\n";
print $template->output;


