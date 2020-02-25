package Parse;

use strict;


sub tokenize {
    $_ = shift;

    s/#!.+//g;
    s/#;.+//g;
    s/#\|.+\|#//g;

    /\(|\)|\".*\"|[^\s\(\)]+/g;
}

sub atom {
    $_ = shift;

    if (/^\"(.*)\"$/) {
        { type => "STRING", value => $1 };
    } elsif (my $number = $_ + 0) {
        { type => "NUMBER", value => $number };
    } else {
        { type => "SYMBOL", value => $_ };
    }
}

sub build_ast {
    my $tokens = shift;

    my @ast_stack = ();
    my $current_ast = [];

    foreach (@$tokens) {
        if ($_ eq "(") {
            my $new_ast = [];
            push @ast_stack, $current_ast;
            push @$current_ast, $new_ast;
            $current_ast = $new_ast;
        } elsif ($_ eq ")") {
            $current_ast = pop @ast_stack;
        } else {
            push @$current_ast, atom $_;
        }
    }

    $current_ast;
}

sub parse {
    my $text = shift;

    my @tokens = tokenize $text;
    build_ast \@tokens;
}

1;

