use v6;
use Grammar::Common::Expression::Infix;
use Test;

#############################################################################

grammar InScript does Grammar::Common::Expression::Infix {
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

#############################################################################

my $i = InScript.new;

#`(
subtest {
	nok $i.parse( '' ), 'empty expression';

	subtest {
		subtest {
			nok $i.parse( 'Σ' ), 'unparsable character';
			nok $i.parse( '३' ), 'unparsable number';
			nok $i.parse( '9' ), 'out-of-band digit';
			nok $i.parse( '[' ), 'out-of-band character';
			nok $i.parse( '_' ), 'internal character';
		}, 'unparsable text';

		subtest {
			nok $i.parse( '+' ), 'plus';
			nok $i.parse( '-' ), 'minus';
			nok $i.parse( '*' ), 'times';
			nok $i.parse( '/' ), 'divide';
		}, 'operators standalone';
	}, 'single character';

	subtest {
		nok $i.parse( '+-' ), 'operators';
		nok $i.parse( '-+' ), 'operators';
		nok $i.parse( '00' ), 'invalid number';
		nok $i.parse( '_0' ), 'invalid number';
		nok $i.parse( '_9' ), 'another invalid number';
	}, 'multiple characters';

	subtest {
		subtest {
			nok $i.parse( '+0' );
			nok $i.parse( '*0' );
			nok $i.parse( '/0' );
		}, 'without whitespace';

		subtest {
			nok $i.parse( '+ 0' );
			nok $i.parse( '* 0' );
			nok $i.parse( '/ 0' );
		}, 'with whitespace';
	}, 'operator with single operand';

	subtest {
		subtest {
			nok $i.parse( '+-1' );
			nok $i.parse( '--1' );
			nok $i.parse( '*-1' );
			nok $i.parse( '/-1' );
		}, 'without whitespace';

		subtest {
			nok $i.parse( '+ -1' );
			nok $i.parse( '- -1' );
			nok $i.parse( '* -1' );
			nok $i.parse( '/ -1' );
		}, 'with whitespace';
	}, 'operator with negative single operand';

	subtest {
		nok $i.parse( '1 1' );
		nok $i.parse( '-1 1' );
		nok $i.parse( '1 -1' );
		nok $i.parse( '-1 -1' );
	}, 'two operands';
}, 'failing tests';
)

#`(
subtest {
	subtest {
		subtest {
			ok $i.parse( '0' ), '0';
			ok $i.parse( '1' ), '1';
			ok $i.parse( '7' ), '7';
			ok $i.parse( '-1' ), '-1';
		}, 'single digit';

		subtest {
			ok $i.parse( '10' ), '10';
			ok $i.parse( '1_0' ), '1_0';
		}, 'multiple digits';
	}, 'number';

	subtest {
		ok $i.parse( 'a' ), 'a';
		ok $i.parse( 'a_' ), 'a_';
	}, 'c-variable';
}, 'value';
)

#`(
subtest {
	subtest {
		ok $i.parse( '0 + 1' );
		ok $i.parse( '0 - 1' );
		ok $i.parse( '0 * 1' );
		ok $i.parse( '0 / 1' );
	}, 'op number number';

	subtest {
		ok $i.parse( '0 + b' );
		ok $i.parse( '0 - b' );
		ok $i.parse( '0 * b' );
		ok $i.parse( '0 / b' );
	}, 'op number variable';

	subtest {
		ok $i.parse( 'a + 1' );
		ok $i.parse( 'a - 1' );
		ok $i.parse( 'a * 1' );
		ok $i.parse( 'a / 1' );
	}, 'op variable number';

	subtest {
		ok $i.parse( 'a + b' );
		ok $i.parse( 'a - b' );
		ok $i.parse( 'a * b' );
		ok $i.parse( 'a / b' );
	}, 'op variable variable';
}, 'single operand';
)

#`(
subtest {
	subtest {
		ok $i.parse( '( 0 )' );

		ok $i.parse( '( 0 + 1 )' );
		ok $i.parse( '( 0 - 1 )' );
		ok $i.parse( '( 0 * 1 )' );
		ok $i.parse( '( 0 / 1 )' );
	}, 'parentheses';

	subtest {
		ok $i.parse( '-1 + ( 0 ) + -1' );

		ok $i.parse( '-1 + ( 0 + 1 ) + -1' );
		ok $i.parse( '-1 - ( 0 - 1 ) - -1' );
		ok $i.parse( '-1 * ( 0 * 1 ) * -1' );
		ok $i.parse( '-1 / ( 0 / 1 ) / -1' );
	}, 'parentheses';
}, 'parentheses';
)

#`(
subtest {
	ok $i.parse( '1 + 2 + 3' );

#	ok $i.parse( '-1 + -2 + -3' );
#	ok $i.parse( '++a 2c' );
}, 'two operands';
)

