#!/usr/bin/perl
#
# Nagios check for Psentinel
# Author: Eugenio Marzo

use IO::Socket;
use Getopt::Long;
use Switch;
$EXIT_OK=0;
$EXIT_WARNING=1;
$EXIT_CRITICAL=2;
$EXIT_UNKNOWN=3;
$EXIT_STRING="";
$script_name = `echo $0`;
$script_name  =~ s/\n//g;
$help='';
$port;
$severity='';

sub check {
	#print "\n\n";
	#print "Checking " . $_[0] . " on port " . $_[1] . " (exit code " . $_[2] . ") ...  \n\n" ;
        my $string_to_check = "HTTP\/1.0 ". $_[2];
	my $sock = new IO::Socket::INET (
                                  PeerAddr => "127.0.0.1",
                                  PeerPort => $_[1],
                                  Proto => 'tcp',
                                 );
	die "Could not create socket: $!\n" unless $sock;

        print $sock "\n";
	$data = <$sock>;
	#print $data;
       	close($sock);
        if ( $data =~ /$string_to_check/ ) 
           { 
	      $EXIT_STRING = $EXIT_STRING . " " . "Psentinel returns " . $_[2] . " for " . $_[0] . ";" ; }    
}



GetOptions ('port=s' => \$port,
            'severity=s' => \$severity,
	    'help' => \$help) 
                                 or die("Error in command line arguments\n");



if ($help)
 {
	print "\n\n";
	print "Usage: " . $script_name . "  --port svc1:p1:exit_code,svc2:p2,exit_code   --severity= CRITICAL ||  WARNING || UNKNOWN ...  \n\n";
 	print "Example:  " . $script_name . "  --port tomcat1:48081:500,tomcat2:48082:500 --severity CRITICAL\n\n";
        print "\n\n";
 }

else {

	foreach $p  (split(/,/, $port))
	{    
           @split = split(/:/, $p); 
           if ($p  =~ /^[a-zA-Z0-9]{1,}:[0-9]{1,5}:[0-9]{1,3}$/ && length(@split[2]) <=  3 and int(@split[1]) <= 65535 ) {
           	$psentinel_port = @split[1];
          	$psentinel_svc =  @split[0];
                $psentinel_code = @split[2];
           	check($psentinel_svc,$psentinel_port,$psentinel_code); }
           else {
                 print "invalid options.. \n\n";
                 exit($EXIT_UNKNOWN)
                                       }    

	}

}




if ( ! $EXIT_STRING) {  
			  print "OK"; 
  			  exit($EXIT_OK); 
 }
else {

                          switch($severity)  {
				    case "WARNING" { print $EXIT_STRING; exit($EXIT_WARNING); }
    				    case "UNKNOWN" { print $EXIT_STRING; exit($EXIT_UNKNOWN); }
    			            else { print $EXIT_STRING; exit($EXIT_CRITICAL); } } } 
