"use strict";

// module Dom

var Maybe = require("Data.Maybe");

exports.body = function () {
    return document.body;
};

exports.getElementById = function (id) {
    return function () {
        var element = document.getElementById(id);
        return element ? Maybe.Just.create(element) : Maybe.Nothing.value;
    };
};

exports.createElement = function (tag) {
    return function () {
        return document.createElement(tag);
    };
};

exports.createTextNode = function (text) {
    return function () {
        return document.createTextNode(text);
    };
};

exports.appendChild = function (parent) {
    return function (child) {
        return function () {
            parent.appendChild(child);
            return {};
        };
    };
};

exports.removeChild = function (parent) {
    return function (child) {
        return function () {
            parent.removeChild(child);
            return {};
        };
    };
};

exports.getAttribute = function (element) {
    return function (attr) {
        return function () {
            var value = element.getAttribute(attr);
            return value ? Maybe.Just.create(value) : Maybe.Nothing.value;
        };
    };
};

exports.setAttribute = function (element) {
    return function (attr) {
        return function (value) {
            return function () {
                element.setAttribute(attr, value);
                return {};
            };
        };
    };
};

exports.getValue = function (element) {
    return function () {
        var value = element.value;
        return value ? Maybe.Just.create(value) : Maybe.Nothing.value;
    };
};

function setProperty(name) {
    return function (element) {
        return function (value) {
            return function () {
                element[name] = value;
                return {};
            };
        };
    };
}

exports.setValue = setProperty("value");

exports.onInput = setProperty("oninput");

exports.onClick = setProperty("onclick");

