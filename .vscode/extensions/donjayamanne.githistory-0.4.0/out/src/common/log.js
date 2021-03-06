"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
const inversify_1 = require("inversify");
const vscode_1 = require("vscode");
let Logger = class Logger {
    constructor() {
        this.updateEnabledFlag();
        this.disposable = vscode_1.workspace.onDidChangeConfiguration(() => this.updateEnabledFlag());
    }
    get enabled() {
        return this._enabled;
    }
    dispose() {
        this.disposable.dispose();
    }
    // tslint:disable-next-line:no-any
    log(...args) {
        if (!this.enabled) {
            return;
        }
        // tslint:disable-next-line:no-console
        console.log(...args);
    }
    // tslint:disable-next-line:no-any
    error(...args) {
        if (!this.enabled) {
            return;
        }
        console.error(...args);
    }
    // tslint:disable-next-line:no-any
    trace(...args) {
        if (!this.enabled) {
            return;
        }
        console.warn(...args);
    }
    updateEnabledFlag() {
        this._enabled = vscode_1.workspace.getConfiguration('gitHistory').get('logLevel', 'None') === 'Info';
    }
};
Logger = __decorate([
    inversify_1.injectable(),
    __metadata("design:paramtypes", [])
], Logger);
exports.Logger = Logger;
//# sourceMappingURL=log.js.map