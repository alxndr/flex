flex
====

[![build status](https://travis-ci.org/alxndr/flex.svg?branch=master)](https://travis-ci.org/alxndr/flex)
[![documentation coverage](http://inch-ci.org/github/alxndr/flex.svg?branch=master)](http://inch-ci.org/github/alxndr/flex)

Converts a directory's worth of `.flac` files into `.mp3` files.

Dependencies (need to be available via the system's `$PATH`):

* `lame`
* `flac`

### compiling a file for commandline usage

    mix escript.build  # creates an executable file ./flex
    ./flex --dir=/path/to/dir/of/flacs