subtest {
	ok $i.parse('( 1 + ( 1 + 1 ) + 1 )'), '(1+(1+1)+1)';
	ok $i.parse('( 1 + ( 1 + 1 ) / 1 )'), '(1+(1+1)/1)';
	ok $i.parse('( 1 + ( 1 / 1 ) + 1 )'), '(1+(1/1)+1)';
	ok $i.parse('( 1 + ( 1 / 1 ) / 1 )'), '(1+(1/1)/1)';
	ok $i.parse('( 1 / ( 1 + 1 ) + 1 )'), '(1/(1+1)+1)';
	ok $i.parse('( 1 / ( 1 + 1 ) / 1 )'), '(1/(1+1)/1)';
	ok $i.parse('( 1 / ( 1 / 1 ) + 1 )'), '(1/(1/1)+1)';
	ok $i.parse('( 1 / ( 1 / 1 ) / 1 )'), '(1/(1/1)/1)';

	ok $i.parse('1 + ( 1 + 1 ) + 1'), Q{1+(1+1)+1};
	ok $i.parse('1 + 1 + 1 + 1'), Q{1+1+1+1};
	ok $i.parse('1 + ( 1 + 1 ) / 1'), Q{1+(1+1)/1};
	ok $i.parse('1 + 1 + 1 / 1'), Q{1+1+1/1};
	ok $i.parse('1 + ( 1 / 1 ) + 1'), Q{1+(1/1)+1};
	ok $i.parse('1 + 1 / 1 + 1'), Q{1+1/1+1};
	ok $i.parse('1 + ( 1 / 1 ) / 1'), Q{1+(1/1)/1};
	ok $i.parse('1 + 1 / 1 / 1'), Q{1+1/1/1};
	ok $i.parse('1 / ( 1 + 1 ) + 1'), Q{1/(1+1)+1};
	ok $i.parse('1 / 1 + 1 / 1'), Q{1/1+1+1};
	ok $i.parse('1 / ( 1 + 1 ) + 1'), Q{1/(1+1)/1};
	ok $i.parse('1 / 1 + 1 / 1'), Q{1/1+1/1};
	ok $i.parse('1 / ( 1 / 1 ) + 1'), Q{1/(1/1)+1};
	ok $i.parse('1 / 1 / 1 + 1'), Q{1/1/1+1};
	ok $i.parse('1 / ( 1 / 1 ) / 1'), Q{1/(1/1)/1};
	ok $i.parse('1 / 1 / 1 / 1'), Q{1/1 /1/1};
}, 'three operators';

# If you haven't spotted the pattern by now, it's pretty simple.
# Start with the paren at the left, move it along to every possible spot
# in the expression until it reaches the end, then move the paren one along
# and repeat.

# And don't forget multiple parens... aiyee.

subtest {
	subtest {
		ok $i.parse('( 1 ) + 1 + 1'), '( 1 ) + 1 + 1';
		ok $i.parse('( 1 ) + 1 / 1'), '( 1 ) + 1 / 1';
		ok $i.parse('( 1 ) / 1 + 1'), '( 1 ) / 1 + 1';
		ok $i.parse('( 1 ) / 1 / 1'), '( 1 ) / 1 / 1';

		ok $i.parse('( 1 + 1 ) + 1'), '( 1 + 1 ) + 1';
		ok $i.parse('( 1 + 1 ) / 1'), '( 1 + 1 ) / 1';
		ok $i.parse('( 1 / 1 ) + 1'), '( 1 / 1 ) + 1';
		ok $i.parse('( 1 / 1 ) / 1'), '( 1 / 1 ) / 1';

		ok $i.parse('( 1 + 1 + 1 )'), '( 1 + 1 + 1 )';
		ok $i.parse('( 1 + 1 / 1 )'), '( 1 + 1 / 1 )';
		ok $i.parse('( 1 / 1 + 1 )'), '( 1 / 1 + 1 )';
		ok $i.parse('( 1 / 1 / 1 )'), '( 1 / 1 / 1 )';

		ok $i.parse('1 + ( 1 ) + 1'), '1 + ( 1 ) + 1';
		ok $i.parse('1 + ( 1 ) / 1'), '1 + ( 1 ) / 1';
		ok $i.parse('1 / ( 1 ) + 1'), '1 / ( 1 ) + 1';
		ok $i.parse('1 / ( 1 ) / 1'), '1 / ( 1 ) / 1';

		ok $i.parse('1 + ( 1 + 1 )'), '1 + ( 1 + 1 )';
		ok $i.parse('1 + ( 1 / 1 )'), '1 + ( 1 / 1 )';
		ok $i.parse('1 / ( 1 + 1 )'), '1 / ( 1 + 1 )';
		ok $i.parse('1 / ( 1 / 1 )'), '1 / ( 1 / 1 )';
	}, 'with parens';

	ok $i.parse('1 / 1 / 1'), '1/1/1';
	ok $i.parse('1 / 1 + 1'), '1/1+1';
	ok $i.parse('1 + 1 / 1'), '1+1/1';
	ok $i.parse('1 + 1 + 1'), '1+1+1';
}, 'two operators';

subtest {
	subtest {
		ok $i.parse('( 1 ) + 1'), '(1)+1';
		ok $i.parse('( 1 ) / 1'), '(1)/1';

		ok $i.parse('( 1 + 1 )'), '(1+1)';
		ok $i.parse('( 1 / 1 )'), '(1/1)';

		ok $i.parse('1 + ( 1 )'), '1+(1)';
		ok $i.parse('1 / ( 1 )'), '1/(1)';
	}, 'with parens';

	ok $i.parse('1 + 1'), '1+1';
	ok $i.parse('1 / 1'), '1/1';
}, 'single operator';

subtest {
	ok $i.parse('( ( ( 1 ) ) )'), '( ( ( 1 ) ) )';
	ok $i.parse('( 1 )'), '( 1 )';
	ok $i.parse('1'), '1';
}, 'single value';

done-testing;

# vim: ft=perl6
