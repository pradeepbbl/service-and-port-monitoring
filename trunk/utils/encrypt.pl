#!/usr/bin/perl
use warnings;
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

