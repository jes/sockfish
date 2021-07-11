package Sockfish::Stockfish;

use strict;
use warnings;

use IPC::Run qw(start pump finish);

my @stockfish = ('stockfish');

sub new {
    my ($pkg, %args) = @_;

    my $self = bless \%args, $pkg;

    my $in;
    my $out;
    $self->{handle} = start \@stockfish, \$in, \$out;
    $self->{in} = \$in;
    $self->{out} = \$out;

    return $self;
}

sub solve {
    my ($self, $fen) = @_;

    ${ $self->{in} } = "position fen $fen\ngo nodes 100000\n";
    pump $self->{handle} while length ${ $self->{in} };
    pump $self->{handle} until ${ $self->{out} } =~ /bestmove ([a-h][1-8][a-h][1-8][qrbn]?)/;

    ${ $self->{out} } = '';

    return $1;
}

1;
