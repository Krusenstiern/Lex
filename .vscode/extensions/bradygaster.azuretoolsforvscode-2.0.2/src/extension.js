// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
var vscode = require('vscode');

// config and services
var fs = require('fs');
var path = require('path');
var appEvents = require('./appEvents');
var constants = require('./constants').Constants;

// state used in the extension
var state = {
    credentials: null,
    accessToken: null,
    subscriptions: null,
    subscriptionIds: [],
    subscriptionNames: [],
    selectedSubscriptionId: null,
    resourceGroupList: [],
    resourceGroupToUse: null,
    serverFarmList: [],
    selectedServerFarm: null,
    entireResourceList: [],
    keyVaultName: null,
    keyVaultRegions: [],
    batchAccountName: null,
    batchAccountRegions: [],
    newWebAppName: null,
    regions: [],
    selectedRegion: 'West US',
    storageAccountList: [],
    selectedStorageAccount: null,
    storageAccountKeyList: [],
    AzureGalleryList: [],
    AzureGalleryItemId: null,
    AzureGallerySearchTerm: null,
    AzureGallerySearchResults: [],
    SelectedTemplateFile: null,
    SelectedTemplateParametersFile: null
};

function activate(context) {
    appEvents.setContext(context);

    var commandFilesPath = path.join(context.extensionPath, 'src', 'commands');
    fs.readdir(commandFilesPath, (err, files) => {
        files.forEach((file) => {
            if(file.endsWith('.js')) {
                context.subscriptions.push(
                    require('./commands/' + path.basename(file, '.js')).createCommand(state)
                );
            }
        });
    });

    var contentPath = path.join(context.extensionPath, "content", "index.md");
    vscode.workspace.openTextDocument(contentPath).then(
        onfulfilled = (theDoc) => {
            console.log(theDoc);
            vscode.window.showTextDocument(theDoc).then(
                onfulfilled = (theEditor) => {
                    vscode.commands.executeCommand('markdown.showPreview');
                    fs.rename(contentPath, contentPath.replace('.md','.md.old'));
                });
        },
        onrejected = (value) => {
            // file was deleted, so we have nothing to do
        }
    );

    console.log('opened ' + contentPath);
}

exports.activate = activate;

function deactivate() {
}

exports.deactivate = deactivate;