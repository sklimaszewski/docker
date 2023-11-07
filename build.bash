#!/bin/bash

# Initialize variables with default values
param_slim=false
param_variant=
param_merge=false
param_multiarch=false

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTIONS] IMAGE VERSION"
    echo "OPTIONS:"
    echo "  -a, --multi-arch        Multi-architecture build"
    echo "  -m, --merge             Merge multiple manifest into single image"
    echo "  -s, --slim              Creates smaller variant of an image"
    echo "  -v, --variant (name)    Pass custom variant of an image"
    echo "  -h, --help              Display this help message"
    exit 0
}

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -a|--multi-arch)
            param_multiarch=true
            shift
            ;;
        -m|--merge)
            param_merge=true
            shift
            ;;
        -s|--slim)
            param_slim=true
            shift
            ;;
        -v|--variant)
            if [ -n "$2" ]; then
                param_variant="$2"
                shift 2
            else
                echo "Error: Missing value for variant parameter."
                exit 1
            fi
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [ -z "$arg_image" ]; then
                arg_image="$1"
            elif [ -z "$arg_version" ]; then
                arg_version="$1"
            else
                echo "Error: Extra argument found: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if the required arguments are provided
if [ -z "$arg_image" ] || [ -z "$arg_version" ]; then
    echo "Error: Two required arguments are missing."
    usage
fi

# Build image
tag="sklimaszewski/${arg_image}:${arg_version}"
platform="linux/arm64,linux/amd64"
build_path=${arg_image}

if [ -d "${build_path}/${arg_version}" ]; then
    build_path="${build_path}/${arg_version}"
fi

if [ -n "$param_variant" ]; then
    tag="${tag}-${param_variant}"
    build_path="${build_path}/${param_variant}"
fi

if [ "$param_slim" = true ]; then
    tag="${tag}-slim"
    build_path="${build_path}/slim"
fi

if [ "$param_multiarch" = true ]; then
    architecture="linux/arm64,linux/amd64"
else
    machine_arch=$(uname -m)

    if [[ "$machine_arch" == "aarch64" || "$machine_arch" == "arm64" ]]; then
        architecture="linux/arm64"
        tag="${tag}-arm64"
    else
        architecture="linux/amd64"
        tag="${tag}-amd64"
    fi
fi

if [ "$param_multiarch" = true ] && [ "$param_merge" = true ]; then
    echo "Merging ${tag} multi-architecture image ..."
    docker manifest create ${tag} --amend ${tag}-arm64 --amend ${tag}-amd64
    docker manifest push ${tag}
else
    echo "Building and pushing image ${tag} in ./${build_path} ..."
    if [ "$param_multiarch" = true ]; then
        docker buildx build --build-arg VERSION=${arg_version} --tag ${tag} --squash --platform ${platform} --push ${build_path}
    else
        docker build --build-arg VERSION=${arg_version} --tag ${tag} --squash --push ${build_path}
    fi
fi