
#!/bin/bash

# GitHub credentials
USERNAME="maheshkhatana1"
ACCESS_TOKEN="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"

# Function to check if a repository is empty
is_repo_empty() {
    local repo_name="$1"
    local commit_count
    commit_count=$(curl -s -H "Authorization: token $ACCESS_TOKEN" https://api.github.com/repos/$USERNAME/$repo_name/commits | jq length)
    
    if [ "$commit_count" -eq 0 ]; then
        return 0  # Repository is empty
    else
        return 1  # Repository is not empty
    fi
}

# Fetch the list of repositories for the user
repos=$(curl -s -H "Authorization: token $ACCESS_TOKEN" https://api.github.com/users/$USERNAME/repos | jq -r '.[].name')

# Loop through each repository
for repo in $repos; do
    echo "Checking repository: $repo"

    # Check if the repository is empty
    if is_repo_empty "$repo"; then
        echo "Repository $repo is empty. Deleting..."

        # Delete the repository on GitHub
        curl -X DELETE -u $USERNAME:$ACCESS_TOKEN https://api.github.com/repos/$USERNAME/$repo

        echo "Repository $repo deleted."
    else
        echo "Repository $repo is not empty. Keeping it."
    fi

    echo
done

