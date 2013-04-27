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

package GetData;
use strict;
use Config::Simple;
use IO::Socket::INET;

use base "Exporter";
our @EXPORT    = qw( %stg %prod %dev fnGetSer fnGetName);



# Load config file and decalar global var
my $cfg = new Config::Simple('./config/config.cfg');
my @data = ();
my @active = ();



#Global Function
sub fnGetSer {
    our $tmp = $_[0];
	my @data = $cfg->param($tmp.'.'.'Service List');
	return(@data);
	
}

sub fnGetName {
	our $ser = $_[0];
	my $data = $cfg->param($ser.'.'.'Service Name');
	return($data);
}


sub fnDevMain(){
	my @data = ();
	my %hash = ();
	
	my @services = $cfg->param('DEV_Service_List.Service List');
	
	foreach my $service (@services){
    my $app_pool 	 = $cfg->param($service.'.'.'Hosted On');		
	$hash{$cfg->param($service.'.'.'Service Name')} = (
			   {	
				port     => [$cfg->param($service.'.'.'Port List')],
				app_pool => $cfg->param($service.'.'.'Hosted On'),
				ip_list  => [$cfg->param($app_pool.'.'.'Nat IP')],
				command  => $cfg->param($service.'.'.'Command') 
				}
			 
			);
	push(@data,\%hash);			
	}
	
	return(%hash);
}

sub fnStgMain(){
	my @data = ();
	my %hash = ();
	
	my @services = $cfg->param('STG_Service_List.Service List');
	
	foreach my $service (@services){
    my $app_pool 	 = $cfg->param($service.'.'.'Hosted On');		
	$hash{$cfg->param($service.'.'.'Service Name')} = (
			   {	
				port     => [$cfg->param($service.'.'.'Port List')],
				app_pool => $cfg->param($service.'.'.'Hosted On'),
				ip_list  => [$cfg->param($app_pool.'.'.'Nat IP')],
				command  => $cfg->param($service.'.'.'Command') 
				}
			 
			);
	push(@data,\%hash);			
	}
	
	return(%hash);
}

sub fnProdMain(){
	my @data = ();
	my %hash = ();
	
	my @services = $cfg->param('Prod_Service_List.Service List');
	
	foreach my $service (@services){
    my $app_pool 	 = $cfg->param($service.'.'.'Hosted On');		
	$hash{$cfg->param($service.'.'.'Service Name')} = (
			   {	
				port => [$cfg->param($service.'.'.'Port List')],
				app_pool => $cfg->param($service.'.'.'Hosted On'),
				ip_list => [$cfg->param($app_pool.'.'.'Nat IP')],
				command  => $cfg->param($service.'.'.'Command')
				}
			 
			);
	push(@data,\%hash);			
	}
	
	return(%hash);
}

our  %dev  = fnDevMain();
our  %stg  = fnStgMain();
our  %prod = fnProdMain();



1;
