package org.kumahooks.cordovarecaptchamobile;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.android.recaptcha.Recaptcha;
import com.google.android.recaptcha.RecaptchaAction;
import com.google.android.recaptcha.RecaptchaTasksClient;

public class CordovaRecaptchaMobile extends CordovaPlugin {
    private RecaptchaTasksClient recaptchaTasksClient;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("initializeRecaptcha")) {
            String siteKey = args.getString(0);
            this.initializeRecaptchaClient(siteKey, callbackContext); 
            return true;
        }

        if (action.equals("executeRecaptcha")) {
            String actionName = args.getString(0);
            this.executeRecaptcha(actionName, callbackContext); 
            return true;
        }

        return false;
    }

    private void initializeRecaptchaClient(String siteKey, CallbackContext callbackContext) {
        Recaptcha.getTasksClient(cordova.getActivity().getApplication(), siteKey)
            .addOnSuccessListener(recaptchaTasksClient -> {
                this.recaptchaTasksClient = recaptchaTasksClient;
                callbackContext.success();
            })
            .addOnFailureListener(exception -> {
                callbackContext.error(exception.getMessage()); 
            });
    }

    private void executeRecaptcha(String actionName, CallbackContext callbackContext) {
        if (recaptchaTasksClient == null) {
            callbackContext.error("reCAPTCHA not initialized");
            return;
        }

        recaptchaTasksClient.executeTask(RecaptchaAction.custom(actionName))
            .addOnSuccessListener(recaptchaTaskResult -> {
                callbackContext.success(recaptchaTaskResult); 
            })
            .addOnFailureListener(exception -> {
                callbackContext.error(exception.getMessage()); 
            });
    }
}
