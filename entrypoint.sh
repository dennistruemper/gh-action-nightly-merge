#!/bin/bash

set -e

echo
echo "  'Nightly Merge Action' is using the following input:"
echo "    - stable_branch = '$INPUT_STABLE_BRANCH'"
echo "    - development_branch = '$INPUT_DEVELOPMENT_BRANCH'"
echo "    - user_name = $INPUT_USER_NAME"
echo "    - user_email = $INPUT_USER_EMAIL"
echo



git remote set-url origin https://x-access-token:${!INPUT_PUSH_TOKEN}@github.com/$GITHUB_REPOSITORY.git
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

set -o xtrace

git fetch origin $INPUT_STABLE_BRANCH
git checkout $INPUT_STABLE_BRANCH

git fetch origin $INPUT_DEVELOPMENT_BRANCH
git checkout $INPUT_DEVELOPMENT_BRANCH


set +o xtrace
echo
echo "  'Nightly Merge Action' is trying to merge the '$INPUT_STABLE_BRANCH' branch ($(git log -1 --pretty=%H $INPUT_STABLE_BRANCH))"
echo "  into the '$INPUT_DEVELOPMENT_BRANCH' branch ($(git log -1 --pretty=%H $INPUT_DEVELOPMENT_BRANCH))"
echo
set -o xtrace

# Do the merge
git merge --ff-only --no-edit $INPUT_STABLE_BRANCH


# Push the branch
git push origin $INPUT_DEVELOPMENT_BRANCH
