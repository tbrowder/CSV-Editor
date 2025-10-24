use v6.d;
use Test;
use CSV::Editor;

plan 4;

my $text = q:to/HERE/;
f1 | f2 | f3
a  |  b | c
# comment
   |    | n
=finish | ignore | rest
HERE

my $t = parse-text($text);
is $t.headers.elems, 3, '3 headers';
is $t.rows.elems, 2, '2 data rows (comments and finish ignored)';
my $fmt = format-table($t);
ok $fmt ~~ / 'f1 | f2 | f3' /, 'formatted header present';
ok $fmt ~~ / ^^ 'a  | b  | c' $$ /, 'formatted first row';
