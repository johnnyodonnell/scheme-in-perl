package Environment;

use strict;


sub new {
    my ($class, $map, $parent)  = @_;

    bless { map => $map, parent => $parent }, $class;
};

sub get {
    my ($self, $key) = @_;

    if (exists $self->{map}{$key}) {
        $self->{map}{$key};
    } elsif (defined $self->{parent}) {
        $self->{parent}->get($key);
    }
}

sub put : lvalue {
    my ($self, $key, $value) = @_;

    if ($value) {
        $self->{map}{$key} = $value;
    } else {
        $self->{map}{$key};
    }
}

our $global = Environment->new({
        "print" => (sub { print "@_\n"; }),
        "*" => (sub {
                my $product = 1;

                foreach (@_) {
                    $product *= $_;
                }

                $product;
            }),
        "+" => (sub {
                my $sum = 0;

                foreach (@_) {
                    $sum += $_;
                }

                $sum;
            }),
        "-" => (sub {
                my ($left, $right) = @_;

                $left - $right;
            }),
        "/" => (sub {
                my ($left, $right) = @_;

                $left / $right;
            }),
        "<" => (sub {
                my ($left, $right) = @_;

                $left < $right;
            }),
        ">" => (sub {
                my ($left, $right) = @_;

                $left > $right;
            }),
        "<=" => (sub {
                my ($left, $right) = @_;

                $left <= $right;
            }),
        ">=" => (sub {
                my ($left, $right) = @_;

                $left >= $right;
            })
    });

