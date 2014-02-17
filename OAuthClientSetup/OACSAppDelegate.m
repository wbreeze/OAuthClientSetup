//
//  OACSAppDelegate.m
//  OAuthClientSetup
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

#import "OACSAppDelegate.h"
#import "PDDebugger.h"

@implementation OACSAppDelegate

#if DEBUG
// Pony Debugger instruments application network traffic monitoring
// via Pony server, both from the people at Square
- (void)configureDebug {
    PDDebugger * debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
}
#endif

// credentials archived in user space application support directory
- (NSString *)applicationCredentialFilePath {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* credURL = nil;
    if ([possibleURLs count] >= 1) {
        // Use the first directory (if multiple are returned)
        NSURL *appSupportDir = [possibleURLs objectAtIndex:0];
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSURL *appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
        NSError *cdError;
        [sharedFM createDirectoryAtURL:appDirectory withIntermediateDirectories:YES attributes:nil error:&cdError];
        if (cdError) {
            NSLog(@"Failed to create directory, %@", appDirectory);
        }
        credURL = [appDirectory URLByAppendingPathComponent:@"obiwan.data"];
    }

    return [credURL path];
}

// configuration is in the bundle
- (NSString *)configurationFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"oauth_setup" ofType:@"plist"];
}

#pragma mark AppDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.client = [[OACSAuthClient alloc] initWithConfigurationAt:[self configurationFilePath] archiveAt:[self applicationCredentialFilePath]];
    UITabBarController *tabsController = (UITabBarController *)self.window.rootViewController;
    NSArray *tabViews = tabsController.childViewControllers;
    for (NSUInteger i = 0; i < tabViews.count; ++i) {
        NSObject <OACSAuthClientConsumer> *childView = tabViews[i];
        [childView setAuthClient:self.client];
    }
#if DEBUG
    [self configureDebug];
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.client archiveTo:[self applicationCredentialFilePath]];
    self.client = nil;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.client = [[OACSAuthClient alloc] initWithConfigurationAt:[self configurationFilePath] archiveAt:[self applicationCredentialFilePath]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
