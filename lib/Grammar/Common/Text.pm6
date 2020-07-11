unit role Grammar::Common::Text;

token sentence { <first-word> <.separators> <sub-sentence> <.stop>}

token stop { "." | "?" | "!" }

token sub-sentence { <words>* % <.separators> }
token separators { [","|";"|":" ]? \s+ }

token first-word { <:Lu> <[\w \- \' \.]>* }

token words { <[\w \- \']>+ }
