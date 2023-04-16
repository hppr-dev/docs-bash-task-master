# State

## Local Context State

Each task file context has a file in `$TASK_MASTER_HOME/state/$TASK_NAME.vars` to save state variables.

The `persist_var` function is used to save a state value:

``` bash

persist_var "INITIALIZED" "true"

```

After calling `persist_var` on a variable, it will be set for any current or future task within the current task file context.

The `remove_var` function does the opposite of `persist_var`. It removes values from the stored state:

``` bash

remove_var "INITIALIZED"

```

The `export_var` function is used to export a value to the calling user's shell:

``` bash

export_var "SOME_VAR" "44"

```

The `hold_var` and `release_var` functions save the current value of a variable in state:

``` bash
# Save the current value for PS1
hold_var "PS1"

# Restore the saved value for PS1
release_var "PS1"
```

Here is an example of using these functions in a tasks.sh file

``` bash
task_env() {
  if [[ $TASK_SUBCOMMAND == "activate" ]]
  then
    hold_var "PS1"
    export_var "PS1" "(tester)"
  elif [[ $TASK_SUBCOMMAND == "deactivate" ]]
  then
    release_var "PS1"
  elif [[ $TASK_SUBCOMMAND == "initialize" ]]
  then
    persit_var "INITIALIZED" "true"
  elif [[ $TASK_SUBCOMMAND == "destroy" ]]
  then
    remove_var "INITIALIZED"
  fi
}
```

## Module State

The following module variations of the above functions do the same thing as their non-module counterparts, but they save to a globale state file.

``` bash
persist_module_var "HELLO" "world"
remove_module_var "HELLO"
hold_module_var "PS1"
release_module_var "PS1"
```

## Special State Variables

Some state variables are used to effect the outside session.
These special variables are wrapped with functions that are available to tasks.

| Function             | Example                      |  State Variable     |Action |
|----------------------|------------------------------|---------------------|-------|
| set_return_directory | `set_return_directory "$HOME"` |  `TASK_RETURN_DIR   ` | Change the current working directory for the outside bash session |
| set_trap             | `set_trap "echo exiting..."  ` |  `TASK_TERM_TRAP    ` | Sets an exit trap for the outside bash session |
| clean_up_state       | `clean_up_state              ` |  `DESTROY_STATE_FILE` | Remove the current state file after finishing task execution | 
