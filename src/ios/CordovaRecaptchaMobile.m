#import <Cordova/CDV.h>
#import <RecaptchaEnterprise/RecaptchaEnterprise.h> 

@interface CordovaRecaptchaMobile : CDVPlugin {
    RecaptchaClient *recaptchaClient;
}

- (void)initializeRecaptcha:(CDVInvokedUrlCommand*)command;
- (void)executeRecaptcha:(CDVInvokedUrlCommand*)command;
@end

@implementation CordovaRecaptchaMobile

- (void)initializeRecaptcha:(CDVInvokedUrlCommand*)command {
    NSString* siteKey = [command.arguments objectAtIndex:0];

    [Recaptcha getClientWithSiteKey:siteKey 
        completion:^(RecaptchaClient *recaptchaClient, NSError *error) {
            if (!recaptchaClient) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                self->recaptchaClient = recaptchaClient;
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }
    ];
}

- (void)executeRecaptcha:(CDVInvokedUrlCommand*)command {
    if (!self->recaptchaClient) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Recaptcha client not initialized"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    NSString* action = [command.arguments objectAtIndex:0];

    [self->recaptchaClient execute:action 
        completion:^(NSString* _Nullable token, NSError* _Nullable error) {
            if (token) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:token];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                NSString* errorMessage = (error && [error respondsToSelector:@selector(errorMessage)]) ? [error performSelector:@selector(errorMessage)] : @"Unknown error";
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }
    ];
}

@end
