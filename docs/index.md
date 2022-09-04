# Introduction

Bash Task Master enhances bash by providing a way to create context for directories within project.

Features:

  - Centralized -- Tasks can be run in any folder under your home directory without adding them to your path

  - Parsed and Validated Input -- Easily access named command line arguments

  - Scoped -- Different tasks are loaded depending on the current working directory

  - Isolated -- Environment variables aren't affected (unless you want them to be)


Bash Task Master was designed with flexibility and expandibility in mind.


## Installation

Install Bash Task Master by:

1.Clone the repository and runn the install script:
```
  git clone https://github.com/hppr-dev/bash-task-master
  cd bash-task-master
  ./install-task-master.sh 
```
2.Log out and back in

3.Run `task list` to verify that it is installed

## Your First Task File

Once Bash Task Master is installed:

1.Create a new directory

```
mkdir tutorial
```

2.Initialize a tasks file

```
cd tutorial
task init
```

3.Write a task

```
task edit # opens tasks.sh in vi by default
```
    
Add the following to the file and exit.
    
    ```
    arguments_greet() {
      GREET_DESCRIPTION="An example task!"
      GREET_REQUIREMENTS="name:n:str"
    }
    
    task_greet() {
      echo "Hello $ARG_NAME, good day to you!"
    }
    ```

4.Run it!

```
task greet -n "internet" # Run the task
Running greet: task...
Hello internet, good day to you!
```

5.Get help on it!

```
task help greet          # Get help on the task
  Running help:greet task...
  Command: task greet
    An example task!
    Required:
      --name, -n str
```

6.Validate it!

```
task greet               # Fail the task
  Missing required argument: --name

```
