var vscode = require('vscode');
var ux = require('../ux');
var open = require('open');
var commandName = 'azure.browse-resourceGroup';
var templateResourceGroupUrl = 'https://portal.azure.com/#resource/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/overview';

exports.createCommand = function createCommand(state) {
    vscode.commands.registerCommand(commandName, function () {
        ux.isLoggedIn(state)
            .then(() => {
                ux.getResourceGroups(state)
                    .then(() => {
                        ux.showResourceGroupsMenu(state, () => {
                            open(templateResourceGroupUrl
                                .replace('{subscriptionId}', state.selectedSubscriptionId)
                                .replace('{resourceGroup}', state.resourceGroupToUse)
                            );
                        });
                    });
            });
    });
};