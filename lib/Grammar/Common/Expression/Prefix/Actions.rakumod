role Grammar::Common::Expression::Prefix::Actions {
    method operation:sym<plus>( $/ ) {
        make self.plus-operation( $/<lhs>.ast, $/<rhs>.ast );
    }
    method operation:sym<minus>( $/ ) {
        make self.minus-operation( $/<lhs>.ast, $/<rhs>.ast );
    }
    method operation:sym<times>( $/ ) {
        make self.times-operation( $/<lhs>.ast, $/<rhs>.ast );
    }
    method operation:sym<divide>( $/ ) {
        make self.divide-operation( $/<lhs>.ast, $/<rhs>.ast );
    }
    method operation:sym<modulo>( $/ ) {
        make self.modulo-operation( $/<lhs>.ast, $/<rhs>.ast );
    }
    method expression( $/ ) {
        if $/<value> {
            make $/<value>.ast;
        }
        elsif $/<operation> {
            make $/<operation>.made;
        }
    }
}

# vim: expandtab shiftwidth=4
