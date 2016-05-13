How to create a new Repo:

1. change the current working directory to your target directory where you will save your local project
2. Initialize the local directory as a Git repo $git init
3. Add files in the local repo and stage them for commit $ git add.   $ git commit -m "message"
4. Set the new remote $ git remote add origin github-url
5. Verify the new remote github-url $git remote -v
6. Push the changes in your local repo to Github the remote repo where you specified as the origin $git push oigin master





wants <- c("GPArotation", "mvtnorm", "polycor", "psych")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
 
