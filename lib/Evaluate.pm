package Evaluate;


sub evaluate {
    my ($ast, $env) = @_;

    if (ref($ast) eq "HASH") {
        if ($ast->{type} eq "SYMBOL") {
            return $env->get($ast->{value});
        } else {
            return $ast->{value};
        }
    } elsif ((ref($ast) eq "ARRAY") and (@$ast > 0)) {
        if (ref(@$ast[0]) eq "HASH") {
            if (@$ast[0]->{value} eq "define") {
                my $symbol = @$ast[1]->{value};
                my $expr = @$ast[2];

                $env->put($symbol, evaluate($expr, $env));
            } else {
                my $proc = evaluate(shift @$ast, $env);
                my @args = @$ast;

                @args = map { evaluate($_, $env); } @args;
                $proc->(@args);
            }
        }
    } else {
        die "Unexpected abstract syntax tree format.";
    }
}

1;

