### Blamethrower

You're about to start working on a file in a Git project and don't know how it works. Or you have an entire directory of files to suss out. Who should you talk to?

Blamethrower is simple script to analyze files or directories in a Git repository and show the author(s) and total lines committed by the author(s).

#### Usage
Run Blamethrower in a directory with a Git repository. Here's an example running it on the speed/ directory in the jQuery project:

```
$ blamethrower.rb speed/
FILE: speed/benchmark.js
FILE: speed/benchmarker.css
FILE: speed/benchmarker.js
FILE: speed/closest.html
FILE: speed/css.html
FILE: speed/event.html
FILE: speed/filter.html
FILE: speed/find.html
FILE: speed/index.html
FILE: speed/jquery-basis.js
FILE: speed/slice.vs.concat.html
John Resig: 4469
Brandon Aaron: 1263
jeresig: 912
Trey Hunner: 436
Ariel Flesler: 47
wycats: 18
Chris Faulkner: 12
Mathias Bynens: 2
```
