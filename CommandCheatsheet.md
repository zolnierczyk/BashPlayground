# Commands Cheatsheet

Bash is for lazy people. For almost every work that you need to be done there is command or combination of command that will do it for you. Just keep searching!

## Must know list

Here is just long list of command keywords which are nice to known. Most are basic some are not. This list is without any description because whole document will be too long and for every of this command you can write loooooong articles. I just go through this list trying to remember not exact syntax of command but their purpose and where are handy to use. Usage info and syntax you can find on internat or man pages.

```
cat chmod chown cp diff file find gunzip gzcat gzip head
lpq lpr lprm ls more mv rm tail touch awk cut echo egrep fgrep fmt grep nl sed sort
tr uniq wc cd mkdir pwd bg cal date df dig du fg finger jobs last
man passwd ping ps quota scp ssh top uname uptime
w wget whoami whois kill killall & nohup
```

## Man pages

Source of all knowledge. If you are on machine without internet (puff stackoverflow disappear and you are not programmer anymore) this stuff is essential to get work done.

``` bash
man commandName # Display man page for commandName
man -k string # Search for string in short manpage description
man -K string # Search for string in all (brute force) manpage
man -wK string # Search for string everywhere and display on name of manpages
```

## Finding files and stuff in system

### locate

Lightning fast function to search for filenames in system. It is so fast because it is not using filesystem at all but instead using database. Database is refreshed by default daily but can be manually triggered by _updatedb_. Perfect to searching come config files or libraries on system but not for newly mounted file system. In that case you need to remember ot run database update. Also there is nothing like _exec_ argument but we can use regex. But boy it is fast!

``` bash
locate nameOfStuff.cfg
locate -c *.foo # Return number of found files
locate -i *.foo # Ignore case sensitivity
locate -e *.foo # Remove non existing files from result
locate -n 20 *.foo # Return first 20 results
```

### find

It just find stuff and do the job. Second part is very powerful because you can execute another command on every file which was found.

``` bash
find search/here -name stuffTo.find # Case sensitive search
find search/here -iname stuffTo.find # Case insensitive search
find search/here -iname "*.find" # With wildcard or regex
find search/here -type f -name "*.conf" # Find name and by file type
find search/here -size +100MB # Find all with size greater.
```

``` bash
find [-H] [-L] [-P] [-D debugopts] [-Olevel] [starting-point...] [expression]
```

| Parameter  | Description |
| ------------- | ------------- |
| -H | Never  follow  symbolic links  |
| -L | Follow symbolic links  |
| -P | Do  not  follow  symbolic  links,  except while processing the command line arguments |
| -D | Turn on debug prints (for example _exec_ show debug for -exec argument commands)  |
| -Olevel | Optymalization level for matching files with multiple query (i.e. name, type, size).  |

| Queries  | Description |

### grep

To find files that contain something we can use _grep_. It scan content of multiple files and return matched lines. Remember that you can combine _find_ command with _-exec grep_ to have more fine tuning on files scanned by grep.

``` bash
grep [OPTIONS] PATTERN [FILE...]
grep -rnw whereIsThisLine # Scan for string inside files recursively from here
```

| Parameter  | Description |
| ------------- | ------------- |
| -r | Search files recursive  |
| -n | Print line in file where match occur |
| -w | Match whole word not substring  |
| -i | Ignore case |
| -v | Invert matching logic |
| -s | Suppers errors about file access failure |
| -aNUM | Print NUM of lines after match |
| -bNUM | Print NUM of lines before match |
| -cNUM | Print NUM of lines around match |
| -l | Show only file where match was fond |

## awk for ever

## sed

## rsync magic

## File size

Here I will just note down few commands which allows to display various information about filesystem and files sizes.

``` bash
df -ah # Print capacity and usage and mount points of all available file system
du -hc # Print summarized size of folders from this point recursive
ls -allhsS # Print all files in cwd sort by size and print allocated disk size
ls -allhsSR # -R do ls recursive way but better is to use tree cmd below
tree -hpD # Print nice folder tree with file size
```

## Network

### Monitors

In terminal live monitor.

``` bash
nload # Very simple tool which present network load
iftop -i eth0 # Visualize connection, sockets and bandwidth  
ifstat # Simple tool to log in batch mode current network load
```

### Connection info by ss

Ehh _netstat_ is obsolete so we will here use _ss_.

``` bash
ss -a
ss -tnp src :80 or src :443
```

| Parameter  | Description |
| ------------- | ------------- |
| -n  | Port as numbers |
| -p  | Display pid of process using that socket |
| -a  | Display both listening and non-listening (for TCP this means established connections) sockets |
| -l  | Display listening |
| -e  | Display extended socket info |
| -i  | Show internal TCP information |
| -m  | Display socket memory usage |
| -t  | Display TCP socket |
| -u  | Display UDP socket |

### Mapping network by nmap

### Creating connection by ncat

### Dump and replay communication by tcpdump and others

### ip command

Just type _sudo apt install ifconfig_ I will use ifconfig to the bitter end!

### ubuntu network manager
