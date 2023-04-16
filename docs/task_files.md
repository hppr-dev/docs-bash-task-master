# Task Files

Task files are the meat and potatoes of Bash Task Master.
They hold all of the important procedures for a particular context.

By default, Bash Task Master supports the bash task syntax for task files.
See the [bash driver documentation](/drivers#bash-driver) for an indepth overview of the bash task syntax.

## Context Scoping

There are two main scopes that a task can run as:

* Global
    * Tasks that can be run anywhere
        * Builtin tasks
        * Installed Modules
* Local
    * Tasks from the local task file

The first thing that Bash Task Master does is look for a task file.
It starts at the current directory searches towards the root.
The search ends when either a task file is found, the current home directory is searched or the search reachs the root of the filesystem ("/").
If a task file is found, it loads the tasks inside of it.
Otherwise, only the builtin and module tasks are loaded.

For example, take the following file structure:

```
/home/btm/
├── .task-master
├── notes             ─┐
│   ├── tasks.sh       │ notes scope
│   └── docs           │
│       └── Linux.txt ─┘
├── project_one          ─┐
│   ├── tasks.sh          │ project_one scope
│   └── utils             │
│       └── some_file.py ─┘
└── project_two            ┐ global scope (no tasks.sh file)
    └── some_otherfile.py  ┘
```

Running `task` in the following contexts:

| Current directory           | Scope  | Loaded Tasks File              |
|-----------------------------|--------|--------------------------------|
| /home/btm/notes             | Local  | /home/btm/notes/tasks.sh       |
| /home/btm/project_two       | Global | Global                         |
| /home/btm/project_one/utils | Local  | /home/btm/project_one/tasks.sh |


## Environment Isolation

No task that is defined in the task file is ever loaded permanently into the user's running session.
The task function loads the task file in a subshell, isolating it from the current environment.
Therefore, tasks can not have side effects on the current environment, other than those explicitly made by the user.

For more on how to change the current environment refer to the [state function documentation](/state).

Bash Task Master defines 3 functions in the user session: `task` `_TaskTabCompletion` and `_tmverbose_echo` and 1 variable `TASK_MASTER_HOME`.
These are set up to be loaded in the .bashrc during installation.

Any other additions to the user environment have to be initiated by the user.

## Task Variables

Each task function is spawned inside of a subshell by the task function.
This means that the child process in which tasks are being run have access to the environment variables that have been set by the task function.

The following is a summary of the variables that are set in the task function, and are therefore available to use inside of tasks:

| Variable Name  | Description | Example Value |
|----------------|-------------|---------------|
| TASK_COMMAND   | The current running command | build |
| TASK_SUBCOMMAND | The current running subcommand (only applies to the bash driver)| frontend |
| TASK_DIR       | Directory where the task file was found. `$TASK_MASTER_HOME` in the global scope. | /home/btm/notes |
| TASK_FILE      | Tasks file that was loaded. | /home/btm/notes/tasks.sh |
| RUNNING_DIR    | The directory that task was run from | /home/btm/project_one/utils |
| DRIVER_DIR     | The driver directory | $TASK_MASTER_HOME/lib/drivers |
| TASK_MASTER_HOME | The home directory of bash task master | /home/btm/.task-master |
| TASK_REPOS | A space separated list of repo inventory files to pull modules or drivers from. Set in `$TASK_MASTER_HOME/config.env`. | file:///home/btm/repo/inventory |
| DEFAULT_EDITOR | The default editor to open when modifying files. Set in `$TASK_MASTER_HOME/config.env`. | vi |
| DEFAULT_TASK_DRIVER | The default task driver to use when initializing task files. Set in `$TASK_MASTER_HOME/config.env`. | bash |


For the sake of completeness, the following variables are also accessable, but should rarely be needed directly:

| Variable Name  | Description | Example Value |
|----------------|-------------|---------------|
| LOCATION_FILE | File that stores all of the stored locations. Don't mess with this file unless you are confident in fixing it. | /home/btm/.task-master/state/locations.vars |
| STATE_FILE     | File that stores the state for a given command | /home/btm/.task-master/state/project_one/build.vars |
| DEFAULT_EDITOR | The default editor to use when editing is called for. | vim |
| TASK_DRIVER_DICT | The associative array mapping task driver names to task driver files | bash=bash_driver.sh |
| TASK_FILE_NAME_DICT | The associatvie array mapping task files to task drivers | tasks.sh=bash |
| TASK_DRIVER | The name of the running task driver | bash |
| TASK_FILE_DRIVER | The name of the driver for the current task file | bash |
| TASK_FILE_NAME | The name of the current task file | tasks.sh |
| TASKS_FILE_FOUND | Denotes whether a task file was found in the current scope. (useful for modules) | T |
| DRIVER_EXECUTE_TASK | Driver specific execution function | bash_execute |
| DRIVER_HELP_TASK | Driver specific help function  | bash_help |
| DRIVER_LIST_TASK | Driver specific list function  | bash_list |
| DRIVER_VALIDATE_TASK_FILE | Driver function to validate task file | bash_validate_file |
| LOCAL_TASKS_REG | A regex list of local tasks | `build|run|kill` |
| GLOBAL_TASKS_REG | A regex list of global tasks | `list|help|global|driver|module` |
| GLOBAL_VERBOSE | Set to true to log _tmverbose_echo calls to stdout | 1 |
| GLOBAL_TASK_FILE | The file to load global tasks | $TASK_MASTER_HOME/load-global.sh |

### Task Variable Conventions

The following conventions are followed when deciding a variable name:

* All variables available to tasks are uppercase
* Variables that reference files end in `_FILE`
* Variables that reference directory end in `_DIR`
* Variables that are space seperated lists end in `S`
* Variables that are regexes end in `_REG`
* Multi-word variables are always seperated by underscores, i.e. `FILE_NAME` vs `FILENAME`
* Singular words are preferred to plural, i.e. `TASK_FILE` vs `TASKS_FILE`


## Task File Templates

Task file templates may be used when [initializing](/built_in_tasks#init) a new task file.
By default, the template with the same name as the driver is used.
Manage templates by using the built in [template](/built_in_tasks#template) command.
To edit or create a template run `task template edit -n my_tmpl`
