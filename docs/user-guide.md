
How to do stuff in the 1Hive DAO Template.

<br>

## Adding tokens to Metamask 🦊

Adding tokens to Metamask requires a few clicks. 
- open Metamask
- click on the left side menu button (it has 3 horizontal lines)
- scroll to the bottom of the window and click "Add Token"
- choose the Custom Token option
- enter the token contract address
- the other sections should autofill
- click Next
- click Add Token

You should see your tokens in Metamask!

<br>

## Voting 🗳️

Votes are how your community can use the DAO to make decisions. Voting can also be used to ask a question or get feedback from the group. In this section we'll explore how to do that using the voting app.

### Opening the Voting app

To open the voting app, open the DAO, click on the Voting app on the left side menubar, and select the voting app. This will display all the open and past votes for that token in the main window. 

### Creating a new signalling vote

To create a new vote, open the voting app and click on the New Vote button in the top right section of the main window. This will allow you to ask a yes/no question to the group. Type your question into the box, click begin question, click create transaction, and pay the tx fee to confirm it and add it to the DAO. People can then vote yay or nay on this question. This is useful for gathering sentiment on how the community feels about something, or to inform decisions that cannot be enforced via code. 

### Creating other types of votes

Many actions within the DAO require a vote. To see all the actions whos permissions are tied to the voting app, click on the Permissions app on the left sidebar, then click on each app to see the permissions. You'll see the permissions that have been set on the app under "Permissions set on this app".

To actually create a vote to do stuff with these apps you'll have to go to the app and select the action you want to take. This will create a vote, and once you confirm a tx to add it to the DAO, that action will be available for token holders to vote on. This is required for things like changing permissions in the org, reqesting tokens, and almost everything else.

<br>

## Requesting Permissions From Aragon Apps 🦅

To do things with Aragon DAOs you need permission. To get permision, either you have to build the DAO yourself and give yourself permission, or you have to request permission from the DAO. The 1Hive DAO makes decisions via voting, so in order to gain or lose permissions there needs to be a vote. This section will explain how to create a vote to give yourself permissions for a role, such as to become a [Reviewer](https://1hive.org/docs/contribute/projects-tasks.html#expectations-of-reviewers).

### Checking App Permissions

To see all the actions whos permissions are tied to the voting app, click on the Permissions app on the left sidebar, then click on each app to see the permissions. You'll see the permissions that have been set on the app under "Permissions set on this app".

### Requesting Permissions

To request permissions, first talk to the group about it on Keybase to explain the role you want to take on, why you think you're a good fit, and what permissions you'll need to do that (permissions associated with roles can be found in the [Roles and Responsibilities](roles-responsibilities.md) page). Then, once you have rough consensus from the group on your request, open the Permissions app and click New Permissions in the top right of the main window. This will ask you which app you'd like to set permissions for, who you'd like to give them to, and what action you'd like to set the permissions for. Any member of the group can create a vote to change permissions at any time, but most often a member will be requesting to give themselves permission to fulfill a role in the community. This means that in the "grant permissions to" section you'll choose "Custom Address..." and then add your address associated with the DAO. 

Once you configure the app, address, and action permission  you want click "add permission". Then once you pay the tx fee a vote will be created for the community to approve or deny. This ensures that all decisions are driven by the community, and hopefuly as a result, are the best for the community. 













