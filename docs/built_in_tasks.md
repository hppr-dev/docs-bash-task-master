# Builtin Tasks

The following is a summary of all built in tasks that are shipped with bash task master.

In the examples all arguments are given in their long form, but short arguments are also accepted.
The short form arguments are standardized as the first letter of the long form.
For example, the short form of `--dir` would be `-d`.

This information can also be easily accessed by running `task help COMMAND_NAME`.

## Init

Initialize a local tasks file.

``` bash

# Create a tasks.sh file in the current directory
# Creates a bookmark with the directory name
task init

# Create a tasks.sh file in target directory and names it project
task init --dir target --name project

# Create a .tasks.sh file instead of a tasks.sh file
task init --hidden

```

## List

List available tasks.

``` bash

# List all tasks available
task list

# List all global tasks
task list --global

# List all local tasks
task list --local

```

## Edit

Edit the current local tasks file.
Opens the editor specified in the `DEFAULT_EDITOR` variable in `$TASK_MASTER_HOME/config.sh`.
After exiting the editor bash-task-master will check that the tasks.sh file is valid bash.
If the file is not valid it will give you the option to either open it back up or revert the changes.

``` bash

task edit

```

## Bookmark

Bookmark locations.

``` bash

# Bookmark the current directory
# Uses the current directory as it's name
task bookmark

# Bookmark the current directory as loc
task bookmark --name loc

# Create a bookmark to some/other/dir named mydir
task bookmark --dir some/other/dir --name mydir

# List bookmarks
task bookmark list

# Remove a bookmark
task bookmark rm --name mybookmark

```

## Goto

Change directories to previously bookmarked locations.

Goto a bookmark named location:

``` bash

task goto location

```

## Help

Show Help.

``` bash

# Show help for mycommand
task help mycommand

```

## Module

Manage local modules.


``` bash

# Enable mymodule
# Searches TASK_REPOS for the module if it not found locally.
task module enable --id mymodule

# Disable mymodule
task module disable --id mymodule

# List all enabled or disabled modules
task module list --all

# List all remotely available modules
task module list --remote

# List all enabled modules
task module list --enabled

# List all diabled modules
task module list --disabled
```

## Global

Global debug information.
Manage global variables and state.


``` bash

# Show all current variables
task global debug

# Show current variables for the build command:
task global debug --command build

# Set a variable for a command.
# For example, to set myvar to 10 for the clean command:
task global set --key myvar --value 10 --command clean

# Remove a variable for a comman.
# For example, to unset myvar for the clean command:
task global unset --key myvar --command clean


# Edit the variables for a command.
# Uses the `DEFAULT_EDITOR` setting in `$TASK_MASTER_HOME/config.sh` as the editor.
# For example, to edit the settings for the clean command:
#task global edit --command clean


# Clean up empty locations and stale location files.
# This will remove any state files with no values in them and remove any bookmarks that refer to non existant locations.
task global clean

```
