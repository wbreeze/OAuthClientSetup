//
//  OAuthClientSetupTests.m
//  OAuthClientSetupTests
//
//  Created by Douglas Lovell on 1/16/14.
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

#import <XCTest/XCTest.h>
#import "OACSAuthClient.h"
#import "OHHTTPStubs.h"
#import "OHHTTPStubsResponse+JSON.h"

@interface OAuthClientSetupTests : XCTestCase

@end

@implementation OAuthClientSetupTests

OACSAuthClient *client;

- (void)setUp
{
    [super setUp];
    client = [[OACSAuthClient alloc] initWithConfigurationAt:@"oauth_setup_localhost.plist" archiveAt:@"testArchive"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testClientCredentialsAuth
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"localhost"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse
                responseWithJSONObject:@{
                    @"access_token":@"3c62d12338010ed8c0ad71cffba57d63cc7c7b6b045dc7779268b0eb497bcd",
                    @"token_type":@"bearer",
                    @"expires_in":@300,
                    @"refresh_token":@"0a3ac4e725ad92f8a4a1762233a368beda7f0b3301f095495b17679081147669",
                    @"scope":@"public"
                }
                statusCode:200
                headers:@{@"Content-Type":@"text/json"}];
    }];
    [client authorizeUser:@"user" password:@"pwd"
                onSuccess:^() {
                }
                onFailure:^(NSString *localizedErrorDescription) {
                    XCTFail(@"Expected success, got %@", localizedErrorDescription);
                }];
}

@end
