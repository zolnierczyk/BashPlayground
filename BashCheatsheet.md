# Bash Cheatsheet

Here is fast and simple cheatsheet for basic and more advance stuff in bash. I use it to fast refresh my memory befor writing script. Because in many cases bash has some nice tool already waiting to use it instead of if-loop stuff which always introduce some kind of errors.

## Set Builtin

Full list here: [Link to doc](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

| Parameter  | Description |
| ------------- | ------------- |
| -e | Exit script on error (if not catched)  |
| -u | Exit when used uninitialized variable  |
| -n | For debug check syntax not execute commands |
| -v | For debug print command as they are read from script |
| -x | For debug print command after varible resolution |

Nice to known:
>The current set of options may be found in $-. 

This part of documentation is example how to write non intuitive interface ...
> Using ‘+’ rather than ‘-’ causes these options to be turned off.

## Ifs statments

``` bash
if test-commands; then
  consequent-commands;
[elif more-test-commands; then
  more-consequents;]
[else alternate-consequents;]
fi

```

``` bash
case word in
    [ [(] pattern [| pattern]…) command-list ;;]…
esac
```

``` bash
select name [in words …]; do commands; done
```

``` bash
(( expression ))
let "expression"
```

``` bash
[[ expression ]]
```

``` bash
( ! ( ( expression1 && expression2 ) || expression2 ))
```

## Loops

``` bash
for name [ [in [words …] ] ; ] do commands; done
for (( expr1 ; expr2 ; expr3 )) ; do commands ; done
while test-commands; do consequent-commands; done
until test-commands; do consequent-commands; done
```

And of course we have `brake` and `continue`.

## Command grouping

| Group  | Description |
| ------------- | ------------- |
| `( list )` | Invoce list in subshell (kind of encapsulation)  |
| `{ list; }` | Invoce list in this shell |

## Function

``` bash
function name [()] compound-command [ redirections ]
```

Be advice to use `local` keyword to declare local variables with shodowing effect.

## Parameters

| Special  | Description |
| ------------- | ------------- |
| `$1 $2 ` etc.. | Access positional paramter index by number  |
| `$#` | Number of positional parameters |
| `$*` | Access all parameter combined into one string |
| `$@` | Access all parameter combined into list of string |
| `$?` | Exit status of most recent job |
| `$$` | Current shell proccess ID |
| `$!` | Last background job process ID |
| `$0` | File name of current script (see docs if `bash -c)` |
| `$_` | Just read doc |

Usefull builtin is `shift` which shift and consume parameter list to the left so is smaller by one. Thanks that we can write some nice loops over parameters.

## File pattern matching

| Pattern  | Description |
| ------------- | ------------- |
| `*` | Match everything including null string |
| `*/` | Match folders |
| `**/` | Match folders and subfolders |
| `?` | Match any signle character |
| `?` | Match any signle character |
| `[range]` | Match range of character i.e `[abcd]` or `[a-dx-z]` or `[alpha]` etc..|
| `*(pattern-list)` | Match zero or more pattern on list |
| `+(pattern-list)` | Match one or more pattern on list |
| `@(pattern-list)` | Match one pattern on list |
| `!(pattern-list)` | Match anything except pattern list |

## Process Substitution

## Shell Parameter Expansion

## Tilde Expansion

| Tilde  | Description |
| ------------- | ------------- |
| `~` | Go to home folder  |
| `~/folder` | Go to home folder/folder  |
| `~fred/folder` | Go to home folder user fred and its subdirectory folder  |
| `~+/foo` | `$PWD/foo` Yeha!  |
| `~-/foo` | `$OLDPWD/foo`  Nice! |
| `~N` or `~+N` | Go to N folder back in history (dirs) |
| `~-N` |  Go to N folder forward in history (dirs) |

## Brace Expansion

## Redirection

## Traps

## Environment during execution

## Bourne and Bash Shell Variables

Here is only small subset of full list.

| Tilde  | Description |
| ------------- | ------------- |
| BASH_SUBSHELL | Incremented by one each time a new subshell is started.|
| BASH_SOURCE and BASH_LINENO |  The shell function `${FUNCNAME[$i]}` is defined in the file `${BASH_SOURCE[$i]}` and called from `${BASH_SOURCE[$i+1]` |
| DIRSTACK | Array of dirs in history (similar to `dirs`)|
| FUNCNAME | Array of called function in script (similar to `caller`)|
| GROUPS | Current user array of group membership |
| HIST* | Whole group of variables defining bash history usage |
| LINENO | The line number in the script or shell function currently executing. |
| OLDPWD | Before current working directory |
| PIPESTATUS | Array of return status from last pipe expression |
| PPID  | Parent process id |
| PWD | Return current working directory |
| RANDOM | Return random number from 0 to 32767 |
| SECONDS | Seconds from start of shell |
| SHELLOPTS | Current shell options |
| SHLVL | Incremented by one each time a new instance of Bash is started (but no subshell).|
| UID  | User id number |

## Bash Conditional Expressions

## Shell Arithmetic

## Arrays

## Job Control
