use Test;
use Grammar::Common::Text;

grammar Sentences does Grammar::Common::Text {
    token TOP { <sentence>+ % \s+ }
}

subtest "Tokens", {
    ok Sentences.subparse("One", rule => 'words'), "Words";
    ok Sentences.subparse("One", rule => 'first-word'), "First word";
    ok Sentences.subparse("One, two, three", rule => 'sub-sentence'),
        "Sub sentence";
}

subtest "Grammar", {
    ok Sentences.parse( "One, two, three."), "Matches sentence";
    my $str =  "One, two, three. Four, five!";
    my $match = Sentences.parse( $str );
    is $match, $str, "Two sentences";
    is $match<sentence>[0].Hash<first-word>, "One", "Tokenized";
}


done-testing;
