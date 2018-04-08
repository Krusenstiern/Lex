"use strict";
/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_languageserver_1 = require("vscode-languageserver");
const fs = require("fs");
const path = require("path");
const minimatch = require("minimatch");
const _ = require("lodash");
const htmlparser = require("htmlparser2");
const processIgnoreFile = require("parse-gitignore");
function locateFile(directory, fileName) {
    let parent = directory;
    do {
        directory = parent;
        let location = path.join(directory, fileName);
        if (fs.existsSync(location)) {
            return location;
        }
        parent = path.dirname(directory);
    } while (parent !== directory);
    return undefined;
}
;
const JSHINTRC = '.jshintrc';
class OptionsResolver {
    constructor(connection) {
        this.connection = connection;
        this.clear();
        this.configPath = null;
        this.jshintOptions = null;
    }
    configure(path, jshintOptions) {
        this.optionsCache = Object.create(null);
        this.configPath = path;
        this.jshintOptions = jshintOptions;
    }
    clear(jshintOptions) {
        this.optionsCache = Object.create(null);
    }
    getOptions(fsPath) {
        let result = this.optionsCache[fsPath];
        if (!result) {
            result = this.readOptions(fsPath);
            this.optionsCache[fsPath] = result;
        }
        return result;
    }
    readOptions(fsPath = null) {
        let that = this;
        function stripComments(content) {
            /**
            * First capturing group matches double quoted string
            * Second matches single quotes string
            * Third matches block comments
            * Fourth matches line comments
            */
            var regexp = /("(?:[^\\\"]*(?:\\.)?)*")|('(?:[^\\\']*(?:\\.)?)*')|(\/\*(?:\r?\n|.)*?\*\/)|(\/{2,}.*?(?:(?:\r?\n)|$))/g;
            let result = content.replace(regexp, (match, m1, m2, m3, m4) => {
                // Only one of m1, m2, m3, m4 matches
                if (m3) {
                    // A block comment. Replace with nothing
                    return "";
                }
                else if (m4) {
                    // A line comment. If it ends in \r?\n then keep it.
                    let length = m4.length;
                    if (length > 2 && m4[length - 1] === '\n') {
                        return m4[length - 2] === '\r' ? '\r\n' : '\n';
                    }
                    else {
                        return "";
                    }
                }
                else {
                    // We match a string
                    return match;
                }
            });
            return result;
        }
        ;
        function readJsonFile(file, extendedFrom) {
            try {
                return JSON.parse(stripComments(fs.readFileSync(file).toString()));
            }
            catch (err) {
                let location = extendedFrom ? `${file} extended from ${extendedFrom}` : file;
                that.connection.window.showErrorMessage(`Can't load JSHint configuration from file ${location}. Please check the file for syntax errors.`);
                return {};
            }
        }
        function readJSHintFile(file, extendedFrom) {
            that.connection.console.info(extendedFrom ? `Reading jshint configuration from ${file}, which was extended from ${extendedFrom}` : `Reading jshint configuration from ${file}`);
            let content = readJsonFile(file, extendedFrom);
            if (content.extends) {
                let baseFile = path.resolve(path.dirname(file), content.extends);
                if (fs.existsSync(baseFile)) {
                    content = _.mergeWith(readJSHintFile(baseFile, file), content, (baseValue, contentValue) => {
                        if (_.isArray(baseValue)) {
                            return baseValue.concat(contentValue);
                        }
                    });
                }
                else {
                    that.connection.window.showErrorMessage(`Can't find JSHint file ${baseFile} extended from ${file}`);
                }
                delete content.extends;
            }
            if (content.overrides) {
                Object.keys(content.overrides).forEach(pathPattern => {
                    if (minimatch(fsPath, pathPattern)) {
                        const optionsToOverride = content.overrides[pathPattern];
                        if (optionsToOverride.globals) {
                            content.globals = _.extend(content.globals || {}, optionsToOverride.globals);
                            delete optionsToOverride.globals;
                        }
                        Object.keys(optionsToOverride).forEach(optionKey => {
                            content[optionKey] = optionsToOverride[optionKey];
                        });
                    }
                });
                delete content.overrides;
            }
            return content;
        }
        function isWindows() {
            return process.platform === 'win32';
        }
        function getUserHome() {
            return process.env[isWindows() ? 'USERPROFILE' : 'HOME'];
        }
        if (this.configPath && fs.existsSync(this.configPath)) {
            return readJsonFile(this.configPath);
        }
        let jshintOptions = this.jshintOptions;
        // backward compatibility
        if (jshintOptions && jshintOptions.config && fs.existsSync(jshintOptions.config)) {
            this.connection.console.info(`Reading configuration from ${jshintOptions.config}`);
            return readJsonFile(jshintOptions.config);
        }
        if (fsPath) {
            let packageFile = locateFile(fsPath, 'package.json');
            if (packageFile) {
                let content = readJsonFile(packageFile);
                if (content.jshintConfig) {
                    this.connection.console.info(`Reading configuration from ${packageFile}`);
                    return content.jshintConfig;
                }
            }
            let configFile = locateFile(fsPath, JSHINTRC);
            if (configFile) {
                return readJSHintFile(configFile);
            }
        }
        let home = getUserHome();
        if (home) {
            let file = path.join(home, JSHINTRC);
            if (fs.existsSync(file)) {
                return readJSHintFile(file);
            }
        }
        // No file found, using jshint.options setting
        this.connection.console.info(`Reading configuration from 'jshint.options' setting`);
        return jshintOptions;
    }
}
const JSHINTIGNORE = '.jshintignore';
class FileMatcher {
    constructor() {
        this.configPath = null;
        this.defaultExcludePatterns = null;
        this.excludeCache = {};
    }
    pickTrueKeys(obj) {
        return _.keys(_.pickBy(obj, (value) => {
            return value === true;
        }));
    }
    configure(path, exclude) {
        this.configPath = path;
        this.excludeCache = {};
        this.defaultExcludePatterns = this.pickTrueKeys(exclude);
    }
    clear(exclude) {
        this.excludeCache = {};
    }
    relativeTo(fsPath, folder) {
        if (folder && 0 === fsPath.indexOf(folder)) {
            let cuttingPoint = folder.length;
            if (cuttingPoint < fsPath.length && '/' === fsPath.charAt(cuttingPoint)) {
                cuttingPoint += 1;
            }
            return fsPath.substr(cuttingPoint);
        }
        return fsPath;
    }
    folderOf(fsPath) {
        let index = fsPath.lastIndexOf('/');
        return index > -1 ? fsPath.substr(0, index) : fsPath;
    }
    match(excludePatters, path, root) {
        let relativePath = this.relativeTo(path, root);
        return _.some(excludePatters, (pattern) => {
            return minimatch(relativePath, pattern);
        });
    }
    ;
    excludes(fsPath, root) {
        if (fsPath) {
            if (this.excludeCache.hasOwnProperty(fsPath)) {
                return this.excludeCache[fsPath];
            }
            let shouldBeExcluded = false;
            if (this.configPath && fs.existsSync(this.configPath)) {
                shouldBeExcluded = this.match(processIgnoreFile(this.configPath), fsPath, root);
            }
            else {
                let ignoreFile = locateFile(fsPath, JSHINTIGNORE);
                if (ignoreFile) {
                    shouldBeExcluded = this.match(processIgnoreFile(ignoreFile), fsPath, this.folderOf(ignoreFile));
                }
                else {
                    shouldBeExcluded = this.match(this.defaultExcludePatterns, fsPath, root);
                }
            }
            this.excludeCache[fsPath] = shouldBeExcluded;
            return shouldBeExcluded;
        }
        return true;
    }
}
class Linter {
    constructor() {
        this.connection = vscode_languageserver_1.createConnection(new vscode_languageserver_1.IPCMessageReader(process), new vscode_languageserver_1.IPCMessageWriter(process));
        this.options = new OptionsResolver(this.connection);
        this.fileMatcher = new FileMatcher();
        this.documents = new vscode_languageserver_1.TextDocuments();
        this.documents.onDidChangeContent(event => this.validateSingle(event.document));
        this.documents.onDidClose((event) => {
            this.connection.sendDiagnostics({ uri: event.document.uri, diagnostics: [] });
        });
        this.documents.listen(this.connection);
        this.connection.onInitialize(params => this.onInitialize(params));
        this.connection.onDidChangeConfiguration(params => {
            this.settings = _.assign({ options: {}, exclude: {} }, params.settings.jshint);
            const { config, options, excludePath, exclude } = this.settings;
            this.options.configure(config, options);
            this.fileMatcher.configure(excludePath, exclude);
            this.validateAll();
        });
        this.connection.onDidChangeWatchedFiles(params => {
            var needsValidating = false;
            if (params.changes) {
                params.changes.forEach(change => {
                    switch (this.lastSegment(change.uri)) {
                        case JSHINTRC:
                            this.options.clear();
                            needsValidating = true;
                            break;
                        case JSHINTIGNORE:
                            this.fileMatcher.clear();
                            needsValidating = true;
                            break;
                    }
                });
            }
            if (needsValidating) {
                this.validateAll();
            }
        });
    }
    listen() {
        this.connection.listen();
    }
    lastSegment(fsPath) {
        let index = fsPath.lastIndexOf('/');
        return index > -1 ? fsPath.substr(index + 1) : fsPath;
    }
    trace(message, verbose) {
        this.connection.tracer.log(message, verbose);
    }
    getGlobalPackageManagerPath(packageManager) {
        if (packageManager === "npm") {
            return vscode_languageserver_1.Files.resolveGlobalNodePath();
        }
        else if (packageManager === "yarn") {
            return vscode_languageserver_1.Files.resolveGlobalYarnPath();
        }
    }
    onInitialize(params) {
        this.workspaceRoot = params.rootPath;
        const nodePath = params.initializationOptions && params.initializationOptions.nodePath;
        const packageManager = params.initializationOptions && params.initializationOptions.packageManager;
        const globalPath = this.getGlobalPackageManagerPath(packageManager);
        let libraryPathPromise;
        if (nodePath) {
            libraryPathPromise = vscode_languageserver_1.Files.resolve('jshint', nodePath, nodePath, () => this.trace).then(undefined, () => {
                return vscode_languageserver_1.Files.resolve('jshint', globalPath, this.workspaceRoot, () => this.trace);
            });
        }
        else {
            libraryPathPromise = vscode_languageserver_1.Files.resolve('jshint', /* nodePath */ undefined, this.workspaceRoot, () => this.trace).then(undefined, () => {
                return vscode_languageserver_1.Files.resolve('jshint', globalPath, this.workspaceRoot, () => this.trace);
            });
        }
        return libraryPathPromise.then((path) => {
            const lib = require(path);
            if (!lib.JSHINT) {
                return new vscode_languageserver_1.ResponseError(99, 'The jshint library doesn\'t export a JSHINT property.', { retry: false });
            }
            this.lib = lib;
            this.connection.console.info(`jshint library loaded from ${path}`);
            return { capabilities: { textDocumentSync: this.documents.syncKind } };
        }, (error) => {
            return Promise.reject(new vscode_languageserver_1.ResponseError(99, 'Failed to load jshint library. Please install jshint in your workspace folder using \'npm install jshint\' or globally using \'npm install -g jshint\' and then press Retry.', { retry: true }));
        });
    }
    validateAll() {
        let tracker = new vscode_languageserver_1.ErrorMessageTracker();
        this.documents.all().forEach(document => {
            try {
                this.validate(document);
            }
            catch (err) {
                tracker.add(this.getMessage(err, document));
            }
        });
        tracker.sendErrors(this.connection);
    }
    validateSingle(document) {
        try {
            this.validate(document);
        }
        catch (err) {
            this.connection.window.showErrorMessage(this.getMessage(err, document));
        }
    }
    lintContent(content, fsPath) {
        let JSHINT = this.lib.JSHINT;
        let options = this.options.getOptions(fsPath) || {};
        JSHINT(content, options, options.globals || {});
        return JSHINT.errors;
    }
    getEmbeddedJavascript(html) {
        let embeddedJS = [];
        let index = 0;
        let inscript = false;
        let parser = new htmlparser.Parser({
            onopentag: (name, attribs) => {
                if (name === "script" && attribs.type === "text/javascript") {
                    // Push new lines for lines between previous script tag and this one to preserve location information
                    embeddedJS.push.apply(embeddedJS, html.slice(index, parser.endIndex).match(/\n\r|\n|\r/g));
                    inscript = true;
                }
            },
            ontext(data) {
                if (!inscript)
                    return;
                // Collect JavaScript code
                embeddedJS.push(data);
            },
            onclosetag: (name) => {
                if (name !== "script" || !inscript) {
                    return;
                }
                index = parser.startIndex;
                inscript = false;
            }
        });
        parser.write(html);
        parser.end();
        return embeddedJS.join("");
    }
    validate(document) {
        if (!this.settings.lintHTML && document.languageId === "html") {
            // If the setting is toggled, errors need to be cleared
            this.connection.sendDiagnostics({ uri: document.uri, diagnostics: [] });
            return;
        }
        let fsPath = vscode_languageserver_1.Files.uriToFilePath(document.uri);
        if (!fsPath) {
            fsPath = this.workspaceRoot;
        }
        let diagnostics = [];
        if (!this.fileMatcher.excludes(fsPath, this.workspaceRoot)) {
            const content = document.languageId === "html" ? this.getEmbeddedJavascript(document.getText()) : document.getText();
            let errors = this.lintContent(content, fsPath);
            if (errors) {
                errors.forEach((error) => {
                    // For some reason the errors array contains null.
                    if (error) {
                        diagnostics.push(this.makeDiagnostic(error));
                    }
                });
            }
        }
        this.connection.sendDiagnostics({ uri: document.uri, diagnostics });
    }
    makeDiagnostic(problem) {
        // Setting errors (and potentially global file errors) will report on line zero, char zero.
        // Ensure that the start and end are >=0 (gets dropped by one in the return)
        if (problem.line <= 0) {
            problem.line = 1;
        }
        if (problem.character <= 0) {
            problem.character = 1;
        }
        return {
            message: problem.reason + (problem.code ? ` (${problem.code})` : ''),
            severity: this.getSeverity(problem),
            source: 'jshint',
            code: problem.code,
            range: {
                start: { line: problem.line - 1, character: problem.character - 1 },
                end: { line: problem.line - 1, character: problem.character - 1 }
            }
        };
    }
    getSeverity(problem) {
        // If there is no code (that would be very odd) we'll push it as an error as well.
        // See http://jshint.com/docs/ (search for error. It is only mentioned once.)
        if (!problem.code || problem.code[0] === 'E' || this.settings.reportWarningsAsErrors) {
            return vscode_languageserver_1.DiagnosticSeverity.Error;
        }
        return vscode_languageserver_1.DiagnosticSeverity.Warning;
    }
    getMessage(err, document) {
        let result = null;
        if (typeof err.message === 'string' || err.message instanceof String) {
            result = err.message;
        }
        else {
            result = `An unknown error occured while validating file: ${vscode_languageserver_1.Files.uriToFilePath(document.uri)}`;
        }
        return result;
    }
}
new Linter().listen();
//# sourceMappingURL=server.js.map