#!/bin/bash

Slapshot_notify=1
Slapshot_last_push_file="slapshot-last-commit.txt"
Slapshot_release_notes_file="release_notes.tmp.txt"

Slapshot_validate_build() {
    if [[ "$Slapshot_config_hockey_app_api_token" = "" ]]; then
        Logger__error "No hockey_app_token provided in the slapshot_config.yaml file"
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

Slapshot_read_flags() {
    for flag in "$@"
    do
        # -silent: Causes no notification in HockeyApp
        if [ "$flag" = "--silent" ]; then
            Logger__warning "Running silent mode, there will be no HockeyApp notification."
            Slapshot_notify=0
        # Unknown Flag, causes an exit
        else
            Logger__error "Unknown flag: $flag.  Exiting."
            exit
        fi
    done
}

Slapshot_pre_build() {
    Logger__warning "Pre-Build"

    # Matching remote
    git checkout "$Slapshot_config_git_upload_branch"
    git fetch
    git pull origin "$Slapshot_config_git_upload_branch"
    git submodule update

}

Slapshot_build() {
    Logger__warning "Building"
    ./gradlew build
    return $?
}

Slapshot_upload() {
    Logger__warning "Generating Release Notes"

    #Getting changes
    if [[ -f "$Slapshot_last_push_file" ]]; then
        last_sha=`cat $Slapshot_last_push_file`
        current_sha=`git rev-parse HEAD`
        git log --pretty=oneline --abbrev-commit $last_sha...$current_sha | cut -d" " -f2- > "$Slapshot_release_notes_file"
        vim "$Slapshot_release_notes_file"
    #No notes
    else
        echo "No notes" > "$Slapshot_release_notes_file"
        vim "$Slapshot_release_notes_file"
    fi

    # Release Nots in a variable
    local release_notes=$(cat $Slapshot_release_notes_file)

    Logger__warning "Uploading..."

    # Uploading
    curl \
      -F "status=2" \
      -F "notify=$Slapshot_notify" \
      -F "notes=$release_notes" \
      -F "notes_type=1" \
      -F "ipa=@$Slapshot_config_apk_location" \
      -H "X-HockeyAppToken: $Slapshot_config_hockey_app_api_token" \
      https://rink.hockeyapp.net/api/2/apps/upload

    # echo for linebreak (curl doesn't add a linebreak)
    echo; Logger__warning "Upload finished"

    # Removing changelog from filesystem
    rm "$release_notes"
}

Slapshot_post_upload() {
    Logger__warning "Pushing version bump to remote"

    # Updating version code
    Slapshot_update_version_code

    # Committing
    git add "$Slapshot_config_android_manifest_location"
    git commit -am ":new: Slapshot :new: Bumped version number"
    git push origin "$Slapshot_config_git_upload_branch"

    # Updating last push file
    git rev-parse HEAD > "$Slapshot_last_push_file"
}

# =======================================
# =============== Helpers ===============
# =======================================

Slapshot_update_version_code() {
    local manifest="$Slapshot_config_android_manifest_location"
    for line in `grep -o 'android:versionCode="[0-9].*"' $manifest`
    do
        versionCode=$(sed 's/[^0-9]//g' <<< ${line})
        nextVersion=$(($versionCode + 1))

        cp "$manifest" "$manifest.buff"
        sed "s/android:versionCode=\"$versionCode\"/android:versionCode=\"$nextVersion\"/" "$manifest.buff" > "$manifest"
        rm "$manifest.buff"

        break
    done
}
