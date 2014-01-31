//
//  OACSNetStatusViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSNetStatusHelper.h"
#import "OACSAppDelegate.h"
#import "AFOAuth2Client.h"

@interface OACSNetStatusHelper ()

@property (nonatomic) UILabel *liveLabel;
@property (strong, atomic) StatusUpdate connectStatusUpdate;

@end

@implementation OACSNetStatusHelper

- (void)updateStatus:(AFNetworkReachabilityStatus)status {
    if (status == AFNetworkReachabilityStatusNotReachable) {
        self.liveLabel.text = @"No network connection";
        self.connectStatusUpdate(NO);
    }
    else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        self.liveLabel.text = @"Networked using WiFi";
        self.connectStatusUpdate(YES);
    }
    else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        self.liveLabel.text = @"Networked using Cellular Wireless";
        self.connectStatusUpdate(YES);
    }
    else {
        self.liveLabel.text = @"Network status unavailable";
        self.connectStatusUpdate(YES);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"networkAvailable"]) {
        OACSAppDelegate *app = (OACSAppDelegate *)([UIApplication sharedApplication].delegate);
        [self updateStatus:app.networkAvailable];
    }
}

- (OACSNetStatusHelper *)initWithLabel:(UILabel *)label statusCallback:(StatusUpdate)updateStatus
{
    self = [self init];
    if (self) {
        self.liveLabel = label;
        self.connectStatusUpdate = updateStatus;
        OACSAppDelegate *app = (OACSAppDelegate *)([UIApplication sharedApplication].delegate);
        [self updateStatus:app.networkAvailable];
        [app addObserver:self
              forKeyPath:@"networkAvailable"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
    }
    return self;
}

@end
