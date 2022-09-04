# Task Files

Task files are the meat and potatoes of Bash Task Master.
They hold all of the important procedures for a particular context.

By default, Bash Task Master supports the bash syntax for tasks files.
See the [bash driver documentation](https://bash-task-master.readthedocs.io/drivers/#bash-driver) for an indepth overview of the bash syntax.

## Context Scoping

There are two main scopes that a task can run as:

  * Global
    * Builtin tasks
    * Installed Modules
    * Tasks that can be run anywhere
  * Local
    * Tasks from the local tasks file
    * Tasks that can only be run from the current task file context

The first thing that Bash Task Master does is look for a tasks file.
It starts at the current directory searches towards the root.
The search ends when either a tasks file is found, the current home directory is searched or the search reachs the root of the filesystem ("/").
If a tasks file is found, it loads the tasks inside of it and also the global tasks.
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
└── project_two            ┐ global scope (no tasks file)
    └── some_otherfile.py  ┘
```

Running `task` in the following contexts:

| Current directory           | Scope  | Loaded Tasks File              |
|-----------------------------|--------|--------------------------------|
| /home/btm/notes             | Local  | /home/btm/notes/tasks.sh       |
| /home/btm/project_two       | Global | Global                         |
| /home/btm/project_one/utils | Local  | /home/btm/project_one/tasks.sh |


## Environment Isolation

Every task that is defined in the task file is never loaded into the user's running session.
The task function loads the task file in a subshell, isolating it from the current environment.
Tasks can not have side effects on the current environment, other than those explicitly made by the user.

For more on how to change the current environment refer to the [state function documentation](https://bash-task-master.readthedocs.io/state/).

## Task Variables

Each task function is spawned inside of a subshell by the task function.
This means that the child process in which tasks are being run have access to the environment variables that have been set.

The following is a summary of the bash environment variables that are available to tasks (regardless of driver):

| Variable Name  | Description | Example Value |
|----------------|-------------|---------------|
| TASKS_DIR      | Directory where the tasks file was found. `$TASK_MASTER_HOME` in the global scope. | /home/btm/notes |
| TASKS_FILE     | Tasks file that was loaded. | /home/btm/notes/tasks.sh |
| RUNNING_DIR    | The directory that task was run from | /home/btm/project_one/utils |

For the sake of completeness, the following variables are also accessable:

| Variable Name  | Description | Example Value |
|----------------|-------------|---------------|
| LOCATIONS_FILE | File that stores all of the stored locations. Don't mess with this file unless you are confident in fixing it. | /home/btm/.task-master/state/locations.vars |
| STATE_DIR      | Directory where state is stored for tasks. `$TASK_MASTER_HOME/state` in the global scope. | /home/btm/.task-master/state/project_one/ |
| STATE_FILE     | File that stores the state for a given command | /home/btm/.task-master/state/project_one/build.vars |
| DEFAULT_EDITOR | The default editor to use when editing is called for. | vim |

