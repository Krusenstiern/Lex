var vscode = require('vscode');
var config = require('./config');
var constants = require('./constants').Constants;
var azure = require('./azure');
var path = require('path');
var fs = require('fs');
var fsPath = require('fs-path');
var menu = require('./menu').menu;
var outputChannel = require('./outputChannel').createChannel();

// perform the export template feature
exports.exportTemplate = function exportTemplate(state) {
    var promptTemplateExportedWithErrors = 'Resource group {0} has been exported with errors. Check the template for completeness.',
        promptTemplateExported = 'Resource group {0} has been exported to your workspace\'s arm-templates folder';

    this.getResourceGroups(state)
        .then(function () {
            vscode.window.showQuickPick(state.resourceGroupList)
                .then(function (selectedRg) {
                    if (!selectedRg) reject();
                    state.resourceGroupToUse = selectedRg;
                    outputChannel.appendLine('Exporting template...');
                    azure.exportTemplate(state)
                        .then((result) => {
                            var json = JSON.stringify(result.template);
                            var filename = path.join(vscode.workspace.rootPath, constants.armTemplatesPath, state.resourceGroupToUse, 'azuredeploy.json');
                            fsPath.writeFile(filename, json, (err) => {
                                if (result.error) {
                                    outputChannel.appendLine('Error during template export:');
                                    outputChannel.appendLine(JSON.stringify(result.error));
                                    vscode.window.showErrorMessage(promptTemplateExportedWithErrors.replace('{0}', state.resourceGroupToUse));
                                }
                                else {
                                    outputChannel.appendLine('Template exported successfully.');
                                    vscode.window.showInformationMessage(promptTemplateExported.replace('{0}', state.resourceGroupToUse));
                                }
                                vscode.workspace.openTextDocument(filename)
                                    .then(prms => {
                                        vscode.window.showTextDocument(prms);
                                    });
                            });
                        })
                        .catch((err) => {
                            outputChannel.appendLine('Error during template export:');
                            outputChannel.appendLine(JSON.stringify(err));
                        });
                });
        })
        .catch(function (err) {
            vscode.window.showErrorMessage(err);
        });
};

// check to see if the user is logged in
exports.isLoggedIn = function isLoggedIn(state) {
    var promptNotLoggedIn = 'You have not yet logged in. Run the Azure Login command first.';

    return new Promise((resolve, reject) => {
        if (state && state.credentials && state.accessToken && (state.subscriptions && state.subscriptions.length > 0)) {
            resolve();
        }
        else {
            vscode.window.showErrorMessage(promptNotLoggedIn);
        }
    });
};
exports.isFolderOpen = function isFolderOpen() {
    var promptNoRootFolder = 'You do not currently have a folder open in the workspace. Please open a folder first.';

    return new Promise((resolve, reject) => {
        if (vscode.workspace.rootPath !== undefined) {
            resolve();
        }
        else {
            vscode.window.showErrorMessage(promptNoRootFolder);
        }
    });
}

// deploys arm template
exports.deployTemplate = function deployTemplate(state) {
    var promptDeployingTemplate = 'Deploying template {0} to resource group {1}',
        promptDeployingTemplateFailed = 'FAILED to deploy template {0} to resource group {1}';

    state.statusBar = vscode.window.setStatusBarMessage(promptDeployingTemplate
        .replace('{0}', state.selectedTemplateName)
        .replace('{1}', state.resourceGroupToUse));

    outputChannel.appendLine(promptDeployingTemplate
        .replace('{0}', state.selectedTemplateName)
        .replace('{1}', state.resourceGroupToUse));

    azure.deployTemplate(state)
        .then((msg) => {
            outputChannel.appendLine('Template deployed with messages from API:');
            outputChannel.appendLine(msg);
            state.statusBar.dispose();
        })
        .catch((err) => {
            outputChannel.appendLine(promptDeployingTemplateFailed
                .replace('{0}', state.selectedTemplateName)
                .replace('{1}', state.resourceGroupToUse));
            outputChannel.appendLine(err);
            vscode.window.showErrorMessage(promptDeployingTemplateFailed
                .replace('{0}', state.selectedTemplateName)
                .replace('{1}', state.resourceGroupToUse));
            state.statusBar.dispose();
        });
};

// get the list of resource groups from the subscription
exports.getResourceGroups = function getResourceGroups(state) {
    return new Promise(function (resolve, reject) {
        outputChannel.appendLine('Getting resource groups.');
        azure
            .getResourceGroups(state)
            .then(function (result) {
                outputChannel.appendLine('Found ' + result.length + ' resource groups.');
                result.forEach(function (rg) {
                    state.resourceGroupList.push(rg.name);
                });
                resolve();
            })
            .catch(function (err) {
                outputChannel.appendLine('Error retrieving resource groups:');
                outputChannel.appendLine(err);
                reject(err);
            });
    });
};

