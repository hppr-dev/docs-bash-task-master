# State

Each task potentially has a file in $TASK_MASTER_HOME/state/$TASK_NAME.vars to save state variables in.

To take advantage of this you may use in a task:

```
  persist_var "MY_VAR" "10"
```

The next time the same task is run $MY_VAR will be set to 10, but not in your outside environment.
This also sets the variable in the current task as well.
The variable will remain set until the following is called within a subtask of task:

```
  remove_var "MY_VAR"
```

If you need to use a variable outside of the task process run:

```
  export_var "SOME_VAR" "44"
```

If you need to save the current value of a variable use:

```
  hold_var "SOME_VAR"
```

which will save the current value of SOME_VAR until `release_var` is called:

```
  release_var "SOME_VAR"
```

which will reset and export the variable to it's previous value.

For example the following creates a task to change the value of PS1 to "(tester)":

```
  task_tester() {
    if [[ $TASK_SUBCOMMAND == "set" ]]
    then
      hold_var "PS1"
      export_var "PS1" "(tester)"
    elif [[ $TASK_SUBCOMMAND == "unset" ]]
    then
      release_var "PS1"
    fi
  }
```
