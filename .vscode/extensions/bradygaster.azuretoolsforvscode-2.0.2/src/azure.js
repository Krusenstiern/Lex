var msRestAzure = require('ms-rest-azure');
var KeyVaultManagement = require('azure-arm-keyvault');
var ResourceManagement = require('azure-arm-resource');
var BatchManagement = require('azure-arm-batch');
var DocumentDd = require('documentdb');
var SubscriptionClient = require('azure-arm-resource').SubscriptionClient;
var fs = require('fs');
var config = require('./config');

exports.exportTemplate = function exportTemplate(state) {
    return new Promise((resolve, reject) => {

        var resourceClient = new ResourceManagement.ResourceManagementClient(state.credentials, state.selectedSubscriptionId);
        resourceClient.resourceGroups.exportTemplate(state.resourceGroupToUse, {
            resources: ["*"],
            options: "IncludeParameterDefaultValue"
        }, (err, result, request, response) => {
            if (err) {
                reject(err);
            }
            else {
                resolve(result);
            }
        });
    });
};

exports.deployTemplate = function deployTemplate(state) {
    var promptDeployingTemplateCompleted = 'Template {0} deployment to resource group {1} completed with status of {2}';

    return new Promise((resolve, reject) => {
        var resourceGroupName = state.resourceGroupToUse;
        var deploymentName = state.resourceGroupToUse + '-' + new Date().getTime();
        var templateFile = fs.readFileSync(state.SelectedTemplateFile);
        var templateParametersFile = fs.readFileSync(state.SelectedTemplateParametersFile);
        var template = JSON.parse(templateFile);
        var templateParameters = JSON.parse(templateParametersFile);

        // handle v2 version of parameters file that has $schema
        if (templateParameters.parameters)
            templateParameters = templateParameters.parameters;

        var resourceClient = new ResourceManagement.ResourceManagementClient(state.credentials, state.selectedSubscriptionId);

        resourceClient.deployments.createOrUpdate(resourceGroupName,
            deploymentName,
            {
                properties: {
                    template: template,
                    parameters: templateParameters,
                    mode: 'Complete'
                }
            }, (err, result, request, response) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(promptDeployingTemplateCompleted
                        .replace('{0}', state.selectedTemplateName)
                        .replace('{1}', state.resourceGroupToUse)
                        .replace('{2}', result.properties.provisioningState));
                }
            });
    });
};

exports.createNewResourceGroup = function createNewResourceGroup(state) {
    return new Promise(function (resolve, reject) {
        var resourceClient = new ResourceManagement.ResourceManagementClient(state.credentials, state.selectedSubscriptionId);
        resourceClient.resourceGroups.createOrUpdate(state.resourceGroupToUse, {
            location: state.selectedRegion // todo: enable user selection
        }, function (err, result) {
            if (err != null) {
                reject(err);
            }
            else {
                resolve(result);
            }
        });
    });
};

exports.createNewKeyVault = function createNewKeyVault(state) {
    return new Promise(function (resolve, reject) {
        var keyVaultClient = new KeyVaultManagement(state.credentials, state.selectedSubscriptionId);
        var keyVaultParameters = {
            location : state.selectedRegion,
            properties : {
                sku : {
                    family : 'A',
                    name : 'standard'
                },
                accessPolicies : [],
                enabledForDeployment : false,
                tenantId: state.subscriptions.find(x => x.id === state.selectedSubscriptionId).tenantId
            },
            tags : {}
        };

        keyVaultClient.vaults.createOrUpdate(state.resourceGroupToUse, state.keyVaultName, keyVaultParameters, null,
            function (err, result) {
                if (err != null) {
                    reject(err);
                }
                else {
                    resolve(result);
                }
            });
    });
};

exports.createNewBatchAccount = function createNewBatchAccount(state) {
    return new Promise(function (resolve, reject) {
        var batchClient = new BatchManagement(state.credentials, state.selectedSubscriptionId);

        var batchAccountParameters = {
            location: state.selectedRegion,
            tags: {}
        }

        batchClient.batchAccountOperations.create(state.resourceGroupToUse, state.batchAccountName, batchAccountParameters, null,
            function (err, result) {
                if (err !== null) {
                    reject(err);
                }
                else {
                    resolve(result);
                }
            });
    });
};

exports.checkBatchAccountNameAvailability = function checkBatchAccountNameAvailability(state) {
    return new Promise(function (resolve, reject) {
        var batchClient = new BatchManagement(state.credentials, state.selectedSubscriptionId);
        batchClient.batchAccountOperations.get(state.resourceGroupToUse, state.batchAccountName, null,
            function (err, result) {
                if (err !== null) {
                    if (err.code === "ResourceNotFound") {
                        resolve(true);
                    }
                    else {
                        reject(err);
                    }
                }
                else {
                    resolve(false);
                }
            });
    });
};

exports.getResourceGroups = function getResourceGroups(state) {
    return new Promise(function (resolve, reject) {
        var resourceClient = new ResourceManagement.ResourceManagementClient(state.credentials, state.selectedSubscriptionId);
        state.resourceGroupList = [];
        resourceClient.resourceGroups.list(function (err, result) {
            if (err != null) {
                reject(err);
            }
            else {
                resolve(result);
            }
        })
    });
};

exports.checkKeyVaultNameAvailability = function checkKeyVaultNameAvailability(state) {
    return new Promise(function (resolve, reject) {
        var keyVaultManagement = new KeyVaultManagement(state.credentials, state.selectedSubscriptionId);
        keyVaultManagement.vaults.list(null,
            function (err, result) {
                if (err != null) {
                    reject(err);
                }
                else {
                    if (result.filter(e => e.name === state.keyVaultName).length > 0) {
                        resolve(false);
                    }
                    else {
                        resolve(true);
                    }
                }
            });
    });
};

exports.getFullResourceList = function getFullResourceList(state) {
    return new Promise(function (resolve, reject) {
        var resourceClient = new ResourceManagement.ResourceManagementClient(state.credentials, state.selectedSubscriptionId);
        resourceClient.resources.list(function (err, result) {
            if (err != null) {
                reject(err);
            }
            else {
                state.entireResourceList = result;
                names = state.entireResourceList.map(function (resource) {
                    return resource.id.replace('subscriptions/' + state.selectedSubscriptionId + '/resourceGroups/', '');
                });
                resolve(names);
            }
        });
    });
};

exports.getRegionsForResource = function getRegionsForResource(state, resourceProvider, resourceType) {
    return new Promise(function (resolve, reject) {
        var resourceClient = new ResourceManagement.ResourceManagementClient(state.credentials, state.selectedSubscriptionId);
        resourceClient.providers.list(function (err, result) {
            if (err != null) {
                reject(err);
            }
            else {
                resolve(result);
            }
        })
    });

}

exports.getRegions = function getRegions(state) {
    return new Promise(function (resolve, reject) {
        var subscriptionClient = new SubscriptionClient(state.credentials);
        subscriptionClient.subscriptions.listLocations(state.selectedSubscriptionId, function (err, result) {
            if (err != null)
                reject(err);
            else {
                resolve(result);
            }
        });
    });
};
