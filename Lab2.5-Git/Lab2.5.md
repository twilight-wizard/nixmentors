Intro to Git and Github
=======================

## Why Version Control?

- Keeping old versions of your work in case new changes break old work
- Collaboration
- Remote backups

Why Git?
--------

<!---
Largely based on http://thkoch2001.github.io/whygitisbetter
-->
- Git allows for local development, which means less network overhead
- Git is fast, partly because of the lack of network overhead and partly because of its snapshotting design
- Git is distributed: every client copy is a full backup of the server copy
- Git is versatile
- Git is the standard

Initial Setup
-------------

- Tell git who you are. Why this is important will become clear later.

        $ git config --global user.name "Full Name"
        $ git config --global user.email "email@email.org"
        $

- Tell git what editor you use

        $ git config --global core.editor vim
        $

- It's possible you will like the default editor and you won't have to change this. Check with:

        $ git config core.editor
        vim
        $

- Tell Git that you want colors enabled!

        $ git config --global color.ui always
        $

- Take a look at your handywork:

        $ less ~/.gitconfig

- You can edit this file directly if you prefer.

The Basics: a Local Repository
------------------------------

- git init

        $ mkdir myproject
        $ cd myproject
        $ git init
        Initialized empty Git repository in /home/krinkle/myproject/.git/
        $

- Check on your status (initially empty)

        $ git status
        # On branch master
        #
        # Initial commit
        #
        nothing to commit (create/copy files and use "git add" to track)
        $

- Make some files

        $ echo "My first file" > newfile.txt
        $

- Check on your status

        $ git status
        # On branch master
        #
        # Initial commit
        #
        # Untracked files:
        #   (use "git add <file>..." to include in what will be committed)
        #
        # newfile.txt
        nothing added to commit but untracked files present (use "git add" to track)
        $

Stages of a file
----------------

- A file starts its life as an **Untracked file**.  
    We call it Untracked, but it is still kind of tracked in the sense that git knows it is has come into existence.  
    It just won't track changes in the contents of the file.

- We need to explicitly tell git that we care about this file, that we want to know what happens to it.  
    This happens when we add the file to the **staging area**.  
    The **staging area** is a snapshot of what we are going to commit when we are ready.

- A **commit** is a snapshot of the current point in history, marked by a message describing what was changed since the last commit
  and a SHA1 hash to distinguish it from other commits. These are the scrolls that we are going to study when we look back in time.

Add to the staging area
-----------------------

- Adding something to the staging area is like saving a temporary snapshot. We can continue to edit the file, and git will continue to track the changes since we last added the file to the staging area.

        $ git add newfile.txt
        $ git status
        # On branch master
        #
        # Initial commit
        #
        # Changes to be committed:
        #   (use "git rm --cached <file>..." to unstage)
        #
        # new file:   newfile.txt
        #
        $

- You can keep adding files to the staging area until you are ready to make a commit.

Committing
----------

- Now is the time to make history. Making a commit will copy the snapshot currently in your staging area and mark it with a descriptive message and an identifying hash.

        $ git commit

- This command will open the editor you set in the beginning of the workshop. Write a descriptive message. Your message can span multiple lines, but if you have a multiple-line commit message the first line needs to be separated from the rest by an empty line. This is a kind of subject / message format.
- If you don't want to use an editor you can make a commit message via the command line. This only supports one-line commits.

        $ git commit -m "Descriptive message"
        [master (root-commit) f2240c8] Descriptive message
         1 file changed, 1 insertion(+)
         create mode 100644 newfile.txt
        $ git status
        # On branch master
        nothing to commit, working directory clean
        $

Reviewing History
-----------------

    $ git log
    commit f2240c81da50f348bf6523c46134ac3f4ca7a062
    Author: Colleen Murphy <cmurphy@cat.pdx.edu>
    Date:   Fri Apr 11 14:37:02 2014 -0700

        Descriptive message
    $

Getting the Rhythm
------------------

