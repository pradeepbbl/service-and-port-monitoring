#!/usr/bin/perl -w

=for Copyright 
Service and port monitoring.

    Copyright (C) 2013  Pradeep Mishra. Email:- pradeepbbl@gmail.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


=cut

use strict;
use Data::Dumper;
use lib './libs';

#Custom module 
use GetData;
use Excel;
use Main;


my $arg = $ARGV[0];
my $key = $ARGV[1];


my $size = scalar (@ARGV);



sub fnMain{
	
	my $env = $_[0];
	
	# Gloal Var
	my %port_status = ();
	my %service_status = ();
	my @data = ();

	# Get env refernece hash
	my $hash  = fnGetHash($env);
	
	# Get list of service of stage from config.pm
	my @ser_list = fnGetSer($env.'_Service_List');

	my($workbook,$worksheet,$up,$down,$service) = fnExcelReport($env);

    	my $ser_cel = '4';
   	my $port_cel = '4';
	
	
	foreach my $service(@ser_list){
		my $service_name = fnGetName($service);
		my $port_list = $hash->{$service_name}->{port};
		my $ip_list   = $hash->{$service_name}->{ip_list};
                my $command   = $hash->{$service_name}->{command};
     	
     $worksheet->write('B'.$ser_cel,$service_name);
     	
      foreach my $ip(@$ip_list){
      	  
		foreach my $port(@$port_list){
      		my $port_sta = check_port($ip,$port);
      	 	$port_status{$service_name}{$ip}{$port} = ($port_sta);
      	}
      	my($pid,$hostname) = check_service($ip,$command,$key);
      		$service_status{$service_name}{$ip}=(
      				{
      				hostname => $hostname,
      				pid => $pid
      				}
      		);	

	    my @port  = keys %{$port_status{$service_name}{$ip}};
	    my $count    = keys %{$port_status{$service_name}{$ip}};
    	my @ary_up   = grep{/UP/} values %{$port_status{$service_name}{$ip}};
    	my @ary_down = grep{/Down/} values %{$port_status{$service_name}{$ip}};
    	
    	push(@data,[$service_status{$service_name}{$ip}->{hostname},$ip,$service_status{$service_name}{$ip}->{pid},join " ", @port]);
    	
    	$worksheet->write_col('C'.$port_cel, \@data);
    	
    	#print scalar @ary_up."\n";
    	if (scalar @ary_up == $count ){
            $worksheet->write('G'.$port_cel,"Up",$up);
    	}elsif (scalar @ary_down == $count) {
    		$worksheet->write('G'.$port_cel,"Down",$down);
    	}else{
    		$worksheet->write('G'.$port_cel,"Port's need to be check mauaaly",$down)
    	}
    	   	
      	if (defined $service_status{$service_name}{$ip}->{pid}){
			$worksheet->write('H'.$port_cel,'Online',$up)      		
      	}else{
      		$worksheet->write('H'.$port_cel,'Offline',$down);
      	}
      
      	$port_cel++;
        $ser_cel++;
        undef @data;
      }		
	  
	  
	  $ser_cel++;
	  $port_cel++;  
	  # Generate report
	 }

	autofit_columns($worksheet);
	$workbook->close();
}


	if ($size == 2 &&  $arg ne "all"){
		&fnMain($arg);
	}else{
	print "Invalid or no arragument passed. Please refer document for more details"."\n";
	}
      




