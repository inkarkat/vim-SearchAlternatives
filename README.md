SEARCH ALTERNATIVES
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin provides mappings and commands to add and subtract alternative
branches to the current search pattern. Currently searching for "foo," but
also want to find matches for "bar"? You could type /foo\\|bar&lt;CR&gt; or
/&lt;C-R&gt;/\\|bar&lt;CR&gt;, but once you want to limit the search to whole \\&lt;words\\&gt;
(like the star command), and juggle several alternatives, adding and
dropping them as you search, this plugin is quicker than manually editing the
search command-line (which you can still do).

### SEE ALSO

### RELATED WORKS

- Add to Word Search ([vimscript #3955](http://www.vim.org/scripts/script.php?script_id=3955)) can add the keyword under the cursor to
  the search pattern and search forward / backward like \* / #.

USAGE
------------------------------------------------------------------------------

    <Leader>+               Add the current whole \<word\> as an alternative to the
                            search pattern, similar to the star command.

    <Leader>g+              Add the current word as an alternative to the search
                            pattern, similar to the gstar command.

    {Visual}<Leader>+       Add the current selection as an alternative to the
                            search pattern.
                            For a blockwise-visual selection, each line of the
                            block (minus leading and trailing whitespace) is added
                            as a separate alternative search pattern. When the
                            first selected line of the block is surrounded by non-
                            keyword characters, the match is done with \<...\>.
                            If the blockwise-visual selection is only comprised
                            of a single line, all WORDs of that line are added as
                            separate alternative whole \<word\> search patterns.

    <Leader>-               Remove the current whole \<word\> from the alternatives
                            in the search pattern.

    <Leader>g-              Remove the current word from the alternatives in the
                            search pattern.

    {Visual}<Leader>-       Remove the current selection from the alternatives in
                            the search pattern.
                            For a blockwise-visual selection, this has the same
                            special behavior as {Visual}<Leader>+.

    :SearchAdd {expr}       Add {expr} as an alternative to the search pattern.

    :SearchRemove {expr}    Remove {expr} from the alternatives in the search
                            pattern.
    :[N]SearchRemove        Remove the [N]'th / last alternative from the
                            alternatives in the search pattern.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-SearchAlternatives
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim SearchAlternatives*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.035 or
  higher.

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-SearchAlternatives/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 1.11    31-Jan-2020
- Abort :SearchRemove command on error.
- ENH: When adding a pattern (e.g. /foo/) when a shorter prefix (/fo/) already
  exists, the shorter one will eclipse the longer one (only "fo" will be
  matched in "foobar"). A new algorithm determines / estimates (in case of
  multis) the match length, and adds shorter ones after longer ones, to avoid
  the problem. In case of varying match lengths (e.g. with \* and \\+ multis),
  it cannot completely fix it, but it's always equal or better than the
  original simple addition at the end.
- ENH: When removing a branch, existing global regexp flags like for case
  sensitivity (/\\c, /\\C) and regexp engine type (/\\%#=0) caused a mismatch,
  and the corresponding branch could not be found. Now, we extract those flags
  and segregate them from the comparisons.
  On addition via SearchAlternatives#AddPattern(), make global flags unique
  and put them to the front of the search pattern.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.035!__

##### 1.10    19-Jul-2013
- ENH: Blockwise &lt;Leader&gt;+ / &lt;Leader&gt;- add / remove each partial selected
  trimmed line as a separate search alternative, or individual words when a
  single line is blockwise-selected.
- ENH: Implement command completion that offers existing alternatives (to
  remove or clone-and-modify them).
- Remove -complete=expression; it's not useful for completing regexp patterns.
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

__You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.009 (or higher)!__

##### 1.00    26-Jul-2012
- First published version.

##### 0.01    10-Jun-2011
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2011-2020 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
