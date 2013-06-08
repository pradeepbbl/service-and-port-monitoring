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
use Data::Dumper;


use base "Exporter";
our @EXPORT    = qw( fnGetHash fnGetSer fnGetName fnGetEnv);



# Load config file and decalar global var
my $cfg = new Config::Simple('./config/config.cfg');


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

sub fnGetEnv {
	my @data = $cfg->param('Env_List.Env_Name');
	return(@data);
}


sub fnGetHash{
	our $env = $_[0];
	
	my @data = ();
	my %hash = ();

	my @services = $cfg->param($env.'_Service_List'.'.'.'Service List');
	
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
	
	return(\%hash);
}

1;
