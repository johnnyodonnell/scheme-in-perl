package Evaluate;

use lib "./lib";
use Environment;


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
            } elsif (@$ast[0]->{value} eq "lambda") {
                my $params = @$ast[1];
                my $body = @$ast[2];

                return (sub {
                        my $localEnv = Environment->new({}, $env);

                        foreach my $i (0 .. @_) {
                            $localEnv->put(@$params[$i], $_[$i]);
                        }

                        evaluate($body, $localEnv);
                    });
            } elsif (@$ast[0]->{value} eq "if") {
                my $test = @$ast[1];
                my $conseq = @$ast[2];
                my $alt = @$ast[3];

                if (evaluate($test, $env)) {
                    return evaluate($conseq, $env);
                } else {
                    return evaluate($alt, $env);
                }
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

