//
//  OACSAuthClient.m
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

#import "OACSAuthClient.h"
#import "AFJSONRequestOperation.h"

@implementation OACSAuthClient

/*
 Will return nil if not configured.
 @see (void)initConfigurationFrom: (NSDictionary *)config;
 */
- (AFOAuth2Client *)oauthClient {
    if (_oauthClient == nil && self.base_url && self.client_key && self.client_secret) {
        _oauthClient = [AFOAuth2Client clientWithBaseURL:self.base_url
                                                clientID:self.client_key
                                                  secret:self.client_secret];
    }
    return _oauthClient;
}

/*
 Will return nil if not configured.
 @see (void)initConfigurationFrom: (NSDictionary *)config;
 Returns client configured for JSON requests
 */
- (AFHTTPClient *)httpClient {
    if (_httpClient == nil && self.base_url) {
        _httpClient = [AFHTTPClient clientWithBaseURL:self.base_url];
        [_httpClient registerHTTPOperationClass:AFJSONRequestOperation.class];
    }
    return _httpClient;
}

- (OACSAuthClient *)initWithConfigurationAt: (NSString *)configPath archiveAt:(NSString *)archivePath {
    self = [self init];
    if (self) {
        NSDictionary *config;
        if (configPath)
        {
            config = [self readDictionaryFromConfig:configPath];
        }
        if (config) {
            [self initConfigurationFrom:config];
        }
        NSFileManager* sharedFM = [NSFileManager defaultManager];
        if ([sharedFM fileExistsAtPath:archivePath isDirectory:NO]) {
            self.creds = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
            if (self.creds) {
                [[self oauthClient] setAuthorizationHeaderWithCredential:_creds];
            }
        }
    }
    return self;
}

- (void)archiveTo:(NSString *)archivePath {
    if (self.creds != nil) {
        if (![NSKeyedArchiver archiveRootObject:self.creds toFile:archivePath]) {
            NSLog(@"failed to archive credentials at %@", archivePath);
        }
    }
}

- (void)observeNetworkAvailabilityChanges: (OACSNetStatusHelper *)observer {
    [self.httpClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [observer updateStatus:status];
    }];
}

- (AFNetworkReachabilityStatus) networkAvailable {
    return [self.httpClient networkReachabilityStatus];
}

- (BOOL)isAuthorized {
    return self.creds && self.oauthClient;
}

- (BOOL)isConfigured {
    return self.oauthClient && self.auth_path && self.token_path && self.callback_url;
}

// curl -F grant_type=password -F username=user@example.com -F password=doorkeeper http://localhost:3000/oauth/token
//{"access_token":"43fb...ffad","token_type":"bearer","expires_in":300,"refresh_token":"7ebe...743e","scope":"public"}
- (void)authorizeUser:(NSString *)user_name password:(NSString *)password onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure {
    [self.oauthClient
     authenticateUsingOAuthWithPath:self.token_path
     username:user_name
     password:password
     scope:nil
     success:^(AFOAuthCredential *credential) {
         [AFOAuthCredential storeCredential:credential
                             withIdentifier:self.oauthClient.serviceProviderIdentifier];
         self.creds = credential;
         success();
     }
     failure:^(NSError *error) {
         NSLog(@"OAuth client authorization error: %@", error);
         NSDictionary *uinfo = [error userInfo];

         NSHTTPURLResponse *response = [uinfo valueForKey:AFNetworkingOperationFailingURLResponseErrorKey];
         NSInteger status = response.statusCode;
         if (400 <= status && status < 500) {
             [self resignAuthorization];
         }
         failure([uinfo valueForKey:NSLocalizedRecoverySuggestionErrorKey]);
     }];
}

- (void)authorizedOp:(id<AuthOp>)op onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure
{
    [self authorizedOp:op onSuccess:success onFailure:failure retry:YES];
}

- (void)resignAuthorization {
    // TODO tell the authorization server to deny the client grant from this user
    [self.oauthClient clearAuthorizationHeader];
    self.creds = nil;
}

#pragma mark private

- (void)authorizedOp:(id<AuthOp>)op
           onSuccess:(void (^)())success
           onFailure:(void (^)(NSString *))failure
               retry:(BOOL) doRetry {
    if (!self.creds) {
        failure(@"Application is not authorized");
    }
    else if (self.creds.expired && doRetry) {
        [self refreshAndRetry:op onSuccess:success onFailure:failure];
    }
    else {
        [op queueOpWith:[self.creds accessToken]
               callback:^(void)
         {
             if ([op wasSuccessful]) {
                 success();
             }
             else {
                 long status = [op hasHTTPStatus] ? [op httpStatusCode] : 0;
                 if (doRetry && 401 == status) {
                     [self refreshAndRetry:op
                                 onSuccess:success
                                 onFailure:failure];
                 }
                 else {
                     if (400 <= status && status < 500) {
                         [self resignAuthorization];
                     }
                     NSError *error = [op error];
                     failure(error.userInfo[@"NSLocalizedDescription"]);
                 }
             }
         }];
    }
}

- (void)refreshAndRetry:(id<AuthOp>)op onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure {
    if (self.creds.refreshToken) {
        [self.oauthClient
         authenticateUsingOAuthWithPath:self.token_path
         refreshToken:self.creds.refreshToken
         success:^(AFOAuthCredential *credential) {
             [AFOAuthCredential storeCredential:credential
                                 withIdentifier:self.oauthClient.serviceProviderIdentifier];
             self.creds = credential;
             [self authorizedOp:op onSuccess:success onFailure:failure retry:NO];
         }
         failure:^(NSError *error) {
             failure(@"Failed to authorize");
         }];
    }
    else {
        failure(@"Application is not authorized");
    }
}

- (void)initConfigurationFrom: (NSDictionary *)config {
    self.auth_path = [config objectForKey:@"auth_path"];
    self.token_path = [config objectForKey:@"token_path"];
    NSString *callback_str = [config objectForKey:@"callback_url"];
    self.callback_url = callback_str ? [NSURL URLWithString:callback_str] : nil;
    NSString * base_str = [config objectForKey:@"base_url"];
    self.base_url = base_str ? [NSURL URLWithString:base_str] : nil;
    self.client_key = [config objectForKey:@"client_key"];
    self.client_secret = [config objectForKey:@"client_secret"];
}

- (NSDictionary *)readDictionaryFromConfig: (NSString *)configPath
{
    NSString *errorDesc = nil;
    NSData *configXML = [[NSFileManager defaultManager] contentsAtPath:configPath];
    NSDictionary *config = (NSDictionary *)[NSPropertyListSerialization
                                            propertyListFromData:configXML
                                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                            format:NULL
                                            errorDescription:&errorDesc];
    if (!config) {
        NSLog(@"OACSAuthClient error reading config %@ is '%@'", configPath, errorDesc);
    }
    return config;
}

@end
