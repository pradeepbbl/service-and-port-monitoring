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

package Excel;
use strict;
use Spreadsheet::WriteExcel;


use base "Exporter";
our @EXPORT    = qw($workbook $stage $prod $up $down $service $dev autofit_columns);

sub fnExcelReport(){

    # Create a new Excel workbook
    my $workbook = Spreadsheet::WriteExcel->new("port_service.xls");

    my $heading = $workbook->add_format(align => 'center', bold => 1, border   => 1,fg_color => 22);
    my $up      =  $workbook->add_format(align => 'center', bold => 1, border   => 1, fg_color => 11);
    my $down    =  $workbook->add_format(align => 'center', bold => 1, border   => 1, fg_color => 10);
    my $service = $workbook->add_format(size=>10,bold => 1);


    # Add some worksheets
    my $dev   = $workbook->add_worksheet("Dev");
    my $stage = $workbook->add_worksheet("Stage");
    my $prod  = $workbook->add_worksheet("Prod");
    
    $dev->add_write_handler(qr[\w], \&store_string_widths);
    $stage->add_write_handler(qr[\w], \&store_string_widths);
    $prod->add_write_handler(qr[\w], \&store_string_widths);

	$dev->write('B3', "Service Name", $heading);
    $dev->write('C3', "Host Name", $heading);
    $dev->write('D3', "NAT IP", $heading);
    $dev->write('E3', "PID  ",  $heading);
    $dev->write('F3', "PORT", $heading);
    $dev->write('G3', "PORT Status", $heading);
    $dev->write('H3', "Service Status", $heading);   

    $stage->write('B3', "Service Name", $heading);
    $stage->write('C3', "Host Name", $heading);
    $stage->write('D3', "NAT IP", $heading);
    $stage->write('E3', "PID  ",  $heading);
    $stage->write('F3', "PORT", $heading);
    $stage->write('G3', "PORT Status", $heading);
    $stage->write('H3', "Service Status", $heading);   
 
    $prod->write('B3', "Service Name", $heading);
    $prod->write('C3', "Host Name", $heading);
    $prod->write('D3', "NAT IP", $heading);
    $prod->write('E3', "PID  ",  $heading);
    $prod->write('F3', "PORT", $heading);
    $prod->write('G3', "PORT Status", $heading);
    $prod->write('H3', "Service Status", $heading);


    return($workbook,$stage,$prod,$up,$down,$service,$dev);
}


	###############################################################################
    #
    # Functions used for Autofit.
    #
    ###############################################################################
    
    ###############################################################################
    #
    # Adjust the column widths to fit the longest string in the column.
    #
    sub autofit_columns {
    
        our $worksheet = shift;
        #our $worksheet_ext = shift;
        my $col       = 0;
    
        for my $width (@{$worksheet->{__col_widths}}) {
    
            $worksheet->set_column($col, $col, $width) if $width;
            $col++;
        }
        
      
    }
    
    
    ###############################################################################
    #
    # The following function is a callback that was added via add_write_handler()
    # above. It modifies the write() function so that it stores the maximum
    # unwrapped width of a string in a column.
    #
    sub store_string_widths {
    
        my $worksheet = shift;
        my $col       = $_[1];
        my $token     = $_[2];
    
        # Ignore some tokens that we aren't interested in.
        return if not defined $token;       # Ignore undefs.
        return if $token eq '';             # Ignore blank cells.
        return if ref $token eq 'ARRAY';    # Ignore array refs.
        return if $token =~ /^=/;           # Ignore formula
    
        # Ignore numbers
        return if $token =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/;
    
        # Ignore various internal and external hyperlinks. In a real scenario
        # you may wish to track the length of the optional strings used with
        # urls.
        return if $token =~ m{^[fh]tt?ps?://};
        return if $token =~ m{^mailto:};
        return if $token =~ m{^(?:in|ex)ternal:};
    
    
        # We store the string width as data in the Worksheet object. We use
        # a double underscore key name to avoid conflicts with future names.
        #
        my $old_width    = $worksheet->{__col_widths}->[$col];
        my $string_width = string_width($token);
    
        if (not defined $old_width or $string_width > $old_width) {
            # You may wish to set a minimum column width as follows.
            #return undef if $string_width < 10;
    
            $worksheet->{__col_widths}->[$col] = $string_width;
        }
    
    
        # Return control to write();
        return undef;
    }
    
    
    ###############################################################################
    #
    # Very simple conversion between string length and string width for Arial 10.
    # See below for a more sophisticated method.
    #
    sub string_width {
    
        require Font::TTFMetrics;
    
        my $arial        = Font::TTFMetrics->new('/usr/share/fonts/msttcorefonts/arial.ttf');
    
        my $font_size    = 10;
        my $dpi          = 96;
        my $units_per_em = $arial->get_units_per_em();
        my $font_width   = $arial->string_width($_[0]);
    
        # Convert to pixels as per TTFMetrics docs.
        my $pixel_width  = 6 + $font_width *$font_size *$dpi /(72 *$units_per_em);
    
        # Add extra pixels for border around text.
        $pixel_width  += 6;
    
        # Convert to cell width (for Arial) and for cell widths > 1.
        my $cell_width   = ($pixel_width -5) /7;
    
        return $cell_width;
    
    }

our($workbook,$stage,$prod,$up,$down,$service,$dev) = fnExcelReport();