// wrapper method for handling "new or existing resource group" workflows
exports.showNewOrExistingResourceGroupMenu = function showNewOrExistingResourceGroupMenu(state) {
    return new Promise((resolve, reject) => {
        vscode.window.showQuickPick([
            constants.optionExistingRg,
            constants.optionNewRg
        ]).then(selected => {
            if (selected == constants.optionExistingRg) {
                this.getResourceGroups(state)
                    .then(function () {
                        vscode.window.showQuickPick(state.resourceGroupList)
                            .then(function (selectedRg) {
                                if (!selectedRg) reject();
                                state.resourceGroupToUse = selectedRg;
                                resolve();
                            });
                    })
                    .catch(function (err) {
                        vscode.window.showErrorMessage(err);
                    });
            }
            else if (selected == constants.optionNewRg) {
                vscode.window.showInputBox({
                    prompt: constants.promptNewRgName
                }).then(function (newResourceGroupName) {
                    if (!newResourceGroupName || newResourceGroupName === "") reject();
                    state.resourceGroupToUse = newResourceGroupName;
                    azure.createNewResourceGroup(state).then(() => {
                        resolve();
                    });
                });
            }
        });
    });
};

// check the key vault name is available
exports.ifKeyVaultNameIsAvailable = function ifKeyVaultNameIsAvailable(state) {
    var promptKeyVaultNameNotAvailable = 'That key vault name is not available';
    return new Promise(function (resolve, reject) {
        outputChannel.appendLine('Checking to see if Key Vault name "' + state.keyVaultName + '" is available.');
        azure
            .checkKeyVaultNameAvailability(state)
            .then(function (result) {
                if (!result) {
                    outputChannel.appendLine(promptKeyVaultNameNotAvailable);
                    reject(promptKeyVaultNameNotAvailable);
                }
                else {
                    outputChannel.appendLine('The key vault name is available.');
                    resolve();
                }
            });
    });
}

// check the batch account name is available
exports.ifBatchAccountNameIsAvailable = function ifBatchAccountNameIsAvailable(state) {
    var promptBatchAccountNameNotAvailable = 'The batch account name is not available.';
    return new Promise(function (resolve, reject) {
        outputChannel.appendLine('Checking Batch account name availability...');
        azure
            .checkBatchAccountNameAvailability(state)
            .then(function (result) {
                if (!result) {
                    outputChannel.appendLine(promptBatchAccountNameNotAvailable);
                    reject(promptBatchAccountNameNotAvailable);
                }
                else {
                    outputChannel.appendLine('Batch account name ' + state.batchAccountName + ' is available.');
                    resolve();
                }
            });
    });
}

// gets all of the resources
exports.getAzureResources = function getAzureResources(state) {
    var statusGettingResources = 'Getting your list of resources';

    return new Promise((function (resolve, reject) {
        var statusBar = vscode.window.setStatusBarMessage(statusGettingResources);
        outputChannel.appendLine(statusGettingResources);
        azure
            .getFullResourceList(state)
            .then(function (names) {
                statusBar.dispose();
                outputChannel.appendLine('Azure resources obtained.');
                resolve(names);
            })
            .catch(function (err) {
                outputChannel.appendLine('Error while getting Azure resource list:');
                outputChannel.appendLine(err);
                reject(err);
            });
    }));
};

// creates a new key vault
exports.createKeyVault = function createKeyVault(state, callback) {
    var statusCreatingKeyVault = 'Creating key vault "{0}"',
        statusCreatedKeyVault = 'Key vault "{0}" created successfully';

    vscode.window.setStatusBarMessage(statusCreatingKeyVault.replace('{0}', state.keyVaultName));
    outputChannel.appendLine(statusCreatingKeyVault.replace('{0}', state.keyVaultName));

    azure
        .createNewKeyVault(state)
        .then(function (result) {
            outputChannel.appendLine(statusCreatedKeyVault.replace('{0}', state.keyVaultName));
            vscode.window.setStatusBarMessage(statusCreatedKeyVault.replace('{0}', state.keyVaultName));
            if (callback)
                callback();
        })
        .catch(function (err) {
            outputChannel.appendLine('Error during key vault creation:');
            outputChannel.appendLine(err);
            vscode.window.showErrorMessage(err);
        });
}

