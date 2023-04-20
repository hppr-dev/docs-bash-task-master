# Builtin Tasks

The following is a summary of all built in tasks that are shipped with bash task master.

In the examples all arguments are given in their long form, but short arguments are also accepted.
The short form arguments are standardized as the first letter of the long form.
For example, the short form of `--dir` would be `-d`.

This information can also be easily accessed by running `task help COMMAND_NAME`.

## Init

Initialize a local task file.

``` bash

# Create a .tasks.sh file in the current directory
# Uses the default bash template
# Adds a bookmark with the directory name
task init

# Create a tasks.sh file in target directory and names it project
task init --dir target --name project

# Create a .tasks.sh file from a given template
task init --template custom

# Create default task file for mydriver
# If a template does not exist, create an empty task file that uses the naming convention of mydriver
# NOTE: -D is the short argument for --driver
task init --driver mydriver

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

Edit the current local task file.
Opens the editor specified in the `DEFAULT_EDITOR` variable in `$TASK_MASTER_HOME/config.env`.
After exiting the editor bash-task-master will check that the tasks.sh file is valid bash.
If the file is not valid it will give you the option to either open it back up or revert the changes.

``` bash

# Edit the current tasks file with the DEFAULT_EDITOR
task edit

```

## Bookmark

Bookmark directories.

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

Change directories to previously bookmarked directories.

``` bash

# Goto the bookmarked proj directory
task goto proj

```

## Help

Show Help.

``` bash

# Show help for mycommand
task help mycommand

```

## Template

Manage task file templates

``` bash
# Edit the default bash template
task template edit --name bash

# Edit/create a new custom template
task template edit --name custom

# Remove the custom template
task template rm --name custom

# List templates
task template list
```

## Module

Manage modules.


``` bash

# Enable mymodule
# Searches TASK_REPOS from $TASK_MASTER_HOME/config.env for the module if it not found locally.
task module enable --name mymodule

# Disable mymodule
task module disable --name mymodule

# List all enabled or disabled modules
task module list --all

# List all remotely available modules
task module list --remote

# List all enabled modules
task module list --enabled

# List all diabled modules
task module list --disabled

# Remove all disabled modules
task module clean

```

## Driver

Manage task drivers

``` bash

# Enable mydriver
# Searches TASK_REPOS from $TASK_MASTER_HOME/config.env for the driver if it is not found locally
task driver enable --name mydriver

# Disable mydriver
task driver disable --name mydriver

# List installed drivers
task driver list

# List drivers available remotely
task driver list --remote

```

## State

Interact with stored state information

``` bash

# Show all current variables
task state show

# Set a variable for the current context.
task state set --key myvar --value 10

# Remove a variable for the current context.
task state unset --key myvar

# Edit the variables for a command.
# Uses the `DEFAULT_EDITOR` setting in $TASK_MASTER_HOME/config.env as the editor.
task state edit

# Remove all empty state files and bookmarks that refer to missing directories.
task state clean

```

## Global

Global Utilities.

``` bash

# Update to the most recent release
task global update

# Update to the dev version (irreversible)
task global update --dev

# Update to version 1.0
task global update --version 1.0

# Show version information
task global version

```
