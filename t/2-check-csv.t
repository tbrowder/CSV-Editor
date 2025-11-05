use v6.d;
use Test;

use File::Find;

use CSV::Editor;
use CSV::Editor::Types;
use CSV::Editor::App;

my $dir = "t/data";
my @files = find :$dir, :type<file>, :name(/:i  '.csv' $/);

my $nf = @files.elems;
for @files.kv -> $i, $file {
    lives-ok {
        #CSV::Editor::App::run($file);
        run($file);
    }, "good csv read of file '$file'";
}
say "saw $nf files";

done-testing;
