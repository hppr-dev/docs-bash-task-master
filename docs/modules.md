# Modules

Modules are task files that are available globally throughout your user environment.
These modules are kept in the `$TASK_MASTER_HOME/modules` directory.
Module files use the [bash task syntax](/drivers/#bash-driver).
Modules define tasks and/or functions that may be used in tasks anywhere in a users environment.

## Managing modules

Modules can be managed using the built in [module](/built_in_tasks/#module) task.
This task is responsible for downloading, enabling, disabling and listing local and remote modules.

## Local Modules

Modules may be created locally by placing a `-module.sh` file directly in $TASK_MASTER_HOME/modules.
Any file that ends in `-module.sh` will be loaded when running the task.

!!! note
    When writing modules it is important to be aware of possible collisions with other modules that are loaded.
    It is a good idea to mark all module functions as read only by running `readonly -f task_mymod` at the end of the module.
    This will notify module users if any function is redeclared.

## Repository Modules

Modules may also be hosted remotely to share modules between users and installations.

Add another repo by updating TASK_REPO in the $TASK_MASTER_HOME/config.sh file with the uri of the repositories inventory file:

``` bash
TASK_REPOS="https://raw.githubusercontent.com/hppr-dev/btm-extra/main/inventory https://myrepo/inventry"
```

After adding the repository, any module hosted on the added repository is enablable by running ` task module enable -n MOD_NAME `.

!!! warning
    It is important to vet and review any module repositories that you would like to use.
    If you are wary of a module source, make sure to be logged in as an unpriviledged user (i.e. without passwordless sudo).
    Any module task is run with the same permissions as the logged in user.

