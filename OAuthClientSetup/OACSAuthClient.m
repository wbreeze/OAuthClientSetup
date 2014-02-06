//
//  OACSAuthClient.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 2/5/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSAuthClient.h"

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
 */
- (AFHTTPClient *)httpClient {
    if (_httpClient == nil && self.base_url) {
        _httpClient = [AFHTTPClient clientWithBaseURL:self.base_url];
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

- (void)observeNetworkAvailabilityChanges: (NSObject *)observer {
    [self.httpClient addObserver:observer
                      forKeyPath:@"networkReachabilityStatus"
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
}

- (AFNetworkReachabilityStatus) networkAvailable {
    return [self.httpClient networkReachabilityStatus];
}

#pragma mark private

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
        NSLog(@"OACSAuthClient error reading config is '%@'", errorDesc);
    }
    return config;
}

@end
