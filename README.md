# Grammar-Common [![Build Status](https://secure.travis-ci.com/raku-community-modules/raku-Grammar-Common.svg?branch=master)](http://travis-ci.com/raku-community-modules/raku-Grammar-Common)

Common bits for grammars, such as math expressions.

All files here will be roles, rather than standalone grammars and actions.
Yes, simple actions are included that return simple hashes containing the parse
tree. You can override these as well, or simply include your own actions.

The test suite shows you how to return more complex objects - I elected not
to do this even though it does make quite a bit more sense because I didn't
want to arbitrary clutter the grammar namespace.

Read the individual Grammar::Common files for more documentation, but these
are generally meant to be dropped in with
'also does Grammar::Common::Expression::Infix;' and using the resulting
<expression> rule as you like.

In most cases default values will be provided, although I'm probably going to
go with C-style variables and values, just because adding a full Perl-style
expression encourages people to think it's reparsing Raku, but that's another
module.

Installation
============

* Using zef (a module management tool bundled with Rakudo Star):

```
    zef update && zef install Grammar::Common
```

## Testing

To run tests:

```
    zef test .
```

## Examples

Using prefix expressions:

```raku
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
$p.parse( '+ 0 b' );
$p.parse( '+ + 1 2 3' );
```

Or common text patterns:

```
grammar Sentences does Grammar::Common::Text {
    token TOP { <sentence>+ % \s+ }
}

say Sentences.parse( "One, two, three.");
say Sentences.parse( "One, two, three. Four, five!");
```

## Author

[Jeffrey Goff](https://github.com/rakudo/rakudo/blob/master/IN-MEMORIAM.md#jeff-goff-drforr)

## License

Artistic License 2.0
