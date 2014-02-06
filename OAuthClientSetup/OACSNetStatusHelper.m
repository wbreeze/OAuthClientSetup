//
//  OACSNetStatusViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSNetStatusHelper.h"

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

// acts as key value observer for AFHTTPClient networkReachabilityStatus
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"networkReachabilityStatus"]) {
        AFHTTPClient *netClient = (AFHTTPClient *)object;
        [self updateStatus:[netClient networkReachabilityStatus]];
    }
}

- (OACSNetStatusHelper *)initWithLabel:(UILabel *)label statusCallback:(StatusUpdate)updateStatus
{
    self = [self init];
    if (self) {
        self.liveLabel = label;
        self.connectStatusUpdate = updateStatus;
    }
    return self;
}

@end
