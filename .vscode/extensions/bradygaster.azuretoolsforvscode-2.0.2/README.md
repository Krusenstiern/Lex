# Azure Tools for Visual Studio Code

This extension for [Visual Studio Code](http://code.visualstudio.com) gives Azure developers some convenient commands for creating or accessing resources directly in the editor. 

## V2.0.0 - Updates and Sunset Announcement

V2 of the Azure Tools removes Azure App Service, Azure Functions, and Azure Storage features, as those features are better represented in official extensions that provide great support for these service areas. 

To mitigate the loss of features that have been deprecated from this extension in V2, we've taken a dependency on the official extensions that support the features previously provided by this extension. 

* [Azure App Service](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)
* [Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)
* [Azure Storage](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurestorage)

Read more about the history of this deprecation and future plans [here](http://www.bradygaster.com/posts/azure-tools-for-vs-code-2-0-0). As of 2.0.2, the main features of this extension have been deprecated in lieu of the official extensions for App Service, Cosmos DB, and so on. 

**This extension will receive no more updates or features.**

---

## Azure Resource Manager (Azure RM) Features
You can use keyword searches to find one of the numerous existing templates in the Azure QuickStart Templates repository, then download the templates you find and deploy them **all within Visual Studio Code**. 

### Search and Download from the Azure Template QuickStart Repository
Templates in the QuickStart repository are easily searchable from within Visual Studio Code. 

![Search for templates](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_129.png)

Type in a string or combination of strings for which you're searching:

![Search for templates](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_131.png)

Select the appropriate template from the resulting list:

![Select your template](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_132.png)

Note that the templates you select are downloaded into the `arm-templates` folder in your workspace. This way you can open the parameters file, make changes, and customize your deployment. 

![Downloaded templates](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_133.png)

Now that the Azure Tools for Visual Studio Code takes a dependency on the Azure Resource Manager Tools for Visual Studio Code, editing of Azure RM templates you download from the repository is easier due to auto-completion, IntelliSense support, and the other Azure RM editing features provided in the Azure Resource Manager Tools extension. 

### Deploying Templates
Once you've edited your ARM template you can even use Visual Studio Code to deploy the template and add your Azure resources to your subscription. The *Deploy* command is visible in the command list below.

![Deploy command](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_134.png)

The various Azure RM templates you may have downloaded into your workspace will be shown in a list. This way, if you have multiple resources you wish to deploy in phases or you're just testing various templates out, you can deploy them individually. 

![Select the template to be deployed](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_135.png)

Deployments can be made to new or existing resource groups:

![Create new resource group](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_137.png)

The status bar shows that the deployment being created: 

![Deployment happening](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_140.png)

In this template scenario a GitHub-backed Web App is created. The portal screenshot below shows how the site is being deployed from GitHub once the template is deployed. 

![Portal view](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_141.png)

Finally, Visual Studio Code provides an update when the deployment has completed. 

![Deployment complete](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_142.png)

### Export Azure Resource Manager Template

In 1.2.0 we've added support for exporting existing resource groups to ARM templates saved in your workspace. First, you invoke the `Export` command using the palette. 

![Export command](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_162.png)

Then you select an existing resource group. 

![Select a resource group](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_163.png)

A few seconds later, the resource group's contents are downloaded as an Azure RM template and stored into your current workspace's `arm-templates` folder. 

![Export command](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_164.png)

## Output window messages

To address the perceived lack of action in the UX during execution we've added a custom **Debug Console** window that shows the progress of commands executed by the extension. The information in the output window will help customers have more information for error reporting. 

![Export command](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/output-window-updates.png)

### Azure Key Vault creation

You can now use the Azure Tools for Visual Studio Code to create new Key Vault instances. Selecting the **Create Key Vault** command. Then you can create a new or select an existing resource group into which your new Key Vault will be created. 

![Create Key Vault](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_150.png)

### Azure Batch account creation

From within Visual Studio Code you can use the `Create Azure Batch` command from the palette, shown below, to create new Azure Batch accounts. Future releases may add support for scripting against your Batch account, creating Jobs, and so forth. Feel free to send the team requests for additional Batch features via our [GitHub Issues page](https://github.com/bradygaster/azure-tools-vscode/issues).

![Create Key Vault](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/Screenshot_161.png)

## Getting Started
Once you've installed the extension you can log in using either your organizational account or a Microsoft account such as a @live.com address. If you need to log in using an "organizationa account" there is no setup work to be done. Simply pull up the command palette and look for the **Azure: Login** command. This command runs the web-based interactive login process. 

![Login Command](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/login.png)

### Logging in with a Microsoft Account?
If you're logging in using a Microsoft account (such as a @hotmail.com, @live.com, or @outlook.com account) you will need to set the `azure.tenantId` setting. The screenshot below shows this setting being entered using the *File -> Preferences -> User Settings* feature.

![Adding the Azure tenant ID setting](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/azure-tenant-id-setting.png)

Once you've added the GUID-based setting (available Active Directory area in the [classic portal](https://manage.windowsazure.com) to the user or workspace settings using the `azure.tenantId` setting you can login using your Microsoft Account. The animated gif below demonstrates the full process of logging in using an MSA. 

![Signing in using an MSA](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/sign-in-msa.gif)

## Browsing Resources in the Azure Portal
Two commands are provided to enable easy access to your Azure resources in the portal. By opening the command palette and typing **Browse** you will see the convenient "Browse in Portal" options. 

![Browse Commands](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/browseCommands.png)

You can navigate directly to an individual resource's portal page:

![Select a resource](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/resources.png)

Or to a resource group's portal page:

![Select a resource group](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/resourceGroups.png)

## Extension Settings

|Setting|Description|
|-|-|
|`azure.tenantId`| The GUID specifier for the tenant you intend on authenticating against. This is *required* if you're attempting to log in using a Microsoft Account like @outlook.com, @hotmail.com, or @live.com. |
|`azure.showToolsWindowOnStartup`|To prevent the Azure Tools panel showing on startup set this to false. Default is true|

By default the Azure Tools output window is opened on startup. If you prefer that it isn't opened on startup then you can change the `azure.showToolsWindowOnStartup` setting to false:

![Disable tools window on startup](https://github.com/bradygmsft/azure-tools-vscode/raw/master/media/docs/azure.showToolsWindowOnStartup.gif)

## Requirements

All dependencies are listed in [package.json](https://github.com/bradygmsft/azure-tools-vscode/blob/master/package.json). You will need an Azure subscription. If you don't yet have an Azure subscription [sign up for a free account](https://azure.microsoft.com/en-us/free/) and then you can make use of the features in this extension, not to mention all the great features Azure offers. 

## Known Issues

All feature ideas and issues should be reported using [GitHub issues](https://github.com/bradygaster/azure-tools-vscode/issues).

## Release Notes

You can find notes for each release in the [changelog](https://github.com/bradygmsft/azure-tools-vscode/blob/master/changelog.md).