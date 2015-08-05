"use strict";

// module Dom

exports.body = function () {
    return document.body;
};

exports.getElementByIdImpl = function (just, nothing, id) {
    return function () {
        var element = document.getElementById(id);
        return element ? just(element) : nothing;
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

exports.appendChildImpl = function (parent, child) {    
    return function () {
        parent.appendChild(child);
        return {};
    };
};

exports.removeChildImpl = function (parent, child) {
    return function () {
        parent.removeChild(child);
        return {};
    };
};

exports.getAttributeImpl = function (just, nothing, element, attr) {    
    return function () {
        var value = element.getAttribute(attr);
        return value ? just(value) : nothing;
    };
};

exports.setAttributeImpl = function (element, attr, value) {
    return function () {
        element.setAttribute(attr, value);
        return {};
    };
};

exports.getValueImpl = function (just, nothing, element) {
    return function () {
        var value = element.value;
        return value ? just(value) : nothing;
    };
};

function setProperty(name, element, value) {
    return function () {
        element[name] = value;
        return {};
    };
}

exports.setValueImpl = function (element, value) {
    return setProperty("value", element, value);
}

exports.onInputImpl = function (element, handler) {
    return setProperty("oninput", element, handler);
}

exports.onClickImpl = function (element, handler) {
    return setProperty("onclick", element, handler);
}

