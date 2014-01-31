//
//  OACSNetStatusViewController.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StatusUpdate)(BOOL status);

@interface OACSNetStatusHelper : NSObject

- (OACSNetStatusHelper *)initWithLabel:(UILabel *)label statusCallback:(StatusUpdate)updateStatus;

@end
