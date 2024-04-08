# reCAPTCHA on Ionic
Most online implementations of reCAPTCHA for android and iOS leverages the webview, using the reCAPTCHA for web. There are a few problems a developer will quickly encounter with that approach, mostly related to iOS security.
After dealing with a bunch of problems on iOS, trying to integrate reCAPTCHA on ionic's webview, I simply decided to take a native approach.
This is still under development and once I feel it's ready to use, I will update this read me with instructions.

# Installing
```
cordova plugin add https://github.com/kumahooks/cordova-plugin-recaptcha-mobile
```

# Usage
```ts
  public async initializeRecaptcha(siteKey: string): Promise<boolean | null> {
    return new Promise<boolean | null>((resolve, reject) => {
      cordova.plugins['CordovaRecaptchaMobile'].initializeRecaptcha(siteKey,
        () => {
          resolve(true);
        },
        () => {
          reject(null);
        }
      );
    });
  }

  public async getReCAPTCHAToken(action: string): Promise<string | null> {
    return new Promise<string | null>((resolve) => {
      cordova.plugins['CordovaRecaptchaMobile'].executeRecaptcha(action,
        (token) => {
          resolve(token)
        },
        () => {
          resolve(null)
        }
      );
    });
  }
```
