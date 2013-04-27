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

package Main;
use strict;
use IO::Socket::INET;
use Crypt::CBC;
use MIME::Base64;

use Net::SSH::Perl;

use base "Exporter";
our @EXPORT    = qw(check_port check_service );


#Port Check function
sub check_port {
         our $IP   = $_[0];
         our $port = $_[1];

my $sock = IO::Socket::INET->new(PeerAddr => $IP,
                                                          PeerPort => $port,
                                                          Proto => 'tcp',
                                                          Type  =>  SOCK_STREAM);

                if($sock){
                        my $port_stat = 'UP';
                        return $port_stat;
                }else{
                        my $port_stat = 'Down';
                        return $port_stat;
                }

}

#Service check function
sub check_service {

	our $IP = $_[0];
        our $command = $_[1];
	our $key = $_[2];

        my  $hash_user = "VCXVos9Hd3U=9@!";
        my  $hash_pass =  "Zor3e5KfQPw=eD@!";
      
        my  $username = decrypt($hash_user,$key);
	my  $password = decrypt($hash_pass,$key);	

       

	my $ssh = Net::SSH::Perl->new( $IP, options => ["UserKnownHostsFile /app/script/.ssh/known_hosts"] );
        $ssh->login( $username, $password);
        #$ssh->debug($msg);
        
        my ( $stdout, $stderr, $exit ) = $ssh->cmd($command);
        
        my ( $hostname,$stderr1, $exit1) =  $ssh->cmd("hostname");

        if ( $exit gt 1 ) {
                print "Script Fail\n";
                exit;
        }else {
                my @chunks = split ' ', $stdout;
                return($chunks[1], $hostname)				
        }
		
}

sub decrypt {
	
	
	my $string = $_[0];
	my $key = $_[1];
	
	my $iv = "bN3RdkPK";

   	my $dec = decode_base64($string);
    
    
    	my $dec_string = Crypt::CBC->new(
    					-cipher      => 'Blowfish',
    					-header      => 'none',
    					-key         => $key,
    					-iv          => $iv,
					 )->decrypt($dec);
					 
	return ($dec_string);
}


