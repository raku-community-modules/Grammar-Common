use Test;
use Grammar::Common::Text;
use Grammar::Tracer;

grammar Sentences does Grammar::Common::Text {
    token TOP { <sentence>+ % \s+ }
}

subtest "Tokens", {
    ok Sentences.subparse("One", rule => 'words'), "Words";
    ok Sentences.subparse("One", rule => 'first-word'), "First word";
    ok Sentences.subparse("One, two, three", rule => 'sub-sentence'),
            "Sub sentence"
}

ok Sentences.parse( "One, two, three."), "Matches sentence";

done-testing;
