# Note that creating a new branch does not clean the working tree,
# but checking out an existing commit does.
# To check out another branch without resetting the working tree, we have to
# detach the head, then move it to the desired commit, then reattach it.

#git config --global alias.switch '!f() { git rev-parse --verify "$*" && git checkout "HEAD^{}" && git reset --soft "$*" && git checkout "$*"; }; f'


# timeline branch name
timeline=timeline

# create timeline branch
git branch $timeline &2>/dev/null

# current branch name
currentBranch="$(git symbolic-ref --short HEAD)"

# main function
backup_branch() {

# save current staging configuration
currentCommit=$(git rev-parse --short HEAD)
cp .git/index .git/index.$currentCommit

# Detach the head pointer from the branch label, so that reset will not move the branch.
git checkout --detach

# Move head to the target commit referenced by the timeline branch label
# and --soft preserves the previous directory index, aka staged versions.
# So, you intend to commit based off of the previous branch's files.
# The default would be to fill the staging area with the target commit's version.
# The head moves to the target branch label by reset, but is not attached.
git reset --soft $timeline

# Checkout does a working tree merge with the target commit, and then
# attaches the head to be branch label, if there are no file conflicts.
# This merge fails when the working tree is not clean, but is skipped here since
# reset moved the head first, and the target commit is already the current commit.

# Head must be attached so that the next commit will be referenced by the branch label.
git checkout $timeline

# stage all changes
git add -A .

# commit changes
git commit -m "$(date)"

# then do the same in reverse
git checkout --detach
git reset --soft $currentBranch
git checkout $currentBranch
mv .git/index.$currentCommit .git/index
}

if test -n "$currentBranch" -a "$currentBranch" != "$timeline"; then
  backup_branch
fi
