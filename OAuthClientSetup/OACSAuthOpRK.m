//
//  OACSAuthOpRK.m
//
//  Created by Douglas Lovell on 3/27/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
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

#import "OACSAuthOpRK.h"
#import "RKHTTPRequestOperation.h"

@interface OACSAuthOpRK()
@property(strong, readwrite) RKObjectManager *objectManager;
@property(strong, readwrite) NSString *path;
@end

@implementation OACSAuthOpRK

@synthesize operation;
@synthesize mappingResult;

@synthesize hasHTTPStatus;
@synthesize httpStatusCode;
@synthesize wasSuccessful;
@synthesize error;

- (OACSAuthOpRK *)initWithObjectManager:(RKObjectManager *)om forPath:(NSString *)path
{
    self.objectManager = om;
    self.path = path;
    return self;
}

// queue the authorized network operation using the authToken.
// After success or failure, store the results and execute the callback.
// Operation may be called a second time, with a different authToken,
// if it returns wasSuccessful NO, hasHTTPStatus YES, httpStatusCode 401
- (void)queueOpWith:(NSString*)authToken callback:(void (^)())callback
{
    [self.objectManager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", authToken]];
    [self.objectManager getObjectsAtPath:self.path parameters:nil success:^(RKObjectRequestOperation *rkop, RKMappingResult *res) {
        self.operation = rkop;
        self.mappingResult = res;
        self.hasHTTPStatus = true;
        RKHTTPRequestOperation *op = rkop.HTTPRequestOperation;
        NSHTTPURLResponse *response = op.response;
        self.httpStatusCode = response.statusCode;
        self.wasSuccessful = YES;
        self.error = nil;
        callback();
    } failure:^(RKObjectRequestOperation *rkop, NSError *rkerr) {
        NSLog(@"failed synchEntries operation got %@", [[rkop HTTPRequestOperation] responseString]);
        self.operation = rkop;
        self.mappingResult = nil;
        self.hasHTTPStatus = true;
        RKHTTPRequestOperation *op = rkop.HTTPRequestOperation;
        NSHTTPURLResponse *response = op.response;
        self.httpStatusCode = response.statusCode;
        self.wasSuccessful = NO;
        self.error = rkerr;
        callback();
    }];
}

@end
