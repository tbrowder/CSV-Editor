unit module CSV::Editor::App;

use GTK::Simple;
#use CSV::Editor;

#sub run(Str:D $path --> Nil) is export {
sub run($path --> Nil) is export {
    my $orig = $path.IO.slurp;

    my $win = GTK::Simple::Window.new(title => "CSV::Editor - {$path}", width => 900, height => 600);
    my $vbox = GTK::Simple::VBox.new;
    my $hbox = GTK::Simple::HBox.new;

    my $btn-save = GTK::Simple::Button.new(label => "Save");
    my $btn-exit = GTK::Simple::Button.new(label => "Exit");
    my $btn-fit  = GTK::Simple::Button.new(label => "FitWidth");

    $hbox.pack-start($btn-save, False, False, 4);
    $hbox.pack-start($btn-fit,  False, False, 4);
    $hbox.pack-start($btn-exit, False, False, 4);

    my $textview = GTK::Simple::TextView.new;
    $textview.buffer.text = $orig;

    my $scroll = GTK::Simple::ScrolledWindow.new;
    $scroll.add($textview);

    $vbox.pack-start($hbox, False, False, 4);
    $vbox.pack-start($scroll, True, True, 4);

    $win.add($vbox);

    $btn-fit.clicked.tap({
        my $cur = $textview.buffer.text;
        try {
            $textview.buffer.text = CSV::Editor::fit-width($cur);
            CATCH { default { note "FitWidth error: " ~ .message } }
        }
    });

    $btn-save.clicked.tap({
        my $cur = $textview.buffer.text;
        $path.IO.spurt($cur);
    });

    $btn-exit.clicked.tap({
        my $cur = $textview.buffer.text;
        if $cur ne $orig {
            # simple confirm dialog
            my $dialog = GTK::Simple::MessageDialog.new(
                parent => $win,
                flags  => 0,
                type   => GTK::Simple::MessageType::QUESTION,
                buttons=> GTK::Simple::ButtonsType::YES_NO,
                message=> "Save changes before exiting?"
            );
            my $resp = $dialog.run;
            $dialog.destroy;

            if $resp == GTK::Simple::ResponseType::YES() {
                $path.IO.spurt($cur);
            }
        }
        $win.destroy;
        GTK::Simple::main-quit();
    });

    $win.border-width = 6;
    $win.show-all;
    GTK::Simple::main;
}
