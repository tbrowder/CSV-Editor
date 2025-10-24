Requirements for CSV::Editor
============================

(Imported from user's Requirements.txt)

  * Header line with field names; separators are one of: `|`, `,`, `;`.

  * Field names are ASCII letters, digits, or hyphen; unique.

  * Records may have empty fields; trailing empties may omit separators.

  * Whitespace padding around separators is insignificant.

  * Lines starting with `#` are ignored except for file save.

  * A record starting with `=finish` ends effective content.

  * GUI launched as `csv-edit $file` with Save, Exit, FitWidth.

  * Scrolling both directions; resizable widget window.

