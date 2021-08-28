# envmnu

## About

Envmnu is a simple shell script for choosing between different
environments using a small and simple menu. It was developed
to be able to choose between different Java environments from shell.

It is however able to switch between any environments that can
be set and unset using a shell script.

Envmnu should be sh-compatibe and is tested with recent versions
of bash and zsh.

## How does it work

envmenu is a function that read a configuration directory,
show a little number, allows you to choose an listed environment
by number. It then calls a stop-skript for the old environment for
posible cleanup and afterwards calls a start script for the new
environment. It is up for the (simple) scripts to do the actual
work. For Java this is setting JAVA_HOME and adding $JAVA_HOME/bin
to the path.

Since you cannot change environment variables from a subshell
everything run in the context of the current shell. Thus you do
not start the envmnu script but run it using the "." operator.

## Setup

### envmnu alias

The script is called with one parameter pointing to the configuration
directory. You should use the following alias:

```sh
alias envmnu=" . <path to envmenu>/envmenu.sh <path to envmenu cnfiguation directory>
```

and call it anytime by just typing "envmenu".

### *.mnu files

The configuration directory should contain a number of *.mnu files.
The files can use the initial four digits/letters for sorting.

Example:

```sh
$ ls *.mnu
'001 Java 8.mnu'  '002 Java 11.mnu'  '003 Java 16.mnu'
```

The *.mnu file can be empty. For the menu the initial four digits/letters
are cut of, also the prostfix.

example:

```sh
$ envmnu
1) Java 8
2) Java 11
3) Java 16
4) CANCEL
Your choice:
```

### Start and stop scripts

For start a shell script with the name of the environment a a "start" postfix
is called for stopping a script with "stop" postfix is called. This a simple
shell scripts which are sourced from envmnu itself.

Example:

```sh
ls *.mnu *.start *.stop
'001 Java 8.mnu'   'Java 11.start'  'Java 16.stop'
'002 Java 11.mnu'  'Java 11.stop'   'Java 8.start'
'003 Java 16.mnu'  'Java 16.start'  'Java 8.stop'
```

Further examples for choosing an environment:

```sh
$ envmnu
1) Java 8
2) Java 11
3) Java 16
4) CANCEL
Your choice: 1
* Enabling 'Java 8'...
  * Executing '/home/tim/projects/envmnu/Java 8.start'...
    * Activating environment for Java 8...
    * done.
  * done.
$ envmnu
1) Java 8
2) Java 11
3) Java 16
4) CANCEL
Your choice: 2
* Disabling 'Java 8'...
  * Executing '/home/tim/projects/envmnu/Java 8.stop'...
    * Deactivating environment for Java 8...
    * done.
  * done.
* Enabling 'Java 11'...
  * Executing '/home/tim/projects/envmnu/Java 11.start'...
    * Activating environment for Java 11...
    * done.
  * done.
```

### Available functions

The script can use the following functions:

|Function      |Parameter  |Description|
|--------------|-----------|-----------|
|logScript     |Any string |Dump the passed string as lohg output|
|removeFromPath|A path     |Removes the given path from the PATH variable|

### Script examples

Example for "Java 8.start":

```sh
logScript "Activating environment for Java 8..."

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export PATH="$JAVA_HOME"/bin:$PATH

logScript "done."
```

Example for "Java 8.stop":

```sh
logScript "Deactivating environment for Java 8..."

removeFromPath "/usr/lib/jvm/java-8-openjdk/bin"

logScript "done."
```

## License

Apache License 2.0
