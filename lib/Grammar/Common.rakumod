use Grammar::Common::Text;
use Grammar::Common::Expression::Prefix;
use Grammar::Common::Expression::Prefix::Actions;
use Grammar::Common::Expression::Infix;
use Grammar::Common::Expression::Infix::Actions;

=begin pod

=head1 NAME

Grammar::Common - Common bits for grammars, such as math expressions

=head1 SYNOPSIS

=begin code :lang<raku>

use Grammar::Common;  # load all modules:
# Grammar::Common::Text
# Grammar::Common::Expression::Prefix
# Grammar::Common::Expression::Prefix::Actions
# Grammar::Common::Expression::Infix
# Grammar::Common::Expression::Infix::Actions

grammar PostScript does Grammar::Common::Expression::Prefix {
    token value { <[ - + ]>? <[ 0 .. 9 ]>+ }
    rule TOP { 'dup' <expression> }
}

say PostScript.parse( 'dup + 1 3' );
# ｢dup + 1 3｣
# expression => ｢+ 1 3｣
#  operation => ｢+ 1 3｣
#   plus-symbol => ｢+｣
#   lhs => ｢1 ｣
#    value => ｢1｣
#   expression => ｢1 ｣
#    value => ｢1｣
#   expression => ｢3｣
#    value => ｢3｣
#   rhs => ｢3｣
#    value => ｢3｣

=end code

=head1 DESCRIPTION

C<Grammar::Common> gives you a library of common grammar roles to
use in your own code, from simple numbers and strings to validation
tools.

All files here will be roles, rather than standalone grammars and actions.
Yes, simple actions are included that return simple hashes containing the parse
tree. You can override these as well, or simply include your own actions.

The test suite shows you how to return more complex objects - I elected not
to do this even though it does make quite a bit more sense because I didn't
want to arbitrary clutter the grammar namespace.

Read the individual Grammar::Common files: these are generally meant to be
dropped in with C<does Grammar::Common::Expression::Infix> and using the
resulting <expression> rule as you like.

In most cases default values will be provided, although I'm probably going to
go with C-style variables and values, just because adding a full Perl-style
expression encourages people to think it's reparsing Raku, but that's another
module.

=head1 EXAMPLES

Using prefix expressions:

=begin code :lang<raku>

use Grammar::Common::Expression::Prefix;

grammar PostScript does Grammar::Common::Expression::Prefix {
    token c-variable {
        <[ a .. z ]> <[ a .. z A .. Z 0 .. 9 _ ]>*
    }
    token number {
        '-'?  [
            || <[ 1 .. 7 ]> [ <[ 0 .. 7 _ ]> | '_' <[ 0 .. 7 ]> ]*
            || 0
        ]
    }
    token value {
        || <c-variable>
        || <number>
    }

    rule TOP { <expression> }
}
say PostScript.parse( '+ 0 b' );
say PostScript.parse( '+ + 1 2 3' );

=end code

Or common text patterns:

=begin code :lang<raku>

use Grammar::Common::Text;

grammar Sentences does Grammar::Common::Text {
    token TOP { <sentence>+ % \s+ }
}

say Sentences.parse( "One, two, three.");
say Sentences.parse( "One, two, three. Four, five!");

=end code

=head1 AUTHOR

Jeffrey Goff

=head1 COPYRIGHT AND LICENSE

Copyright 2017 - 2018 Jeffrey Goff

Copyright 2019 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
