//
//  OACSNetStatusHelper.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
