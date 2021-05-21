#!/usr/bin/perl
use strict;
use warnings;

use IO::Async::Loop;
use Net::Async::Matrix;

our $M_HOST = "matrix.org";
our $M_USER = "user";
our $M_PASS = "password";
our $M_ROOM = "!room.matrix.org";
our $M_TEXT = $ARGV[0] || "No message specified";

do "./config.pm" == 13 or die "Unable to process config.pm!\n";

my $loop = IO::Async::Loop->new;

my $matrix = Net::Async::Matrix->new(server => $M_HOST, SSL => 1);
$loop->add($matrix);

$matrix->login(user_id => $M_USER, password => $M_PASS)->get;

my $room = $matrix->join_room($M_ROOM)->get;

eval { $room->send_message($M_TEXT)->get; 1;} or die "Unable to send message $@";

$loop->loop_once;
