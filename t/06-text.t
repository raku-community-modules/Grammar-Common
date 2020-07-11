use Test;
use Grammar::Common::Text;

grammar Sentences does Grammar::Common::Text {
    token TOP { <sentence>+ % \s+ }
}

class Sentences-Actions {
    method TOP ($/) {
	make gather for $/<sentence> -> $sntnc {
	    take ~$sntnc;
	}
    }
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

subtest "Actions", {
    my $parsed = Sentences.parse( "One, two, three? Four, five!", actions => Sentences-Actions.new );
    is $parsed.made.elems, 2, "Sentence tokenized";
    is $parsed.made[0], "One, two, three?", "First sentence";
}

done-testing;
