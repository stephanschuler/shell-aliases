This directory contains symlinks.
Every symlink is registered as alias to change directory to its target.

Example:
```
$ ls -l
> lrwxr-xr-x  1 stephan.schuler  635458030  32 29 Sep 23:33 Downloads -> ~/Downloads

$ alias Downloads
> Downloads='cd ~/Downloads'
```