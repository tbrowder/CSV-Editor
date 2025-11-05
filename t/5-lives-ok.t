use v6.d;
use Test;
#use lib 'lib';

plan *;

lives-ok { require ::('CSV::Editor') },      'CSV::Editor loads';
lives-ok { require ::('CSV::Editor::App') }, 'CSV::Editor::App loads';

# Optional GTK smoke only when explicitly enabled and a display exists
if %*ENV<CSV_EDITOR_TEST_GUI> && %*ENV<DISPLAY> {
    lives-ok {
        EVAL q:to/CODE/;
        use GTK::Simple;
        my $w = GTK::Simple::Window.new(:title("smoke"), :width(200), :height(100));
        $w.show-all;
        start { sleep 0.2; GTK::Simple::main-quit }
        GTK::Simple::main;
        CODE
    }, 'GTK smoke loop lives';
}
else {
    diag "Skipping GTK smoke; set CSV_EDITOR_TEST_GUI=1 and DISPLAY to enable.";
}
