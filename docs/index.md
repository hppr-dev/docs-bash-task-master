# Introduction

Bash Task Master enhances bash by providing a way to create context for directories within project.

Features:

  - Centralized -- Tasks can be run in any folder under your home directory without adding them to your path

  - Parsed and Validated Input -- Easily access named command line arguments

  - Scoped -- Different tasks are loaded depending on the current working directory

  - Isolated -- Environment variables aren't affected (unless you want them to be)


Bash Task Master was designed with flexibility and expandibility in mind.


## Installation


1\. Clone the repository


``` bash

git clone https://github.com/hppr-dev/bash-task-master

```

2\. Run the install script

``` bash

cd bash-task-master
./install-task-master.sh 

```

3\. Log out and back in

4\. Run ` task list ` to verify that it is installed

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

arguments_greet() {
  GREET_DESCRIPTION="An example task!"
  GREET_REQUIREMENTS="name:n:str"
}

task_greet() {
  echo "Hello $ARG_NAME, good day to you!"
}

```

4\. Run it!

``` bash

task greet -n "internet" # Run the task
Running greet: task...
Hello internet, good day to you!

```

5\. Get help on it!

``` bash

task help greet          # Get help on the task
  Running help:greet task...
  Command: task greet
    An example task!
    Required:
      --name, -n str

```

6\. Validate it!

``` bash

task greet               # Fail the task
Missing required argument: --name

```


# Calling Tasks

```

  task compose up -f --service frontend
          │     │  │      │       │
  Command ┘     │  │      │       └ ARG_SERVICE 
     Subcommand ┘  │      └ Long Argument
    Short Argument ┘


```
