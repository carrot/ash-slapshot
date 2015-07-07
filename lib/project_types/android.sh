#!/bin/bash

Slapshot_validate_build() {
    if [[ "$Slapshot_config_hockey_app_id" = "" ]]; then
        Logger__error "No hockey_app_id provided in the slapshot_config.yaml file"
        return 0
    fi

    if [[ "$Slapshot_config_hockey_app_secret" = "" ]]; then
        Logger__error "No hockey_app_secret provided in the slapshot_config.yaml file"
        return 0
    fi

    if [[ "$Slapshot_config_git_upload_branch" = "" ]]; then
        Logger__error "No git_upload_branch provided in the slapshot_config.yaml file"
        return 0
    fi

    if [[ "$Slapshot_config_android_manifest_location" = "" ]]; then
        Logger__error "No android_manifest_location provided in the slapshot_config.yaml file"
        return 0
    fi

    if [[ ! -f "$Slapshot_config_android_manifest_location" ]]; then
        Logger__error "android_manifest_location is not pointing to a file"
        return 0
    fi

    if [[ "$Slapshot_config_apk_location" = "" ]]; then
        Logger__error "No apk_location provided in the slapshot_config.yaml file"
        return 0
    fi

    if [[ ! -f "$Slapshot_config_apk_location" ]]; then
        Logger__error "apk_location is not pointing to a file"
        return 0
    fi

    return 1
}

Slapshot_pre_build() {
    Logger__log "Pre-Build"
}

Slapshot_build() {
    Logger__log "Build"
}

Slapshot_post_build() {
    Logger__log "Post-Build"
}

Slapshot_upload() {
    Logger__log "Upload"
}

Slapshot_post_upload() {
    Logger__log "Post-Upload"
}
