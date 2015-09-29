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

Slapshot__callable_build(){
    # Preparing
    Slapshot_prepare
    if [[ $? -ne 1 ]]; then
        return
    fi

    # Building
    Slapshot_pre_build
    Slapshot_build

    # Checking Success
    if [[ $? -ne 0 ]]; then
        Logger__error "Build failed.  Do not call \`upload\` until after a successful build"
    else
        Logger__success "Build Successful, you can now call upload to cut a new build on HockeyApp"
    fi
}

Slapshot__callable_upload(){
    # Preparing
    Slapshot_prepare
    if [[ $? -ne 1 ]]; then
        return
    fi

    # Reading flags
    Slapshot_read_flags "$@"

    # Uploading
    Slapshot_upload
    Slapshot_post_upload
}
