# Git on Cloud9

Your Cloud9 instance already has git installed and the GRC (Git-Remote-Codecommit) helper. That makes it really easy to use git with no passwords or SSH keys! (You will use authenticate via IAM)

As a trainer, you can get 90% of the value of git (version control) with just a few simple git commands.

As trainers, we can use git to:

1. Make sure we have a "saved" copy of our work
2. Have a history of changes we made - in case we mess up.
3. We can easily work across multiple machines (cloud9, ec2, and local) and merge our work in a reasonable way.

# To Initialize a Git Repo (Local and Remote)

First, create a Git repo via CodeCommit
```
aws codecommit create-repository --repository-name "my-coreks" --repository-description "My customized coreks files" --region us-west-2
```

Change directories into the Root of whatever you want to add to git.

Initialize the git repo. This creates a hidden folder named .git.  Git is what is known as a "distributed" version control system. You will have versions locally, but also remotely. 
```
git init -b main
```

Add all the files and commit (local)
```
git add . 
git status
git commit -am "first"
```

Define the "REMOTE" repo:
```
git remote add origin codecommit::us-west-2://my-coreks
git remote -v
```

For this first push (and only this first push):
```
git push --set-upstream origin main
```

(From this point forward you will just "git push")

# To make changes

Make changes to your files.

You can see your changes with:
```
git status
```
or 
```
git diff
```

If you add anything new (directory and/or files):
```
git add . 
```

When you want to "save" them remote:
```
git commit -am "some changes I made"
git push
```

(You don't have to push with every commit - but remember you aren't "saving" it off to the remote until you push)

# Git Clone

If you are on a new machine, or any other machine you can "clone" down your repo and work on it separately.  

```
git clone codecommit::us-west-2://my-coreks
```

You can now work on the files and git add, git commit, git push, etc. 

When you return to your other machine you should "git pull" to pull down the latest changes.

To get the latest files from the repo:
```
git pull
```

(git will try and "merge" any file changes together - in some cases it'll need your help figuring out the merge)

# Doing more with git

Git is hugely powerful (and complicated)

Of course there is much, much more you can do with it.  Consult the documetation or a good git tutorial.

We're using it here as a "personal version control system" - so we don't have to worry about multiple branches, pull requests, etc. 
