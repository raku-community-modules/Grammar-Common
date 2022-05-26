role Grammar::Common::Expression::Infix {
    token open-paren-symbol { '(' }
    token close-paren-symbol { ')' }

    token plus-symbol { '+' }
    token minus-symbol { '-' }
    token times-symbol { '*' }
    token divide-symbol { '/' }
    token modulo-symbol { '%' }

    rule term {
        || <minus-symbol>?
            <open-paren-symbol> <expression> <close-paren-symbol>
        || <value>
    }

    proto rule operation { * }
    rule operation:sym<plus> {
        || <lhs=term> <plus-symbol> <rhs=expression>
    }

    rule operation:sym<times> {
        || <lhs=term> <times-symbol> <rhs=expression>
    }

    rule operation:sym<minus> {
        || <lhs=term> <minus-symbol> <rhs=expression>
    }

    rule operation:sym<divide> {
        || <lhs=term> <divide-symbol> <rhs=expression>
    }

    rule operation:sym<modulo> {
        || <lhs=term> <modulo-symbol> <rhs=expression>
    }

    rule expression {
        || <operation>
        || <term>
    }
}

# vim: expandtab shiftwidth=4
