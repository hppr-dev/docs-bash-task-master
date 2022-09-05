# Modules

Modules are task files that are available globally throughout your user environment.
These modules are kept in the `$TASK_MASTER_HOME/modules` directory.
Module files use the [bash task syntax](https://bash-task-master.readthedocs.io/en/latest/drivers/#bash-driver).
Modules define tasks and/or functions that may be used in tasks anywhere in a users environment.

## Managing modules

Modules can be managed using the built in [module](https://bash-task-master.readthedocs.io/en/latest/built_in_tasks/#module) task.
This task is responsible for downloading, enabling, disabling and listing local and remote modules.

## Local Modules

Modules may be created locally by placing a `-module.sh` file directly in $TASK_MASTER_HOME/modules.
Any file that ends in `-module.sh` will be loaded when running the task.


## Remote Modules

Modules may also be hosted remotely to share modules between users and installations.

Add another repo by updating TASK_REPO in the $TASK_MASTER_HOME/config.sh file with the uri of the repositories inventory file:

``` bash
TASK_REPOS="https://raw.githubusercontent.com/hppr-dev/btm-extra/main/inventory https://myrepo/inventry"
```

After adding the repository, any module hosted on the added repository is enablable by running ` task module enable -i MOD_ID `.

!!! warning
    It is important to vet and review any module repositories that you would like to use.
    If you are wary of a module source, make sure to be logged in as an unpriviledged user (i.e. without passwordless sudo).
    Any module task is run with the same permissions as the logged in user.

## Repositories

Repositories can be used to store modules.
These modules can be downloaded and enabled in the current environment.
Update the TASK_REPOS config value in $TASK_MASTER_HOME/config.sh to add a module repository.
By default, TASK_REPOS is set to the official extras repository: [btm-extra](https://github.com/hppr-dev/btm-extra).
The TASK_REPOS value should be a space separated list of URIs of repository inventory files.


### Inventory File

Each task repository needs to have an `inventory` file.
The inventory file lists the available modules and which files correspond with what modules.

The inventory file format is a simple key, value format.
Any line that is not in the format of key=value is ignored.

The `MODULE_DIR` and `DRIVER_DIR` are special required keys that are used to specify the directory relative to the inventory file that contains the driver and module files.
Keys that start with `module-` point to module files and `driver-` keys point to driver files.


!!! example

    The following repository contains the venv, gonv, and todo modules and the gitlab driver:
    ``` txt
      ===== Directories =====
      
      MODULE_DIR = modules
      DRIVER_DIR = drivers
      
      ===== Included Modules =====
      
      module-venv = venv-module.sh.disabled
      module-gonv = gonv-module.sh.disabled
      module-todo = todo-module.sh.disabled
      
      ====== Included Drivers =====
      
      driver-gitlab = gitlab-driver.sh
    ```

### Repository Hosting

Inventory files are pulled using `curl`.
The btm-extra file is hosted on github, but any curl-able url will work.
The only requirement is that the requesting host can connect and access the inventory file and the MODULE_DIR and DRIVER_DIR directories.

Test an inventory file URI with:

``` bash
curl https://myurl/inventory
```

This should succesd and show you the full inventory file.

