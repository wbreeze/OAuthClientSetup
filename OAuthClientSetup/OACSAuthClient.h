//
//  OACSAuthClient.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 2/5/14.
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

#import <Foundation/Foundation.h>
#import "AFOAuth2Client.h"
#import "OACSNetStatusHelper.h"

@interface OACSAuthClient : NSObject

@property (strong, nonatomic) AFOAuth2Client *oauthClient;
@property (strong, nonatomic) AFHTTPClient *httpClient;
@property (strong, nonatomic) NSString *auth_path;
@property (strong, nonatomic) NSString *client_secret;
@property (strong, nonatomic) NSString *client_key;
@property (strong, nonatomic) NSString *token_path;
@property (strong, nonatomic) NSURL *base_url;
@property (strong, nonatomic) NSURL *callback_url;
@property (strong, nonatomic) AFOAuthCredential *creds;

- (OACSAuthClient *)initWithConfigurationAt: (NSString *)configPath archiveAt:(NSString *)archivePath;
- (void)archiveTo:(NSString *)archivePath;
- (void)observeNetworkAvailabilityChanges: (OACSNetStatusHelper *)observer;
- (AFNetworkReachabilityStatus)networkAvailable;

- (void)authorizeUser:(NSString *)user_name password:(NSString *)password onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure;
- (void)authorizedGet:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSString *))failure;
- (void)resignAuthorization;

@end

@protocol OACSAuthClientConsumer
- (void)setAuthClient: (OACSAuthClient *)client;
@end
