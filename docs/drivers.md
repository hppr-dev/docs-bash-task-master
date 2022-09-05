# Drivers

Drivers are resposible for parsing/validating arguments and executing tasks.
The driver defines the format and filename of a tasks file.
By default, the only driver included in Bash Task Master is the bash driver.
Modules use the bash_driver.

See [below](#custom-drivers) on how to implement a driver to support different file formats.


## Bash Driver

The bash driver is used whenever a tasks file is named tasks.sh or .tasks.sh.
As the name implies, it is implemented in bash and the task file is a bash script.
Arguments and tasks are defined in bash functions which are loaded by the main task function.


### Tasks

Tasks in a bash task file are created as functions with the `task_` prefix in the tasks.sh file.
Anything after `task_` is treated as the task name:

``` bash
# Example tasks.sh file

# run with task clean
task_clean() {
  ...
}

# run with task check_all
task_check_all() {
  ...
}
```

### Arguments

Each argument given to a task is loaded into the task as an `ARG_` variable.
By default, any long argument, i.e. one that starts with a `--`, is loaded with the same name as it was given on the command line.
For example, running `task hello --foo bar` would run the `task_hello` function with `ARG_FOO=bar`.





#### Specifying Arguments

Arguments can be defined in an `arguments_TASKNAME` function.
This function should be loaded alongside the task definition, i.e. inside the same tasks.sh file.
The variables inside this function are used to parse and validate the arguments before the task function is run.

The following variables are supported in arguments functions:

| Variable Name | Description | Example |
|---------------|-------------|---------|
| `SUBCOMMANDS` | a `|` delimited list of subcommands. | `SUBCOMMANDS="sign|clean|init"` |
| `[COMMAND]_DESCRIPTION` | help string for a COMMAND or SUBCOMMAND | `BUILD_DESCRIPTION="Build the project"` |
| `[COMMAND]_REQUIREMENTS` | required arguments for a COMMAND or SUBCOMMAND. | `INIT_REQUIREMENTS="out:o:str dir:d:str"` |
| `[COMMAND]_OPTIONS` | arguments for a COMMAND or SUBCOMMAND | `CLEAN_OPTIONS="f:force:bool"` |

Note that DESCRIPTION, REQUIREMENTS and OPTIONS can be used with a command AND/OR a subcommand.

REQUIREMENTS and OPTIONS are written as lists of space delimited argument specifications that are of the form: long-arg:short-arg:arg-type.

The long-arg of the argument specifies the flag to be used with `--` and also denotes the portion of the `ARG_` variable in the tasks.
The short-arg is the flag to be used with `-` (single dash).
The arg-type specifies what type the argument is. See below for available types.

For example:

```
                 ┌─ these are optional arguments
                 │
         COMPOSE_OPTIONS="name:n:int host:h:ip iterations:i:int"
                            │  │  │
Can be specified by --name ─┘  │  └─ Will fail if not an integer
                               │
        Can be specified by -n ┘

```

The above specification specifies that the compose command has 3 optional arguments: --name or -n, --host or -h, --iterations or -i.
In the task we could access these values as `ARG_NAME`, `ARG_HOST` and `ARG_ITERATIONS` respectively.



#### Arguments Example

If the following arguments are defined for the build task:

``` bash

arguments_build() {
  SUBCOMMANDS="help|frontend|backend|all"
  FRONTEND_REQUIREMENTS="out:o:str in:i:str"
  FRONTEND_OPTIONS="VERBOSE:v:bool LINT:L:bool DIR:d:str"
  BACKEND_REQUIREMENTS="PID:P:int"
  BACKEND_OPTIONS="VERBOSE:v:bool BUILD-FIRST:B:bool"
}

```

Then all of the following calls would succeed:

``` bash

task build frontend --out outdir --in infile
task build frontend --out outdir --in infile --lint --verbose
task build frontend -o outdir -i infile -L -v
task build all
task build backend --pid 123
task build backend -P 123
task build backend -vBP 123
task build frontend -Lo outdir -vi infile

``` 

But none of the following:

``` bash

task build frontend                              # Missing required arguments
task build frontend --in infile --lint --verbose # Unknown argument --in
task build backend -P 12 -v garbage              # Verbose is not a bool

```

#### Supported Argument Types

Available types are as follows:

|  Type         | Identifier | Description |
|  ----         | ---------- | ----------- |
|  String       | str        | A string of characters, can pretty much be anything. |
|  Integer      | int        | An integer |
|  Boolean      | bool       | An argument that is either T if present or an empty string if not* |
|  Word         | nowhite    | A string with no whitespaces |
|  Uppercase    | upper      | An uppercase string |
|  Lowercase    | lower      | A lowercase string |
|  Single Char  | single     | A single character* |

All types, except for bool, require that a value is given.
With bool arguments, the argument being present automatically sets the `ARG_VAR`.
Note that short arguments can be combined to one combined argument, e.g -vBP, but only the last can be a non bool.

* A single character may be confused as a boolean at validation time.
If a value for a single character argument is left out, it will be set to "T"


## Custom Drivers

Task drivers are determined by the filename of the tasks file.
The tasks.sh and .task.sh filenames are associated with the bash_driver.
A custom driver would need to have a unique name for their tasks file.

The way that the task runner switches between drivers is by loading different sets of functions for loading, parsing, validating, and executing tasks.
Drivers also need to be able to enumerate the tasks within a tasks file and provide help for tasks.

The following variables store which functions to call for each step of execution:

| Variable Name | Arguments | Description |
|---------------|-----------|-------------|
| DRIVER_LOAD_TASKS_FILE | TASKS_FILE | Loads the task file into the environment. This needs to set LOCAL_TASKS_UUID in the environment to make sure an isolated state file is created. |
| DRIVER_PARSE_ARGS | $@ | Parses the arguments given to the task function. Should output what is wrong. Execution stops if this returns a non-zero exit code. Should set TASK_SUBCOMMAND, if subcommands are supported. |
| DRIVER_VALIDATE_ARGS | None | Validates the current arguments. Should output what is wrong. Execution stops if this returns a non-zero exit code. |
| DRIVER_EXECUTE_TASK | TASK_COMMAND | Executes the task with the given name. |
| DRIVER_HELP_TASK | TASK_COMMAND | Shows the help for the given command. |
| DRIVER_LIST_TASKS | TASKS_FILE | Lists the available tasks in the given tasks file. The list is used to verify that a certain task exists. |

Different languages may be used to implement custom drivers but the driver must define these variables to interface with the execution environment.

The following driver file would define an alternative bash driver that doesn't do anything with arguments and just executes hello, world, foo and bar tasks:

``` bash
DRIVER_LOAD_TASKS_FILE=source
DRIVER_PARSE_ARGS=noop
DRIVER_VALIDATE_ARGS=noop
DRIVER_EXECUTE_TASK=execute_task
DRIVER_HELP_TASK=not_helpful
DRIVER_LIST_TASKS=acceptable_tasks

noop() {
  return 0
}

execute_task() {
  task_$1
}

not_helpful() {
  echo rtfd
}

acceptable_tasks() {
  echo "hello world foo bar"
}

```

### Installing a Custom Driver

After the source for a driver is added to the `$TASK_MASTER_HOME/lib/drivers/` directory, the `$TASK_MASTER_HOME/lib/drivers/driver_defs.sh` file must be updated with the filename that should be associated with the driver.

For example, if I wanted to install a driver for a tasks file named .task-master.py I would need to add the following to the `driver_defs.sh` file:

``` bash
TASK_DRIVERS[.task-master.py]=my_driver.sh
```

where `my_driver.sh` is the filename of the driver in the `$TASK_MASTER_HOME/lib/drivers/` directory.
