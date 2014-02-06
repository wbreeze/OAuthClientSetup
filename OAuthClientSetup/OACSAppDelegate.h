//
//  OACSAppDelegate.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OACSAuthClient.h"

@interface OACSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OACSAuthClient *client;

@end
