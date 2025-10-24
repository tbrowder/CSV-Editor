use Test;

my @modules = <
    CSV::Editor
    CSV::Editor::App
    CSV::Editor::Types
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
