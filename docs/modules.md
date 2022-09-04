# Modules

Modules are task files that are available globally throughout your user environment, i.e. anything deeper than your user directory.
These modules are kept in the `$TASK_MASTER_HOME/modules` directory.
Enabled modules end in -module.sh.
Module files must be in the bash task file format.

## Managing modules

*This feature is in development*

Modules may be kept in a git repository.
Which repositories to use as a module repositories is configured in the `MODULE_REPOS` variable in the `$TASK_MASTER_HOME/config.sh` file.
`MODULE_REPOS` can be set to any number of space separated git repostories.

WARNING:
It is important to vet and review any module repositories that you would like to use.
If you are wary of a module source, make sure to be logged in as an unpriviledged user (i.e. without passwordless sudo).

### Setting Up a Module repository

A module repository may house any number of files.
Any module files must be saved as MODULENAME-module.sh.disabled.
If there are any files that end with -module.sh, the none of the modules may be used.

### Enabling a module

After adding the repository to the `MODULE_REPOS` config variable in `$TASK_MASTER_HOME/config.sh`, run the following command to enable a module:

```
  task global module -e venv
```

This will search the repositories for a venv-module.sh.disabled file, pull that repository into the `$TASK_MASTER_HOME/modules/` directory and enable it.

