## Initializing a Task File

Initializing a task file is as simple as changing to the project directory and running:

``` bash
mkdir project
cd project
task init
```

This will create a tasks.sh file in the current directory and bookmark the directory.
The tasks.sh file is used to hold tasks that are related to the project.
Bookmarking a directory saves the location so that you can quickly change directories back to the project:

``` bash
cd ~
task goto project
```

The default name of the bookmark is the name of the directory where `task init` was called (in this case project)

## Creating a Simple Task

Let's say that we find ourselves running the following commands a lot:

``` bash

docker run --detach --rm -it -e POSTGRES_PASSWORD=secret --name mydb postgres
docker stop mydb

```

We could write this into a couple tasks:

``` bash

task_start() {
  docker run --detach --rm -it -e POSTGRES_PASSWORD=secret --name mydb postgres
}
task_stop() {
  docker stop mydb
}

```

Now to run these tasks we can run:

``` bash

task start
task stop

```

Or we can use the `t` alias:

``` bash

t start
t stop

```

Now we have a short, contextual way of running these commands.
If we ever forget what tasks are defined in the local context, we can run `task list` to list all of the local tasks.

## Adding Arguments

We can easily add arguments to our newly created tasks.
We just need to implement the `arguments_start` function and change `task_start` to the following:

``` bash
arguments_start() {
  START_DESCRIPTION="Run the postgres database"
  START_OPTIONS="detach:d:bool name:n:str"
}

task_start() {
  if [[ -z "$ARG_NAME" ]]
  then
    ARG_NAME=mydb
  fi
  if [[ -n "$ARG_DETACH" ]]
  then
    extra_args=--detach
  fi
  docker run $extra_args --rm -it -e POSTGRES_PASSWORD=secret --name $ARG_NAME postgres
}

```

The `START_OPTIONS` variable in the arguments defines what optional arguments the task accepts.
If we had instead named this variable as `START_REQUIREMENTS` these areguments would be required.
Task execution does not start if a required argument is not supplied.
The `START_DESCRIPTION` variable is used as a description of the task when `task help start` is called.
Including a description for tasks is a good idea, as it is a simple way to document what a task is supposed to do.

With these arguments we can run the `start` task with the following arguments:

``` {.bash .no-copy}

# Equivalent to: docker run --detach --rm -it -e POSTGRES_PASSWORD=secret --name mydb postgres
$ task start --detach

# Equivalent to: docker run --rm -it -e POSTGRES_PASSWORD=secret --name mydb postgres
$ task start

# Equivalent to: docker run --rm -it -e POSTGRES_PASSWORD=secret --name anotherdb postgres
$ task start -n anotherdb

```

## Saving State 

Now that we have tasks to start any number of containers, we need a way to keep track of and stop all of the containers we have started

First we need to save the names of the containers that we started in `task_start`:

``` bash
task_start() {
  if [[ -z "$ARG_NAME" ]]
  then
    ARG_NAME=mydb
  fi
  if [[ -n "$ARG_DETACH" ]]
  then
    extra_args=-d
    persist_var "STARTED" "$STARTED $ARG_NAME"
  fi
  docker run $extra_args --rm -it -e POSTGRES_PASSWORD=secret --name $ARG_NAME postgres
}
```

Then we can add another task to show what containers we have started:

``` bash
task_show() {
  echo Started containers: $STARTED
}
```

Finally we can update the stop task to stop all of the containers:

``` bash
task_stop() {
  docker stop $STARTED
  remove_var "STARTED"
}
```

Now to test we can run the following:

``` {.bash .no-copy}

# Start a few containers
$ t start -d
Running start: task...
c164e181e...
$ t start -d -n other
Running start: task...
34ef64e18...
$ t start -d -n another
Running start: task...
164ae18fc...

# Show the running containers
$ t show
mydb other another

# Stop all of the running containers
$ t stop

```

## Make it portable

Now that we have our task written, suppose we want to make it available to other projects in our local environment.
There are two ways to accomplish this: modules or templates

### Making a template

Templates are useful for when you have a basic task file that you like to tweak for each of your projects.
All we need to do is create a template file in `$TASK_MASTER_HOME/templates` and then use that template as an argument to `task init`.

For our example lets copy our tasks.sh file to a file named pgdocker.template:

``` bash
cp tasks.sh $TASK_MASTER_HOME/templates/pgdocker.template
```

Then to use it as a template we just need to specify `--template pgdocker` (`-t` for short) when calling `task init`:

``` bash
cd
mkdir new_project
cd new_project
task init -t pgdocker
```

The created tasks.sh file is a direct copy of the pgdocker.template file. 
We can list our tasks and our templates:

``` {.bash .no-copy}
$ task list
Running list: task...
start	      show	    stop

$ task template list
Running template:list task...
pgdocker
```

### Making a module

Modules are useful for when you want to make a task available to all projects in the global scope.
Modules are stored in the `$TASK_MASTER_HOME/modules` directory and they must end in `-module.sh`.
Any task defined in a module must be marked as readonly to show up in the global scope.
This prevents local tasks from overwriting module functions.
As a general rule, there should only be a single task per module.

In the case of converting our task file to a module, we'll have to do some editing to put all of our tasks together.
In `$TASK_MASTER_HOME/modules/pgdocker-module.sh` we can write:

``` bash

arguments_pgdocker() {
  PGDOCKER_DESCRIPTION="Manage postgres containers"
  SUBCOMMANDS="start|show|stop"

  START_DESCRIPTION="Start a postgres container"
  START_OPTIONS="name:n:str detach:d:bool"

  SHOW_DESCRIPTION="Show the running postgres containers"

  STOP_DESCRIPTION="Stop all the running postgres containers"
}

task_pgdocker() {
  if [[ "$TASK_SUBCOMMAND" == "start" ]]
  then
    if [[ -z "$ARG_NAME" ]]
    then
      ARG_NAME=mydb
    fi
    if [[ -n "$ARG_DETACH" ]]
    then
      extra_args=-d
      # Notice the change here to persist_module_var
      persist_module_var "STARTED" "$STARTED $ARG_NAME"
    fi
    docker run $extra_args --rm -it -e POSTGRES_PASSWORD=secret --name $ARG_NAME postgres

  elif [[ "$TASK_SUBCOMMAND" == "show" ]]
  then
    echo Started containers: $STARTED

  elif [[ "$TASK_SUBCOMMAND" == "stop" ]]
  then
    docker stop $STARTED
    # Notic the change here to remove_module_var
    remove_module_var "STARTED"
  fi
}

# Tasks in modules are required to be marked as readonly
readonly -f task_pgdocker

```

!!! Note
    We are using `persist_module_var` and `remove_module_var` here instead of `persist_var` and `remove_var`.
    The module variations of these function provide a mechanism to save module variables independently of task file context.
    If we were to use `persist_var`, state would depend on the current working directory.

Now the task will show when we list the global task:

``` {.bash .no-copy}

$ task list -g
Running list: task...
... pgdocker ...

$ task help pgdocker
Running help:pgdocker task...
Command: task pgdocker
  Manage postgres containers

Command: task pgdocker start
  Start a postgres container
  Optional:
    --name, -n str
    --detach, -d

Command: task pgdocker show
  Show the running postgres containers

Command: task pgdocker stop
  Stop all the running postgres containers

```