- This is the pattern for how most of your git career will go. Get comfortable with it. (The `git status` isn't necessarily part of the pattern but it is good to follow what is going on for the moment).

        $ # edit newfile.txt
        $ git status
        $ git add newfile.txt
        $ git status
        $ git commit
        $ git status

Seeing the differences
----------------------

- If you are unsure what changes you made at any point in time, you can see them:

        $ git diff                     # Tracked files that have been modified but not staged
        $ git diff --cached            # Files in the staging area
        $ git log -p                   # Changes throughout your commit history

Other ways to put changes in the staging area
---------------------------------------------

    $ git rm newfile.txt                              # Remove the file
    $ git mv newfile.txt reallynewfile.txt            # Rename the file

Branching
---------

- One of git's best features is the way it handles branching. Branching allows you diverge from your main project to work on a feature or bug without altering the main project. When your feature or bugfix is ready, you can merge your work into the main project.
- View your current branch

        $ git branch
        * master
        $

- You start out on a branch called master. This is analogous to trunk in SVN.
- Create a new branch

        $ git branch testing
        $ git branch
        * master
          testing
        $

### Switching branches

    $ git checkout testing
    Switched to branch 'testing'
    $ git branch
      master
    * testing
    $

- Realistically, whenever we want to create a new branch, we also want to immediately start work on it. We can shortcut the steps shown previously with

        $ git checkout -b testing
        Switched to a new branch 'testing'
        $

- Feel the rhythm

        $ echo "testing" > testfile.txt
        $ git add testfile.txt
        $ git commit

- Check on your history in your testing

        $ git log

- Switch back to your original branch

        $ git checkout master
        Switched to branch 'master'
        $

- View the history of the orinal branch. How many commits do you have?

- List the files in your current directory with `ls`. Is testfile.txt there?

- Switch back to your testing branch. Make sure testfile.txt is there.

Merging
-------

- If you are satisfied with the changes you made to your testing branch. it's time to merge them into master

        $ git checkout master
        Switched to branch 'master'
        $ git merge testing
        Updating f2240c8..3addaec
        Fast-forward
         testfile.txt | 1 +
          1 file changed, 1 insertion(+)
           create mode 100644 testfile.txt
        $ git log
        commit 3addaec5086875e1a59d1b98e4f9e334bc0828e5
        Author: Colleen Murphy <cmurphy@cat.pdx.edu>
        Date:   Fri Apr 11 16:26:03 2014 -0700

           testing

        commit f2240c81da50f348bf6523c46134ac3f4ca7a062
        Author: Colleen Murphy <cmurphy@cat.pdx.edu>
        Date:   Fri Apr 11 14:37:02 2014 -0700

           Descriptive message

Intro to Github
---------------

- Visit github.com and create an account.
- Click the '+' in the upper right corner. Click Create New Repository from that dropdown.
- Give it a name and a description. Don't click the "Initialize this repository with a README" checkbox.
- Follow the instructions to "Push an existing repository from the command line"

Remotes
-------

- A remote is a foreign location. This will be the identifier for your remote repository.

        $ git remote add origin git@github.com/cmurphy/myproject.git
        $ git remote -v
        origin  git@github.com:cmurphy/test.git (fetch)
        origin  git@github.com:cmurphy/test.git (push)
        $

- Listing your remotes will give you two URLs, one to get data from and one to push data to. By default these are the same.
- It is common to name your main remote 'origin' but this is not required.

Pushing to Github
-----------------

- Pushing means copying your local repository over to a remote one.

        $ git push -u origin master

- origin is your remote repository. master is the branch you want to push.
- -u tells git to set this origin as upstream, which means in the future you can just say "git push"

Working with an existing project
--------------------------------

- Often you will want to contribute to a project that is already on Github. If you are a registered **contributor**
  to the project. you will be able to make changes directly to the repository. Otherwise, you will have to **fork**
  the repository and ask the maintainers to merge your changes. This is called making a **pull request**.
- Visit [https://github.com/pdxcat/nixmentors]. Click the button in the upper right labeled "Fork".
- Notice the namespace changes from pdxcat to your username.
- This fork will NOT automatically update when **upstream** (the pdxcat version) changes. You need to keep it updated yourself.

Pull Requesting
---------------

- Get a copy of your forked repository. There should be a "clone URL" on the right side of the page. Copy the HTTPS version if you have not added
  SSH keys to Github yet. You can use the SSH version if you have uploaded SSH keys. The Subversion button doesn't exist.

        $ git clone https://github.com/cmurphy/nixmentors.git
        Cloning into 'nixmentors'...
        remote: Reusing existing pack: 495, done.
        remote: Counting objects: 12, done.
        remote: Compressing objects: 100% (9/9), done.
        remote: Total 507 (delta 4), reused 0 (delta 0)
        Receiving objects: 100% (507/507), 118.02 KiB, done.
        Resolving deltas: 100% (234/234), done.
        $ cd nixmentors
        $ ls

- Set the original repository as "upstream" so you can keep your copy up-to-date

        $ git remote add upstream https://github.com/pdxcat/nixmentors.git
        $ git remote -v
        origin  https://github.com/cmurphy/nixmentors.git (fetch)
        origin  https://github.com/cmurphy/nixmentors.git (push)
        upstream  https://github.com/pdxcat/nixmentors.git (fetch)
        upstream  https://github.com/pdxcat/nixmentors.git (push)
        $ 

- Any time you are going to work on new changes, you should pull from upstream before you start your work. This will help reduce merge conflicts later.

        $ git pull upstream master

- Often we checkout a new branch to make it clear what we're working on, but you can also do you work on master.

        $ git checkout -b fix_lab2
        $ # Make changes
        $ # git add changes
        $ # git commit changes with descriptive message
        $ git push origin fix_lab2

- Now use the Github UI to ask for your changes to be merged.
  - Your fork should now have a "Compare & pull request" button. Click it.
  - Write a comment about your change. You should include what the change is, and any documented issues/bugs that this change addresses.
  - Pay attention to the note on the right side of the comment section. If your branch is not able to merge cleanly, the maintainer will likely ask you to fix your conflicts.
  - Click the "Send pull request" button.
  - If/when the maintainer accepts your pull request, you will need to update your master branch by pulling from upstream again before you start more work.

<!--
Other things to cover:

Working with an existing project
git rebase
git blame
setting upstream
git cherry-pick

making mistakes
git reset
git checkout
git revert
git commit -amend
git reflog

git/github ettiquette
- good commit messages
- small commits
- changing history
- working with maintainers/contributors
    https://gist.github.com/uppfinnarn/9956023
- always include a README, preferably using markdown
- software should have a license

Advanced/miscellaneous
.gitignore
customization
additional git commands (git-thing in path)
ssh keys
git grep

git help <command>
man git-command

--->
For an excellent reference:
---------------------------

Try [http://git-scm.com/book]
