//
//  OACSAppDelegate.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OACSConnectViewController.h"
#import "AFOAuth2Client.h"

@interface OACSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AFOAuth2Client *oauthClient;
@property (strong, nonatomic) AFHTTPClient *httpClient;
@property (strong, nonatomic) NSString *auth_path;
@property (strong, nonatomic) NSString *client_secret;
@property (strong, nonatomic) NSString *client_key;
@property (strong, nonatomic) NSString *token_path;
@property (strong, nonatomic) NSURL *base_url;
@property (strong, nonatomic) NSURL *callback_url;
@property (atomic) AFNetworkReachabilityStatus networkAvailable;
@property (strong, nonatomic) AFOAuthCredential *creds;

@end
