# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)


### Key Directories and Files

- **config/**: Contains project configuration files, including the scratch org definition.
- **data/**: Contains sample data files for importing into Salesforce orgs.
- **force-app/**: Contains the main source code for the Salesforce application.

## How to Get Started

1. **Clone the repository**:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Install dependencies**:
    ```sh
    npm install
    ```

3. **Authorize an Org**:
    ```sh
    sfdx auth:web:login -a <alias>
    ```

4. **Create a Scratch Org**:
    ```sh
    sfdx force:org:create -s -f config/project-scratch-def.json -a <scratch-org-alias>
    ```

5. **Push source to Scratch Org**:
    ```sh
    sfdx force:source:push -u <scratch-org-alias>
    ```

6. **Assign a Permission Set**:
    ```sh
    sfdx force:user:permset:assign -n <permset-name> -u <scratch-org-alias>
    ```

7. **Open the Scratch Org**:
    ```sh
    sfdx force:org:open -u <scratch-org-alias>
    ```

## Data Import

To import sample data, use the following commands:

```sh
sfdx force:data:tree:import -p data/Venue__c-Event__c-plan.json -u <scratch-org-alias>