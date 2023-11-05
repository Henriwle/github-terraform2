In this terraform project, a working CI/CD is implemented through github actions.

To update the infrastructure one needs to push the update to a new branch/a branch that is not dev or prod. The code will be formatted and tested automatically by the use of terraform fmt (which formats the code), terraform validate (which validates the code), and tfsec (which looks for security threats in the infrastructure).

The next step is to send a pull request frm the dev branch to the new branch. This will start another workflow. This workflow runs all the same formatting and tests.

The next step is to send a pull request from the prod branch to the dev branch. This will start the final workflow. This workflow runs all the same formatting and tests, as well as set up the infrastructure in portal.azure with workspace specific names. It will however not run the prod infrastructure before an admin has accepted this request in github. When this is accepted, the prod infrastructure will also be ran, and now all the infrastructure changes should be live.

The pre-requisites for this is that all secrets are configured in the github repo, in addition to the github actions having permission to merge branches, and the repo having an active personal access token for the project.