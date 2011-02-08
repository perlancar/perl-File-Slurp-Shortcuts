package File::Slurp::Shortcuts;
# ABSTRACT: Several shortcut functions for File::Slurp

use 5.010; # yes, i know, i'm spoilt.
use strict;
use warnings;

use File::Slurp qw();

our @my_replace  = qw(read_file    slurp);
our @my_exportok = qw(read_file_c  slurp_c
                      read_file_cq slurp_cq
                      read_file_q  slurp_q);

use base qw(Exporter);
our %EXPORT_TAGS = %File::Slurp::EXPORT_TAGS;
our @EXPORT      = @File::Slurp::EXPORT;
our @EXPORT_OK   = (@File::Slurp::EXPORT_OK, @my_exportok);

no strict 'refs';
# import all of File::Slurp, except our own replacement
for (@File::Slurp::EXPORT, @File::Slurp::EXPORT_OK) {
    *{$_} = \&{"File::Slurp::".$_} unless $_ ~~ @my_replace;
}

sub read_file {
    my ($path, %opts) = @_;
    my $wa = wantarray;

    my $res;
    my @res;
    if ($wa) {
        @res = File::Slurp::read_file($path, %opts);
        if ($opts{chomp}) { chomp for @res }
        return @res;
    } else {
        $res = File::Slurp::read_file($path, %opts);
        if ($res && $opts{chomp}) { chomp $res }
        return $res;
    }
}
*slurp = \&read_file;

sub read_file_cq {
    my ($path, %opts) = @_;
    $opts{err_mode} //= 'quiet';
    $opts{chomp}    //= 1;
    read_file($path, %opts);
}
*slurp_cq = \&read_file_cq;

sub read_file_c {
    my ($path, %opts) = @_;
    $opts{chomp}    //= 1;
    read_file($path, %opts);
}
*slurp_c = \&read_file_c;

sub read_file_q {
    my ($path, %opts) = @_;
    $opts{err_mode} //= 'quiet';
    read_file($path, %opts);
}
*slurp_q = \&read_file_q;

1;
__END__

=head1 SYNOPSIS

 # instead of 'use File::Slurp', you 'use File::Slurp::Shortcuts' instead
 use File::Slurp::Shortcuts qw(slurp_cq ...);
 my $email   = slurp_cq('/home/user1/etc/email');
 my @domains = slurp_cq('/home/user1/etc/domains');
 ...

=head1 DESCRIPTION

File::Slurp::Shortcuts is a drop-in replacement for L<File::Slurp>, offering
more shortcut functions for convenience. It currently also adds autochomping to
read_file().

About autochomping: It is supposed to be in the upcoming version of
L<File::Slurp>, but since I'm tired of waiting, this module is the band-aid
solution. It wraps read_file() (and slurp()) so it handles the B<chomp> option.
It reads in file containing, e.g. "foo\n" into Perl data as "foo".

=head1 FUNCTIONS

=for Pod::Coverage (append_file|overwrite_file|read_dir|read_file|slurp|write_file)

For the complete list of functions available, see File::Slurp. Below are
functions introduced by File::Slurp::Shortcuts:

=head2 read_file_c($path, %opts) (or slurp_c)

Shortcut for:

 read_file('path', chomp=>1, ...)

=head2 read_file_cq($path, %opts) (or slurp_cq)

Shortcut for:

 read_file('path', chomp=>1, err_mode=>'quiet', ...)

I use this a lot to retrieve configuration value from files.

=head2 read_file_q($path, %opts) (or slurp_q)

Shortcut for:

 read_file('path', err_mode=>'quiet', ...)

I use this a lot to read files that are optional.

=head1 SEE ALSO

L<File::Slurp>, obviously.

=cut

1;
