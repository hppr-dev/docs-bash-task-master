# Repositories

Repositories store modules and drivers for sharing and reuse.
Update the `TASK_REPOS` config value in `$TASK_MASTER_HOME/config.env` to add a module repository.
By default, `TASK_REPOS` is set to use the official extras repository on github: [btm-extra](https://github.com/hppr-dev/btm-extra).
The `TASK_REPOS` value should be a space separated list of URIs of repository inventory files.

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
This file should be referenced by the `module-NAME` line in the inventory line.
Modules should always define an arguments functions that defines a description so that users have a quick reference for the provided task's usage.

## Repository Drivers

Repository drivers must implement all of the keys of the driver [interface](/drivers/#custom-drivers).
If a driver does not implement all of the proper variables, the task function will fail when trying to use it.

Driver settings are enumerated in the driver file in the repository.
These are specified by using key value comments in the driver's bash file.
Here is a list of directives that are supported:

| Directive | Required? | Description |
|-----------|-----------|-------------|
| task_file_name | YES | The task file name to use with this driver. Automatically installed into the installed_drivers.sh file.|
| extra_file | | An extra file to download into the DRIVER_DIR along with the driver. May have any number of files specified. These file paths are relative to the where the driver.sh file is stored. |
| dependency | | Denotes a dependency needed to run the driver. If the given command is not found, the driver installation will fail |
| setup      | | A setup script to run after pulling down files, but before enabling the driver. If this script fails, driver installation will fail.|

!!! example
    Here is an example of a driver with all of the directives being used:

    ``` bash
    # Used for tasks.yaml files
    # tasks_file_name = tasks.yaml

    # Needs two extra files
    # extra_file = yaml/validator.py
    # extra_file = yaml/executor.py

    # Requires python to be installed
    # dependency = python

    # Setup script to run after downloading the extra files
    # setup = yaml/setup.sh

    ...

    ```

    And the repository would have the following structure:

    ```txt
    inventory
    drivers/
        yaml_driver.sh
        yaml/
            validator.py
            executor.py
            setup.sh
    ```


## Repository Hosting

Inventory files are pulled using `curl`.
The btm-extra file is hosted on github, but any curl-able url will work.
The only requirement is that the requesting host can connect and access the inventory file and the MODULE_DIR and DRIVER_DIR directories.

To pull from the local filesystem you can add a url like `file:///home/me/myrepo/inventory` to `TASK_REPOS`
