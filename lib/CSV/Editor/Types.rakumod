unit module CSV::Editor::Types;

# Basic types used by the editor.

class Table is export {
    has Str $.sep is required;          # one of "|", ",", ";"
    has Str @.headers is required;      # ordered header names
    has Array @.rows is required;       # Array of Array of Str (cells)
}

