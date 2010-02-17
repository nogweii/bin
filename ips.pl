#!/usr/bin/perl

# ips.pl
# version 0.01
#
# This is a quick hack to apply IPS patches. It is distributed under
# the terms of the GNU General Public License.

if (@ARGV != 2)
{
print STDERR <<EOF;
Usage:

$0 datafile ipsfile

There are no options. Your original datafile is modified.
EOF
exit;
}

open PAT, "$ARGV[1]" or die "Can't open $ARGV[1]";
open DAT, "+<$ARGV[0]" or die "Can't open $ARGV[0]";

read PAT, $data, 5;
die "Bad magic bytes in $ARGV[1]" if $data ne "PATCH";
while(1)
{
read PAT, $data, 3 or die "Read error";
if ($data eq "EOF")
{
print STDERR "Done!n";
exit;
}
# This is ugly, but unpack doesn't have anything that's
# very helpful for THREE-byte numbers.
$address = ord(substr($data,0,1))*256*256 +
ord(substr($data,1,1))*256 +
ord(substr($data,2,1));
print STDERR "At address $address, ";
seek DAT, $address, SEEK_SET or die "Failed seek";

read PAT, $data, 2 or die "Read error";
$length = ord(substr($data,0,1))*256 + ord(substr($data,1,1));
if ($length)
{
print STDERR "Writing $length bytes, ";
read(PAT, $data, $length) == $length or die "Read error";
print DAT $data;
}
else # RLE mode
{
read PAT, $data, 2 or die "Read error";
$length = ord(substr($data,0,1))*256 + ord(substr($data,1,1));
print STDERR "Writing $length bytes of RLE, ";
read PAT, $byte, 1 or die "Read error";
print DAT ($byte)x$length;
}
print STDERR "done\n";
}
