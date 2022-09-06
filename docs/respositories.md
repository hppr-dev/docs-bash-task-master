# Repositories

Repositories store modules and drivers for sharing and reuse.
Update the TASK_REPOS config value in $TASK_MASTER_HOME/config.sh to add a module repository.
By default, TASK_REPOS is set to the official extras repository: [btm-extra](https://github.com/hppr-dev/btm-extra).
The TASK_REPOS value should be a space separated list of URIs of repository inventory files.


## Inventory File

Each task repository needs to have an `inventory` file that enumerates what drivers and modules it provides.
The inventory file lists the available modules and which files correspond with what modules and drivers.

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

## Repository Modules

Repository modules are required to be contained in a single file.
This file should be referenced by the `module-ID` line in the inventory line.
Modules should always define an arguments functions that defines a description so that users have a quick reference for the provided tasks usage.

## Repository Drivers

Repository drivers must implement all of the keys of the driver [interface](https://bash-task-master.readthedocs.io/en/latest/drivers/#custom-drivers).
If a driver does not implement all of the proper variables, the tasks function will fail when trying to use it.

Repository drivers must contain metadata about the underlying driver.
A driver must have a task_file_name specified in a key value comment somewhere in the file: `# task_file_name = myfile.name`
This specifies the file name to use for this driver.

Drivers may also require extra files to run.
These files may be enumerated in the main driver file using a key=value line: `# extra_file=extra/file.sh`.
The filepaths specified by these keys will be recreated on the downloading host in the $TASK_MASTER_HOME/lib/drivers directory.
In other words, the driver references it's extra files using relative paths to it's current directory.

!!! example

    ``` bash
    # Used for tasks.yaml files
    # tasks_file_name = tasks.yaml
    # Depends on two extra files
    # extra_file = yaml/validator.py
    # extra_file = yaml/executor.py

    DRIVER_PARSE_ARGS="yaml_parse"
    DRIVER_VALIDATE_ARGS="yaml_validate"
    DRIVER_LOAD_TASKS_FILE=":"
    DRIVER_EXECUTE_TASK="yaml_execute"
    DRIVER_LIST_TASKS="yaml_list"
    DRIVER_HELP_TASK="yaml_help"
    DRIVER_VALIDATE_TASKS_FILE="yaml_validate_tasks_file"

    yaml_parse() {
      ...
    }

    yaml_validate() {
      ...
    }

    yaml_execute() {
      python yaml/executor.py $1
    }
    yaml_list() {
      ...
    }
    yaml_help() {
      ...
    }
    yaml_validate_tasks_file() {
      python yaml/validator.py $1
    }

    ```

## Repository Hosting

Inventory files are pulled using `curl`.
The btm-extra file is hosted on github, but any curl-able url will work.
The only requirement is that the requesting host can connect and access the inventory file and the MODULE_DIR and DRIVER_DIR directories.

Test an inventory file URI with:

``` bash
curl https://myurl/inventory
```

This should succesd and show you the full inventory file.

