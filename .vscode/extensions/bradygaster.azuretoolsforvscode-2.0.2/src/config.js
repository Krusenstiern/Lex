'option strict';

const vscode = require('vscode');

exports.getTenantId = function getTenantId() {
    var f = vscode.workspace.getConfiguration('azure');
    if (f != null) {
        if (f.tenantId != null)
            return f.tenantId;
    }
    return null;
};

exports.showToolsWindowOnStartup = function showToolsWindowOnStartup() {
    var f = vscode.workspace.getConfiguration('azure');
    if (f != null)
        if (f.showToolsWindowOnStartup != null)
            if (typeof (f.showToolsWindowOnStartup) === "boolean")
                return f.showToolsWindowOnStartup

    return true;
};

