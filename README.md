flex
====

Converts a directory's worth of `.flac` files into `.mp3` files.

Dependencies (need to be available via the system's `$PATH`):

* `lame`
* `flac`

### compiling a file for commandline usage

    mix escript.build  # creates an executable file ./flex
    ./flex --dir=/path/to/dir/of/flacs

