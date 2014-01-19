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
@property (nonatomic, strong) OACSConnectViewController *connectViewController;
@property (strong, nonatomic) AFOAuth2Client *oauthClient;
@property (atomic) NSString *auth_path;
@property (atomic) NSString *token_path;
@property (atomic) NSURL *callback_url;

@end
