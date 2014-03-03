# OAuthClientSetup

Sample iOS application for client authorization with
OAuth 2 authentication server includes sample calls to an
OAuth 2 protected API.  Currently uses "Resource Owner Password Credentials Grant" only,
according to [rfc6749](http://www.rfc-editor.org/rfc/rfc6749.txt) Section 4.3.

## Usage

- Clone the project using git.
- Install the Pod dependencies found in the Podfile. `pod install`
- Open the XCode workspace.  (The workspace, not the project.)
- Copy one of the sample `oauth_setup` configuration files to `oauth_setup.plist.`
- Edit `oauth_setup.plist.`
  - `base_url` is the url for an OAuth 2 authentication server.
  - `callback_url` is the client url for redirection after successful authentication.
  - `token_path` is the path appended to the base url for authentication server token management.
  - `auth_path` is the path appended to the base url for client authorization with the authentication server.
  - `client_secret` is the secret allocated your client on the authentication server.
  - `client_key` is the key identifier allocated your client on the authentiaction server.
- Ready to run.

## Authentication server notes

We are testing with this [sample authentication server]
(https://github.com/telegraphy-interactive/doorkeeper-provider-app).
The sample server requires a little Ruby on Rails knowledge to operate.

This sample client does not currently work with the test server hosted by [applicake]
(https://github.com/applicake/doorkeeper-provider-app)
at [heroku]
(http://doorkeeper-provider.herokuapp.com/)
We found we wanted something more up-level than found there currently.

## Hints for using in your own iOS client application

The `OACSAuthClient` class provides most of the useful function.  Copy paste is easiest.  Don't forget the copyright and license.

The `OACSNetStatusHelper` class might be useful if your client monitors and displays network status.  If your application is internationalized, you'll have to modify accordingly.  An i18n contribution and translations are welcome.

The UI views and controllers are as generic as possible and likely useless to you as anything other than starting points.  Find short descriptions as follows.

The `OACSAppDelegate` manages a tab bar controller with two tabs: one for the API and one for managing the Authorization.

For authorizaton, the `OACSConfigureViewController` checks the configuration and manages two other view-controllers:

- `OACSConnectViewController` displays when there is no authorization.  It currently supports the Resource Owner Password Credentials Grant.  The content owner user authorizes the application using their user id and password.  We think this is an anti-pattern, but it is the best we have yet accomplished and it is what any of the most popular, commonly used app's have achieved.  That is not to say it should not be better.  We would like to have implemented an Authorization Code Grant.
- `OACSAuthorizedViewController` displays when the client has authorization.  It enables the user of the client to revoke their authorization.

For API usage, the `OACSapiViewController` provides two buttons that initiate API calls and display all or a portion of the returned data.

### SystemConfiguration Framework

When you set up your project, you must include the SystemConfiguration Framework.
To do that with XCode5, on your project settings, with the "General" tab selected, scroll to the bottom to
"Linked Frameworks and Libraries."  If SystemConfiguration is not already there, click the little plus icon,
then select SystemConfiguration.framework from the popup dialog and click "Add."

Also when you set up your project, you must have `#import <SystemConfiguration/SystemConfiguration.h>`
within your ProjectName-Prefix.pch file.  Look at this project's OAuthClientSetup-Prefix.pch within the
Supporting Files directory.  It has the following:

```
#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #import <SystemConfiguration/SystemConfiguration.h>
#endif

```

You must ensure that the SystemConfiguration.h import is present for your project.

### Saving and restoring the authorization token

The OACSAppDelegate class implements `applicationDidEnterBackground` and `applicationWillEnterForeground`
methods to save and restore the OAuth client token.  If you do not do so, then the user will have to reestablish
authorization every time the application starts or returns from the background state.

## Some screen shots

### OACSConnectViewController
![`OACSConnectViewController`](OACSConnectViewController.png)

### OACSAuthorizedViewController
![`OACSAuthorizedViewController`](OACSAuthorizedViewController.png)

### OACSapiViewController
![`OACSapiViewController`](OACSapiViewController.png)

## Support and License

This is unsupported, however:

- If you find a bug, please write it up in the issues list so that others may know about it or fix it.  
We might fix it, no promises.  Your fixes are welcome.
- If you fork, and do something useful, your pull request is welcome.

Only please refrain from posting and emailing questions about how to implement an OAuth 2 client.  
It is tough and not so tough.
Many little details to learn and implement.
We hope this sample code will be helpful for you.

The license is the [Apache Version 2 license](http://www.apache.org/licenses/LICENSE-2.0).
