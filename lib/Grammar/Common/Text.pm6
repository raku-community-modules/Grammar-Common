unit role Grammar::Common::Text;

token sentence { <first-word> <separators> <words>* % <separators> <stop>}

token stop { "." | "?" | "!" }

token separators { [","|";"|":"| ")" | "(" ]? \s+ }

token first-word { <:Lt> <[\w \- \' \.]>* }

token words { <[\w \- \' \.]>+ }