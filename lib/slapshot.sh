#!/bin/bash

Slapshot_project_types_path="$Ash__active_module_directory/lib/project_types"
Slapshot_default_config_file_path="$Ash__active_module_directory/extra/default_config.yaml"
Slapshot_config_file_name="slapshot_config.yaml"
Slapshot_config_file_path="$Ash__call_directory/$Slapshot_config_file_name"

Slapshot_prepare_variables() {
    eval $(YamlParse__parse "$Slapshot_config_file_path" "Slapshot_config_")
    Logger__error "$Slapshot_config_project_type"
}
