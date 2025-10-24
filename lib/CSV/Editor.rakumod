unit module CSV::Editor;
use CSV::Editor::Types;

# Raku style: 4-space indents, no cuddled else/elsif, hyphenated subs where allowed.

subset Sep of Str where * eq any('|', ',', ';');

# Detect separator from header line
sub detect-sep(Str:D $line --> Sep) is export {
    for <| , ;> -> $cand {
        return $cand if $line.contains($cand);
    }
    die "Could not detect separator in header line: {$line}";
}

# Parse header names: ASCII alnum or hyphen, unique, single words
sub parse-headers(Str:D $line, Str:D :$sep --> List) is export {
    my $s = $sep // detect-sep($line);
    my @names = $line.split($s).map(*.trim);
    die "Empty header line" if @names.elems == 0;

    for @names -> $h {
        die "Invalid header '{ $h }' (must be ASCII letters, digits, or hyphen)"
            unless $h ~~ /^ <[A..Za..z0..9\-]>+ $/;
    }

    my %seen;
    for @names -> $h {
        die "Duplicate header '{ $h }'" if %seen{$h}:exists;
        %seen{$h} = True;
    }

    return @names;
}

# Split a record line into fields considering:
# - sep is one of | , ;
# - fields may be quoted using apostrophes (single quotes)
# - whitespace padding around separators is insignificant
# - empty fields allowed; trailing empty fields may be omitted
sub split-record(Str:D $line, Str:D :$sep --> List) is export {
    my $s = $sep // detect-sep($line);
    my @out;
    my $buf = '';
    my $in-quote = False;
    for $line.comb -> $ch {
        if $ch eq "'" {
            $in-quote = !$in-quote;
            next;
        }
        if $ch eq $s and not $in-quote {
            @out.push($buf.trim);
            $buf = '';
        }
        else {
            $buf ~= $ch;
        }
    }
    @out.push($buf.trim);

    # Trailing empties may be omitted (we will right-pad later as needed)
    return @out;
}

# Parse whole text into a Table
sub parse-text(
    Str:D $text 
    --> Table
) is export {
    my @lines = $text.lines;
    die "Empty input" if @lines.elems == 0;

    # Skip full-line comments at the top until the header
    my $i = 0;
    while $i < @lines.elems and @lines[$i].trim.starts-with('#') {
        $i++;
    }
    die "Missing header line" if $i >= @lines.elems;

    my $header = @lines[$i++];
    my $sep = detect-sep($header);
    my @headers = parse-headers($header, :sep($sep));

    my @rows;
    for @lines[$i..*] -> $line {
        next if $line.trim eq '';
        next if $line.trim.starts-with('#');

        my $first = $line.words.head // '';
        if $first eq '=finish' {
            last;
        }

        my @cells = split-record($line, :sep($sep));

        if @cells.elems > @headers.elems {
            die "Record has too many fields: { @cells.elems } > { @headers.elems }";
        }

        # Right-pad missing trailing fields with empty strings
        while @cells.elems < @headers.elems {
            @cells.push('');
        }
        @rows.push(@cells);
    }

    return Table.new(:sep($sep), :headers(@headers), :rows(@rows));
}

# Format a Table back to text, normalizing spacing:
# - one space around separators
# - left-justify content
# - respect apostrophe quoting if a cell contains the separator
sub format-table(Table:D $t --> Str) is export {
    my @w = (0 xx $t.headers.elems);

    # widths considering headers and data
    for $t.headers.kv -> $idx, $h {
        @w[$idx] = $h.chars if $h.chars > @w[$idx];
    }
    for $t.rows -> @r {
        for @r.kv -> $idx, $cell {
            my $c = $cell;
            # If cell contains the separator and not already quoted, quote with apostrophes
            if $c.contains($t.sep) and not ($c.starts-with("'") and $c.ends-with("'")) {
                $c = "'" ~ $c ~ "'";
            }
            @w[$idx] = $c.chars if $c.chars > @w[$idx];
        }
    }

    my $sep-out = " { $t.sep } ";

    sub pad(Str $s, Int $w --> Str) {
        $s ~ ' ' x ($w - $s.chars);
    }

    my $header = $t.headers.kv.map({ pad($_[1], @w[$_[0]]) }).join($sep-out);
    my @body;
    for $t.rows -> @r {
        my @cells = @r.kv.map(-> $kv {
            my ($idx, $cell) = $kv;
            my $c = $cell.trim;
            if $c.contains($t.sep) and not ($c.starts-with("'") and $c.ends-with("'")) {
                $c = "'" ~ $c ~ "'";
            }
            pad($c, @w[$idx]);
        });
        @body.push(@cells.join($sep-out));
    }

    return ($header, |@body).join("\n") ~ "\n";
}

# Fit widths is equivalent to formatting with computed widths
sub fit-width(Str:D $text --> Str) is export {
    my $t = parse-text($text);
    return format-table($t);
}

