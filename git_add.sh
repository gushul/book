#!/bin/sh

git add .
git commit -a -m "$*"
git push git_repo master
