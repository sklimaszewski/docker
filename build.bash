#!/bin/bash

# Initialize variables with default values
param_slim=false
param_database=

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTIONS] IMAGE VERSION"
    echo "OPTIONS:"
    echo "  -s, --slim              Creates smaller variant of an image"
    echo "  -d, --database (name)   Set database engine for PHP image"
    echo "  -h, --help              Display this help message"
    exit 0
}

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--slim)
            param_slim=true
            shift
            ;;
        -d|--database)
            if [ -n "$2" ]; then
                param_database="$2"
                shift 2
            else
                echo "Error: Missing value for database parameter."
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
if [ -z "$param_database" ]; then
    if [ "$param_slim" = true ]; then
        docker buildx build --build-arg VERSION=${arg_version} --build-arg DB=${param_database} --tag sklimaszewski/${arg_image}:${arg_version}-slim --squash --platform "linux/arm64,linux/amd64" --push ${arg_image}/slim
    else
        docker buildx build --build-arg VERSION=${arg_version} --build-arg DB=${param_database} --tag sklimaszewski/${arg_image}:${arg_version} --squash --platform "linux/arm64,linux/amd64" --push ${arg_image}
    fi
else
    if [ "$param_slim" = true ]; then
        docker buildx build --build-arg VERSION=${arg_version} --build-arg DB=${param_database} --tag sklimaszewski/${arg_image}:${arg_version}-${param_database}-slim --squash --platform "linux/arm64,linux/amd64" --push ${arg_image}/slim
    else
        docker buildx build --build-arg VERSION=${arg_version} --build-arg DB=${param_database} --tag sklimaszewski/${arg_image}:${arg_version}-${param_database} --squash --platform "linux/arm64,linux/amd64" --push ${arg_image}
    fi
fi