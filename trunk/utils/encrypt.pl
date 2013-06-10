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
use Crypt::CBC;
use MIME::Base64;


my $iv  = "bN3RdkPK";
my $string = $ARGV[0];
my $key = $ARGV[1];

sub encrypt{
	  my $cipher = Crypt::CBC->new(
   	  		-cipher  => 'Blowfish',
    		-header  => 'none',
    		-key     => $key,
    		-iv      => $iv,
      );

   my $enc = $cipher->encrypt($string);
   my $enc_string = encode_base64($enc);
   print $enc_string."\n"; 
}

&encrypt;

