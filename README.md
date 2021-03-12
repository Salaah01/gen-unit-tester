# Generic CI/CD (In Progress)
A generic to help build a project, test and move onto a staging area.
The tool will do the following by default:

1. Clone your repository (you would need to configure the access).
2. Run a set up of pre-test commands. Examples of this include:
  * `pip install -r requirements.txt`.
  * `npm install`
  * `npm run build`
3. Runs your unit tests and fails the build if any of the tests fail.
4. Checks out your staging branch or any other branch you define and merges the feature branch.

## Use Cases
This can be used, an fact is inspired by GitHub's dependabot. To help manage
the number of pull requests it was creating, I created a Jenkins job that would
rebuild my application and follow the stages mentioned about with each changes
suggested by dependabot. If everything passed, the branch would be merged into
my `dependenciesUpdate` branch on which I would run separate tests before
promoting to production.


# Setup
1. (Optional) Modify `docker-compose.yml` to add any other packages you many want to install.
