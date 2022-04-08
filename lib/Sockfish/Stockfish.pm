package Sockfish::Stockfish;

use strict;
use warnings;

use IPC::Run qw(start pump finish);

my @stockfish = ('/usr/games/stockfish');

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

    if ($self->{pondering}) {
        # stop pondering
        ${ $self->{in} } = "stop\n";
        pump $self->{handle} while length ${ $self->{in} };
        pump $self->{handle} until ${ $self->{out} } =~ /bestmove ([a-h][1-8][a-h][1-8][qrbn]?)/;
        ${ $self->{out} } = '';
    }

    # solve the position
    ${ $self->{in} } = "position fen $fen\ngo movetime 1000\n";
    pump $self->{handle} while length ${ $self->{in} };
    pump $self->{handle} until ${ $self->{out} } =~ /bestmove ([a-h][1-8][a-h][1-8][qrbn]?)/;
    ${ $self->{out} } = '';

    # ponder again
    $self->{pondering} = 1;
    ${ $self->{in} } = "go ponder\n";
    pump $self->{handle} while length ${ $self->{in} };

    return $1;
}

1;
