flex
====

[![build status][travis-status-image]][travis-status]
[![documentation coverage][inch-status-image]][inch-status]

Converts a directory's worth of `.flac` files into `.mp3` files.

Dependencies (need to be available via the system's `$PATH`):

* `lame`
* `flac`


# building and usage

In the base directory of the project, create an executable `./flex` binary file:

    mix escript.build

Run the binary, passing it the directory of .flac files to convert:

    ./flex --dir=/path/to/dir/of/flacs


[inch-status]: http://inch-ci.org/github/alxndr/flex "documentation report at Inch-CI"
[inch-status-image]: http://inch-ci.org/github/alxndr/flex.svg?branch=master "documentation report at Inch-CI"
[travis-status]: https://travis-ci.org/alxndr/flex "test suite status at Travis-CI"
[travis-status-image]: https://travis-ci.org/alxndr/flex.svg?branch=master "test suite status at Travis-CI"