exports.createBatchAccount = function createBatchAccount(state, callback) {
    var statusCreatingBatchAccount = 'Creating batch account {0}',
        statusCreatedBatchAccount = 'Batch account {0} created successfully';

    vscode.window.setStatusBarMessage(statusCreatingBatchAccount.replace('{0}', state.batchAccountName));
    outputChannel.appendLine(statusCreatingBatchAccount.replace('{0}', state.batchAccountName));
    azure
        .createNewBatchAccount(state)
        .then(function (result) {
            outputChannel.appendLine(statusCreatedBatchAccount.replace('{0}', state.batchAccountName));
            vscode.window.setStatusBarMessage(statusCreatedBatchAccount.replace('{0}', state.batchAccountName));
            if (callback)
                callback();
        })
        .catch(function (err) {
            outputChannel.appendLine('Error during Batch account creation:');
            outputChannel.appendLine(err);
            vscode.window.showErrorMessage(err);
        });
}

// method to create the resource group
exports.createResourceGroup = function createResourceGroup(state, callback) {
    var statusCreatingResourceGroup = 'Creating resource group "{0}"',
        statusCreatedResourceGroup = 'Resource group "{0}" created successfully';

    vscode.window.setStatusBarMessage(statusCreatingResourceGroup.replace('{0}', state.resourceGroupToUse));
    outputChannel.appendLine(statusCreatingResourceGroup.replace('{0}', state.resourceGroupToUse));

    azure
        .createNewResourceGroup(state)
        .then(function (result) {
            vscode.window.setStatusBarMessage(statusCreatedResourceGroup.replace('{0}', state.resourceGroupToUse));
            outputChannel.appendLine(statusCreatedResourceGroup.replace('{0}', state.resourceGroupToUse));
            if (callback)
                callback();
        })
        .catch(function (err) {
            outputChannel.appendLine('Error during resource group creation:');
            outputChannel.appendLine(err);
            vscode.window.showErrorMessage(err);
        });
}

exports.getRegions = function getRegions(state) {
    return new Promise(function (resolve, reject) {
        azure
            .getRegions(state)
            .then(function (result) {
                state.regions = result;
                if (!state.selectedRegion) {
                    state.selectedRegion = state.regions[0].displayName;
                    outputChannel.appendLine(state.selectedRegion + ' was auto-selected as the active region.');
                }
                resolve();
            })
            .catch(function (err) {
                vscode.window.showErrorMessage(err);
            });
    });
};

exports.getRegionsForResource = function getRegionsForResource(state, resourceProvider, resourceType) {
    return new Promise(function (resolve, reject) {
        outputChannel.appendLine('Getting regions that support resource type ' + resourceType + '.');
        azure
            .getRegionsForResource(state, resourceProvider, resourceType)
            .then(function (result) {
                outputChannel.appendLine('Supported regions retrieved.');
                resolve(result);
            })
            .catch(function (err) {
                outputChannel.appendLine('Error during region retrieval:');
                outputChannel.appendLine(err);
                vscode.window.showErrorMessage(err);
            });
    });
}

exports.showResourceGroupsMenu = function showResourceGroupsMenu(state, callback) {
    var statusResourceGroupSelected = '{0} resource group selected';

    var resourceGroupNames = state.resourceGroupList.map(function (x) { return x; });
    vscode.window.showQuickPick(resourceGroupNames).then(function (selected) {
        if (!selected) return;

        state.resourceGroupToUse = selected;
        vscode.window.setStatusBarMessage(statusResourceGroupSelected.replace('{0}', state.resourceGroupToUse));

        if (callback)
            callback();
    });
};

exports.showRegionMenu = function showRegionMenu(state) {
    var statusRegionSelected = '{0} region selected',
        btnRegionSelectionLabel = 'Select your desired Azure region. ';

    var regionNames = state.regions.map(function (x) { return x.displayName; });
    vscode.window.showQuickPick(regionNames).then(function (selected) {
        if (!selected) return;

        state.selectedRegion = selected;
        vscode.window.setStatusBarMessage(statusRegionSelected.replace('{0}', state.selectedRegion));
        menu.updateButtonTooltip('azure.region-select', btnRegionSelectionLabel + '('
            + statusRegionSelected.replace('{0}', state.selectedRegion) + ')');
        outputChannel.appendLine(statusRegionSelected.replace('{0}', state.selectedRegion));
    });
};

exports.showSubscriptionStatusBarButton = function showSubscriptionStatusBarButton() {
    menu.showButton('azure.subscription-select', '$(cloud-upload)', 'Select the active Azure subscription');
};

exports.showSelectRegionStatusBarButton = function showSelectRegionStatusBarButton() {
    menu.showButton('azure.region-select', '$(globe)', 'Select your desired Azure region');
};