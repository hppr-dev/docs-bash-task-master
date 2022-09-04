# Builtin Tasks

The following is a summary of all built in tasks that are shipped with bash task master.

In the examples all arguments are given in their long form, but short arguments are also accepted.
The short form arguments are standardized as the first letter of the long form.
For example, the short form of `--dir` would be `-d`.

This information can also be easily accessed by running `task help COMMAND_NAME`.

## Init

Initialize a local tasks file.
This will also create a bookmark for the location.
By default this will create a tasks.sh file in the current directory:

```
  task init
```

You may also specify a directory and a name for the tasks file.
For example, to create a tasks.sh file in the target directory with a UUID of project run:

```
  task init --dir target --name project
```

You may also opt to create a hidden tasks file (.task.sh) by specifying -h

```
  task init -h
```

## List

List available tasks.
This will show you all of the tasks you are able to run from your current directory:

```
  task list
```

The `--global` flag will filter the output to only global tasks:

```
  task list --global
```

The `--local` flag will only show the local tasks:
```
  task list --local
```

## Edit

Edit the current local tasks file.
Opens the editor specified in the `DEFAULT_EDITOR` variable in `$TASK_MASTER_HOME/config.sh`.
After exiting the editor bash-task-master will check that the tasks.sh file is valid bash.
If the file is not valid it will give you the option to either open it back up or revert the changes.

```
  task edit
```

## Bookmark

Bookmark locations.

Bookmark the current location:

```
  # Saves the current directory using the current directory name
  task bookmark

  # Saves the current directory as loc
  task bookmark --name loc
```

Bookmark another location:

```
  task bookmark --dir some/other/dir --name mydir
```

List available bookmarks:

```
  task bookmark list
```

Remove a bookmark:

```
  task bookmark rm --name mybookmark
```

## Goto

Change directories to previously bookmarked locations.

Goto a bookmark named location:

```
  task goto location
```

## Help

Show Help.

Show help for a command:

```
  task help command
```

Show help for task master:

```
  task help
```

## Global

Global debug information.
Manage global variables and state.

Show all current variables

```
  task global debug
```

Show current variables for the build command:

```
  task global debug --command build
```

Set a variable for a command.
For example, to set myvar to 10 for the clean command:

```
  task global set --key myvar --value 10 --command clean
```

Remove a variable for a comman.
For example, to unset myvar for the clean command:

```
  task global unset --key myvar --command clean
```


Edit the variables for a command.
Uses the `DEFAULT_EDITOR` setting in `$TASK_MASTER_HOME/config.sh` as the editor.
For example, to edit the settings for the clean command:

```
  task global edit --command clean
```


Clean up empty locations and stale location files.
This will remove any state files with no values in them and remove any bookmarks that refer to non existant locations.

```
  task global clean
```
