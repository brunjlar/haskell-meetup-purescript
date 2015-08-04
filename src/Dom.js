"use strict";

// module Dom

var Maybe = require("Data.Maybe");

exports.getValueById = function(id) {
    return function () {
        var element = document.getElementById(id);
        if (element) {
            var value = element.value;
            if (value !== undefined) { 
                return Maybe.Just.create(value);
            }
        }
        return Maybe.Nothing.value;
    };
};

exports.setValueById = function(id) {
    return function (value) {
        return function () {
            var element = document.getElementById(id);
            if (element) {
                element.value = value;
            }
            return {};
        }
    };
};

function setById(name) {
    return function (id) {
        return function (value) {
            return function () {
                var element = document.getElementById(id);
                if (element) {
                    element[name] = value;
                }
                return {};
            };
        };
    };
}

exports.onInput = setById("oninput");

exports.onClick = setById("onclick");

