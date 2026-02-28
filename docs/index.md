# Introduction

Bash Task Master is a utility to organize and write specialized bash scripts AKA tasks.

Features:

  - Scoped Context
    - Project specific tasks are stored and loaded based on the current working directory
    - Modules tasks are available anywhere

  - Parse and Validate Input
    - Reference arguments by name (`$ARG_VAR`)
    - Ensure that arguments match an expected format

  - Isolated Runtime
    - Task variables and functions do not pollute the user session

  - Centralized Management
    - Manage modules, drivers and templates from anywhere


Bash Task Master was designed to be flexible and expandable.

Task files act as documentation for important processes.
While a simple bash script would serve the same purpose, the aim is to make it easier to co-locate project resources.
There are also quality of life aspects like argument parsing and state storage.

For example, let's say we wanted to lint, test, and run every project that we worked on.
Without bash task master, we would need to remember the command and arguments for each tool that performs each individual command.
With bash task master, it's as easy as running `task lint`, `task test`, and `task run` in a project directory.

## Installation

You do not need elevated permissions to install.
It is preferred to run bash-task-master as a non-sudo user.

1\. Install the latest version:
``` bash
curl -L https://hppr.dev/install-btm.sh | bash
```
    
2\. Log out

3\. Log back in

## Quick Start

1\. Create a new directory

``` bash

mkdir tutorial
cd tutorial

```

2\. Initialize a task file

``` bash

task init

```

3\. Write a task

``` bash

task edit # opens tasks.sh in vi by default

```
    
Add the following to the file and exit.
    
``` bash

task_spec greet "An example task!" "name:n:str" ""

task_greet() {
  echo "Hello $ARG_NAME, good day to you!"
}

```

!!! note "Alternative: full form"
    You can instead define an `arguments_greet()` function that sets `GREET_DESCRIPTION` and `GREET_REQUIREMENTS`. The full form is required for tasks with subcommands; see [Bash driver — Arguments](/drivers#specifying-arguments).

4\. Run it!

``` bash

task greet -n "internet" # Run the task
Running greet: task...
Hello internet, good day to you!

```

5\. Show help!

``` bash

task help greet          # Get help on the task
  Running help:greet task...
  Command: task greet
    An example task!
    Required:
      --name, -n str

```

6\. Validate arguments!

``` bash

task greet               # Fail the task
Missing required argument: --name

```

# Calling Tasks

Tasks are called using the `task` command (or the `t` alias).
The `task` command takes any number of arguments.
The first argument is always interpreted as the command you would like to run.
Everything after the command depends on what type of task file you are using.

The default way that commands are parsed is with the [bash task syntax](/drivers#bash-driver).
This syntax interprets the first argument not starting with `-` after the command as an optional subcommand.
Everything after the subcommand is required to be an argument.

!!! example
    ![Task Call](assets/task-examplepic.png)
