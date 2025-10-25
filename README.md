[![Actions Status](https://github.com/tbrowder/CSV-Editor/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/CSV-Editor/actions) [![Actions Status](https://github.com/tbrowder/CSV-Editor/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/CSV-Editor/actions) [![Actions Status](https://github.com/tbrowder/CSV-Editor/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/CSV-Editor/actions)

NAME
====

**CSV::Editor** - Provides a simple viewer and editor for CSV files

SYNOPSIS
========

```raku
use CSV::Editor;
$ csv-edit $christmas-list # edit the text CSV table of addresses
```

DESCRIPTION
===========

**CSV::Editor** is a simple, visual editor for text CSV files.

It has a few format restrictions:

  * The only valid field separators are:

    * comma: `,`

    * semicolon: `;`

    * pipe (vertical line): `|`

  * The following objects are not allowed in a **valid** field unless they are escaped with a backslash (`\`):

    * octothorpe or pound sign: `#`

    * comma: `,`

    * semicolon: `;`

    * pipe (vertical line): `|`

Its current capabilities are:

  * allow the user to edit the viewed file

  * align the valid fields so each field has the same widths

  * left-justify the contents of valid fields

  * allow saving the current view (state) of the file

  * allow comment lines beginning with a pound sign ('#')

  * ignoring the rest of the file when encountering a line beginning with '=finish'

Note the record lines with comments and lines on and after '=finish' are conidered invalid CSV records but **are saved with the file**.

Motivation and source
---------------------

This project was motivated by my old, but updated, Christmas list management program started in 1993 as a Perl 4 project and gradually converted to Perl 5 and then to Raku (Perl 6) in 2016. Record fields were pipe separated and lines commented out when contacts were no longer valid or wanted.

There was no easy way to align the fields with conventional CSV reader/writer programs. This past week I wrote the included *Requirements* dovument and fed it to ChatGPT which gave me a gigantic start. Since then I've been fixing errors and changing things which didn't quite work. 

One of the major problems was the use of Map which I find is the source of a lot of hidden mistakes (which I find hard to 'grok'). I wind up unpacking the Maps so I can (1) understand the intent and (2) fix problem more easily.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2025 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

