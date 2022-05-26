role Grammar::Common::Expression::Prefix {
    token plus-symbol { '+' }
    token minus-symbol { '-' }
    token times-symbol { '*' }
    token divide-symbol { '/' }
    token modulo-symbol { '%' }

    proto rule operation { * }
    rule operation:sym<plus> {
        <plus-symbol> <lhs=expression> <rhs=expression>
    }

    rule operation:sym<minus> {
        <minus-symbol> <lhs=expression> <rhs=expression>
    }

    rule operation:sym<times> {
        <times-symbol> <lhs=expression> <rhs=expression>
    }

    rule operation:sym<divide> {
        <divide-symbol> <lhs=expression> <rhs=expression>
    }

    rule operation:sym<modulo> {
        <modulo-symbol> <lhs=expression> <rhs=expression>
    }

    rule expression {
        || <value>
        || <operation>
    }
}

# vim: expandtab shiftwidth=4
