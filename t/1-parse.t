use v6.d;
use Test;
use CSV::Editor;
use CSV::Editor::Types;

# an unformatted Table
my $text = q:to/HERE/;
f1| f2  | f3
a  |  b | c
# comment
  |    | n
=finish | ignore | rest
HERE

# extract the table into a Table object
my $t = parse-text($text);
isa-ok $t, Table, "\$t is a Table";

is $t.headers.elems, 3, '3 header fields';

is $t.rows.elems, 2, '2 data rows (comments and finish ignored)';

# convert the Table into a properly formatted string
my $fmt = format-table($t);
isa-ok $fmt, Str, "a valid Str";
ok $fmt ~~ / \n  /, "has at least one newline";

# split back into lines
my @fmt = $fmt.lines;
isa-ok @fmt, Array, "a valid Array";

say "\@fmt[0] = |{@fmt[0]}|";
ok @fmt.head ~~ / 'f1 | f2 | f3' /, "properly formatted header";

say "\@fmt[1] = |{@fmt[1]}|";
ok @fmt[1] ~~ / 'a  | b  | c' /, "properly formatted first row";

done-testing;


