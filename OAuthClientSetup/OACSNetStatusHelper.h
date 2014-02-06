//
//  OACSNetStatusViewController.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"

typedef void(^StatusUpdate)(BOOL status);

// acts as key value observer for AFHTTPClient networkReachabilityStatus
@interface OACSNetStatusHelper : NSObject

- (void)updateStatus:(AFNetworkReachabilityStatus)status;
- (OACSNetStatusHelper *)initWithLabel:(UILabel *)label statusCallback:(StatusUpdate)updateStatus;

@end
