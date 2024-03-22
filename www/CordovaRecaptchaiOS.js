var exec = require('cordova/exec');

module.exports = {
    initializeRecaptcha: function (siteKey, success, error) {
        exec(success, error, 'CordovaRecaptchaMobile', 'initializeRecaptcha', [siteKey]);
    },
    executeRecaptcha: function (action, success, error) {
        exec(success, error, 'CordovaRecaptchaMobile', 'executeRecaptcha', [action]);
    }
};
