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
    # Preparing
    Slapshot_prepare
    if [[ $? -ne 0 ]]; then
        return
    fi

    # Building
    Slapshot_pre_build
    Slapshot_build

    # Checking Success
    if [[ $? -ne 0 ]]; then
        git checkout "$Slapshot_config_android_manifest_location"
        Logger__error "Build failed"
    else
        # Checking if APK file exists
        if [[ ! -f "$Slapshot_config_apk_location" ]]; then
            Logger__error "apk_location is not pointing to a file"
            return
        fi

        # Reading flags
        Slapshot_read_flags "$@"

        # Uploading
        Slapshot_upload
        Slapshot_post_upload
    fi
}
