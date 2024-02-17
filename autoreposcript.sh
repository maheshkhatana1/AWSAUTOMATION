#!/bin/bash

# GitHub credentials
USERNAME="maheshkhatana1"
REPO_NAME="MyPortfolio"
ACCESS_TOKEN="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"

# List of files to be uploaded
FILES=(
    "DeletingEmptyS3Buckets.py"
    "DeletingUnusedEBSVolumes.py"
    "DeletingUnusedIPAddresses.py"
    "SendingEmailstoUsersUsingAWSSESandSNS.py"
    "TranscribinganMP4toTextUsingAWSTranscribe.py"
    "DeletingEBSSnapshots.py"
)

# Check if the repository already exists
repo_exists=$(curl -s -o /dev/null -w "%{http_code}" -u $USERNAME:$ACCESS_TOKEN https://api.github.com/repos/$USERNAME/$REPO_NAME)

if [ $repo_exists -eq 200 ]; then
    echo "Repository already exists."
else
    # Create a new GitHub repository
    curl -u $USERNAME:$ACCESS_TOKEN https://api.github.com/user/repos -d '{"name":"'$REPO_NAME'"}'
fi

# Create a new directory for your project or navigate into the existing repository
mkdir -p $REPO_NAME
cd $REPO_NAME

# Initialize a Git repository (if not already initialized)
if [ ! -d ".git" ]; then
    git init
fi

# Check if each file already exists in the repository
for FILE in "${FILES[@]}"; do
    if git ls-remote --exit-code origin "master:$FILE" &>/dev/null; then
        echo "File $FILE already exists on GitHub. Skipping upload."
    else
        # Copy the file to the project directory
        cp "../$FILE" .

        # Add and commit the file
        git add "$FILE"
        git commit -m "Add $FILE"

        echo "File $FILE added and committed."

        # Push the changes to GitHub
        git push origin master
    fi
done

