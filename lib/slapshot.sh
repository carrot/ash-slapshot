#!/bin/bash

Slapshot_project_types_path="$Ash__active_module_directory/lib/project_types"
Slapshot_default_config_file_path="$Ash__active_module_directory/extra/default_config.yaml"
Slapshot_config_file_name="slapshot_config.yaml"
Slapshot_config_file_path="$Ash__call_directory/$Slapshot_config_file_name"

##################################
# Prepares slapshot to run.
#
# Also validates if the directory
# has been set up properly.
#
# @returns: 0 if prepared successfully,
#           1 otherwise
##################################
Slapshot_prepare() {
    # Checking if we're initialized
    if [[ ! -f "$Slapshot_config_file_path" ]]; then
        Logger__error "Directory is not initialzed.  Run ash slapshot:init to get started"
        return 1
    fi

    # Pulling in .yaml variables
    eval $(YamlParse__parse "$Slapshot_config_file_path" "Slapshot_config_")

    # Loading in the proper project type
    if [[ $Slapshot_config_project_type = "Android" ]]; then
        . "$Slapshot_project_types_path/android.sh"
    else
        Logger__error "Invalid project_type"
        return 1
    fi

    # Validate Build (project type specific)
    Slapshot_validate_build
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    # Success
    return 0
}
