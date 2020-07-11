use Test;
use Grammar::Common::Text;

grammar Sentences does Grammar::Common::Text {
    token TOP { <sentence>+ % \s+ }
}

ok Sentences.parse( "One, two, three.");

done-testing;
