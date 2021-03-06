"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
// tslint:disable-next-line:no-any
if (Reflect.metadata === undefined) {
    // tslint:disable-next-line:no-require-imports no-var-requires
    require('reflect-metadata');
}
const inversify_1 = require("inversify");
const vscode = require("vscode");
const serviceRegistry_1 = require("./adapter/parsers/serviceRegistry");
const serviceRegistry_2 = require("./adapter/repository/serviceRegistry");
const serviceRegistry_3 = require("./adapter/serviceRegistry");
const serviceRegistry_4 = require("./application/serviceRegistry");
const commandManager_1 = require("./application/types/commandManager");
const disposableRegistry_1 = require("./application/types/disposableRegistry");
const serviceRegistry_5 = require("./commandFactories/serviceRegistry");
const serviceRegistry_6 = require("./commandHandlers/serviceRegistry");
// import * as fileHistory from './commands/fileHistory';
// import * as lineHistory from './commands/lineHistory';
// import { CommandRegister } from './commands/register';
// import * as searchHistory from './commands/searchHistory';
// import * as commitComparer from './commitCompare/main';
// import * as commitViewer from './commitViewer/main';
// import * as logViewer from './logViewer/logViewer';
const log_1 = require("./common/log");
const types_1 = require("./common/types");
const uiLogger_1 = require("./common/uiLogger");
const uiService_1 = require("./common/uiService");
const constants_1 = require("./constants");
const commitFormatter_1 = require("./formatters/commitFormatter");
const types_2 = require("./formatters/types");
const container_1 = require("./ioc/container");
const index_1 = require("./ioc/index");
const serviceManager_1 = require("./ioc/serviceManager");
const types_3 = require("./ioc/types");
const logger_1 = require("./logger");
const serviceRegistry_7 = require("./nodes/serviceRegistry");
const serviceRegistry_8 = require("./platform/serviceRegistry");
const contentProvider_1 = require("./server/contentProvider");
const serverHost_1 = require("./server/serverHost");
const stateStore_1 = require("./server/stateStore");
const themeService_1 = require("./server/themeService");
const types_4 = require("./server/types");
const types_5 = require("./types");
const commitFileViewer_1 = require("./viewers/file/commitFileViewer");
const serviceRegistry_9 = require("./viewers/serviceRegistry");
let cont;
let serviceManager;
let serviceContainer;
// tslint:disable-next-line:no-any
function activate(context) {
    return __awaiter(this, void 0, void 0, function* () {
        cont = new inversify_1.Container();
        serviceManager = new serviceManager_1.ServiceManager(cont);
        serviceContainer = new container_1.ServiceContainer(cont);
        cont.bind(types_3.IServiceContainer).toConstantValue(serviceContainer);
        cont.bind(types_1.ILogService).to(log_1.Logger).inSingletonScope();
        cont.bind(types_1.ILogService).to(uiLogger_1.OutputPanelLogger).inSingletonScope(); // .whenTargetNamed('Viewer');
        cont.bind(types_1.IUiService).to(uiService_1.UiService).inSingletonScope();
        cont.bind(types_4.IThemeService).to(themeService_1.ThemeService).inSingletonScope();
        cont.bind(types_2.ICommitViewFormatter).to(commitFormatter_1.CommitViewFormatter).inSingletonScope();
        // cont.bind<IServerHost>(IServerHost).to(ServerHost).inSingletonScope();
        cont.bind(types_4.IWorkspaceQueryStateStore).to(stateStore_1.StateStore).inSingletonScope();
        cont.bind(types_5.IOutputChannel).toConstantValue(logger_1.getLogChannel());
        cont.bind('globalMementoStore').toConstantValue(context.globalState);
        cont.bind('workspaceMementoStore').toConstantValue(context.workspaceState);
        // cont.bind<FileStatParser>(FileStatParser).to(FileStatParser);
        serviceRegistry_1.registerTypes(serviceManager);
        serviceRegistry_2.registerTypes(serviceManager);
        serviceRegistry_3.registerTypes(serviceManager);
        serviceRegistry_4.registerTypes(serviceManager);
        serviceRegistry_8.registerTypes(serviceManager);
        serviceRegistry_5.registerTypes(serviceManager);
        serviceRegistry_7.registerTypes(serviceManager);
        serviceRegistry_9.registerTypes(serviceManager);
        index_1.setServiceContainer(serviceContainer);
        const themeService = serviceContainer.get(types_4.IThemeService);
        const gitServiceFactory = serviceContainer.get(types_5.IGitServiceFactory);
        const workspaceQuerySessionStore = serviceContainer.get(types_4.IWorkspaceQueryStateStore);
        serviceManager.addSingletonInstance(types_4.IServerHost, new serverHost_1.ServerHost(themeService, gitServiceFactory, serviceContainer, workspaceQuerySessionStore));
        // Register last.
        serviceRegistry_6.registerTypes(serviceManager);
        let disposable = vscode.workspace.registerTextDocumentContentProvider(constants_1.gitHistorySchema, new contentProvider_1.ContentProvider(serviceContainer));
        context.subscriptions.push(disposable);
        disposable = vscode.workspace.registerTextDocumentContentProvider(constants_1.gitHistoryFileViewerSchema, new commitFileViewer_1.CommitFileViewerProvider(serviceContainer));
        context.subscriptions.push(disposable);
        context.subscriptions.push(serviceManager.get(disposableRegistry_1.IDisposableRegistry));
        const commandManager = serviceContainer.get(commandManager_1.ICommandManager);
        commandManager.executeCommand('setContext', 'git.commit.view.show', true);
        // fileHistory.activate(context);
        // lineHistory.activate(context);
        // searchHistory.activate(context);
        // commitViewer.activate(context, logViewer.getGitRepoPath);
        // logViewer.activate(context);
        // commitComparer.activate(context, logViewer.getGitRepoPath);
    });
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map