package Parse;

use strict;


sub tokenize {
    $_ = shift;

    s/#!.+//g;
    s/#;.+//g;
    s/#\|.+\|#//g;

    /\(|\)|[^\s\(\)]+/g;
}

sub build_ast {
    my $tokens = shift;

    foreach (@$tokens) {
        print "$_\n";
    }

    print "\n";
}

sub parse {
    my $text = shift;

    my @tokens = tokenize $text;
    build_ast \@tokens;
}

1;

