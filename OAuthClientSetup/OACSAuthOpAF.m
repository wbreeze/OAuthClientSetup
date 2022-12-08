//
//  OACSAuthOpAF.m
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

#import "OACSAuthOpAF.h"

@interface OACSAuthOpAF()
@property(strong, readwrite) AFHTTPClient *httpClient;
@property(strong, readwrite) NSString *method;
@property(strong, readwrite) NSString *path;
@property(strong, readwrite) NSDictionary *params;
@end

@implementation OACSAuthOpAF

@synthesize responseObject;

@synthesize hasHTTPStatus;
@synthesize httpStatusCode;
@synthesize wasSuccessful;
@synthesize error;

- (OACSAuthOpAF *)initWithAFHTTPClient:(AFHTTPClient *)client
                         requestMethod:(NSString *)method
                               forPath:(NSString *)path
                        withParameters:(NSDictionary *)params
{
    self.httpClient = client;
    self.method = method;
    self.path = path;
    self.params = params;
    return self;
}

// queue the authorized network operation using the authToken.
// After success or failure, store the results and execute the callback.
// Operation may be called a second time, with a different authToken,
// if it returns wasSuccessful NO, hasHTTPStatus YES, httpStatusCode 401
- (void)queueOpWith:(NSString*)authToken callback:(void (^)(void))callback
{
    [self.httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", authToken]];
    NSURLRequest *request = [self.httpClient requestWithMethod:self.method path:self.path parameters:self.params];
    AFHTTPRequestOperation *operation =
    [self.httpClient
     HTTPRequestOperationWithRequest:request
     success:^(AFHTTPRequestOperation *op, id ro) {
         self.responseObject = ro;
         self.hasHTTPStatus = YES;
         self.httpStatusCode = [op.response statusCode];
         self.wasSuccessful = YES;
         self.error = nil;
         callback();
     }
     failure:^(AFHTTPRequestOperation *op, NSError *e) {
         self.responseObject = nil;
         self.hasHTTPStatus = YES;
         self.httpStatusCode = [op.response statusCode];
         self.wasSuccessful = NO;
         self.error = e;
         callback();
     }];
    [self.httpClient enqueueHTTPRequestOperation:operation];
}

@end
