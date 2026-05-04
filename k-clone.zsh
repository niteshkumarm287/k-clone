#!/usr/bin/env zsh

#
# A script to clone Kubernetes cronjobs or jobs.
#
# Homepage: https://github.com/niteshkumarm287/k-clone
#

# Function to display help message
usage() {
    echo "Usage: $0 [options]"
    echo "A script to clone Kubernetes cronjobs or jobs."
    echo "Homepage: https://github.com/niteshkumarm287/k-clone"
    echo ""
    echo "Options:"
    echo "  -t, --type <type>      The type of resource to clone (cronjob or job). Defaults to cronjob."
    echo "  -n, --namespace <ns>   The namespace to operate in. Defaults to the current namespace."
    echo "  --name <name>          The name of the resource to clone. If not provided, an interactive selector will be shown."
    echo "  --namespace-prefix <p> A prefix to select multiple namespaces to iterate over."
    echo "  -h, --help             Display this help message."
    exit 1
}

# Default values
RESOURCE_TYPE="cronjob"
NAMESPACE=""
RESOURCE_NAME=""
NAMESPACE_PREFIX=""

# Argument parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--type) RESOURCE_TYPE="$2"; shift ;; 
        -n|--namespace) NAMESPACE="$2"; shift ;; 
        --name) RESOURCE_NAME="$2"; shift ;; 
        --namespace-prefix) NAMESPACE_PREFIX="$2"; shift ;; 
        -h|--help) usage ;; 
        *) echo "Unknown parameter passed: $1"; usage ;; 
    esac
    shift
done


# Function to select a resource interactively
select_resource() {
    local type=$1
    local ns=$2
    
    echo "Available ${type}s in namespace '$ns':"
    RESOURCES=($(kubectl get $type -n $ns -o custom-columns=NAME:.metadata.name --no-headers 2>/dev/null))
    if [[ ${#RESOURCES[@]} -eq 0 ]]; then
        echo "No ${type}s found in namespace '$ns'"
        return 1
    fi

    for i in {1..${#RESOURCES[@]}};
    do
        echo "  $i) ${RESOURCES[$i]}"
    done
    echo

    while true; do
        read -r "selection?Select a $type to clone (1-${#RESOURCES[@]}): "
        if [[ "$selection" =~ ^[0-9]+$ ]] && [[ "$selection" -ge 1 ]] && [[ "$selection" -le ${#RESOURCES[@]} ]]; then
            RESOURCE_NAME=${RESOURCES[$selection]}
            break
        else
            echo "Invalid selection. Please enter a number between 1 and ${#RESOURCES[@]}."
        fi
    done
}

# Function to clone a cronjob
clone_cronjob() {
    local cron_job_name=$1
    local ns=$2
    local job_name="clone-of-${cron_job_name}"

    echo "Cloning cronjob '$cron_job_name' as job '$job_name' in namespace '$ns'"

    kubectl delete job.batch/${job_name} -n $ns --ignore-not-found
    kubectl create job -n $ns --from="cronjob.batch/${cron_job_name}" "${job_name}"

    echo "Job '$job_name' created."
}

# Function to clone a job
clone_job() {
    local job_name=$1
    local ns=$2
    local cloned_job_name="clone-of-${job_name}"

    if ! command -v jq &> /dev/null; then
        echo "jq is not installed. Please install jq to clone jobs."
        exit 1
    fi

    echo "Cloning job '$job_name' as job '$cloned_job_name' in namespace '$ns'"

    kubectl delete job.batch/${cloned_job_name} -n $ns --ignore-not-found

    local job_json=$(kubectl get job $job_name -n $ns -o json)
    
    # Remove fields that would prevent creation
    local modified_job_json=$(echo $job_json | jq \
        'del(.spec.selector)' \
        'del(.spec.template.metadata.labels)' \
        'del(.metadata.uid)' \
        'del(.metadata.resourceVersion)' \
        'del(.metadata.creationTimestamp)' \
        'del(.metadata.selfLink)' \
        'del(.status)')
        
    # Change the name
    modified_job_json=$(echo $modified_job_json | jq ".metadata.name = \"$cloned_job_name\"")

    echo $modified_job_json | kubectl apply -n $ns -f - 
    
    echo "Job '$cloned_job_name' created."
}

# Main processing function
process_namespace() {
    local ns=$1
    echo "🟢 Switching to namespace: $ns"
    kubectl config set-context --current --namespace="$ns"

    local target_resource_name=$RESOURCE_NAME
    if [[ -z "$target_resource_name" ]]; then
        select_resource $RESOURCE_TYPE $ns
        if [[ $? -ne 0 ]]; then
            return
        fi
        target_resource_name=$RESOURCE_NAME
    fi
    
    if [[ "$RESOURCE_TYPE" == "cronjob" ]]; then
        clone_cronjob "$target_resource_name" "$ns"
    elif [[ "$RESOURCE_TYPE" == "job" ]]; then
        clone_job "$target_resource_name" "$ns"
    else
        echo "Invalid resource type: $RESOURCE_TYPE"
        usage
    fi
    echo ""
}

if [[ -n "$NAMESPACE_PREFIX" ]]; then
    echo "Looking for namespaces with prefix: $NAMESPACE_PREFIX"
    confirmed_namespaces=()
    while read -r ns; do
      echo "Namespace: $ns"
      read -q "REPLY?Type 'y' to include or any other key to skip: "
      echo ""

      if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        confirmed_namespaces+=("$ns")
      else
        echo "Skipping $ns"
      fi
    done < <(kubectl get ns | grep "${NAMESPACE_PREFIX}" | awk '{ print $1 }')

    for ns in "${confirmed_namespaces[@]}"; do
        process_namespace "$ns"
    done
else
    if [[ -n "$NAMESPACE" ]]; then
        process_namespace "$NAMESPACE"
    else
        CURRENT_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}')
        if [[ -z "$CURRENT_NS" ]]; then
            CURRENT_NS="default"
        fi
        process_namespace "$CURRENT_NS"
    fi
fi