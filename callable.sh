#!/bin/bash

Ash__import "slapshot"
Ash__import "yaml-parse"

Slapshot__callable_main(){
    Slapshot__callable_help
}

Slapshot__callable_help(){
    more "$Ash__active_module_directory/HELP.txt"
}

Slapshot__callable_init(){
    # Hasn't been initialized
    if [[ ! -f "$Slapshot_config_file_path" ]]; then
        cp "$Slapshot_default_config_file_path" "$Slapshot_config_file_path"
        Logger__success "Directory successfully initialized"
        Logger__warning "Don't forget to update $Slapshot_config_file_name before running upload!"

    # Has already been created
    else
        Logger__error "Directory is already initialized"
    fi
}

Slapshot__callable_upload(){
    # Checking if we're initialized
    if [[ ! -f "$Slapshot_config_file_path" ]]; then
        Logger__error "Directory is not initialzed.  Run ash slapshot:init to get started"
        return
    fi

    # Pulling in .yaml variables
    Slapshot_prepare_variables

    # Loading in the proper project type
    if [[ $Slapshot_config_project_type = "Android" ]]; then
        . "$Slapshot_project_types_path/android.sh"
    else
        Logger__error "Invalid project_type"
        return
    fi

    # Validate Build
    Slapshot_validate_build
    if [[ $? -ne 1 ]]; then
        return
    fi

    # Reading flags
    Slapshot_read_flags "$@"

    # Start build
    Slapshot_pre_build
    Slapshot_build
    Slapshot_upload
    Slapshot_post_upload
}
