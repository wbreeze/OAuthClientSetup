//
//  OACSConnectViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSAuthorizedViewController.h"
#import "OACSConfigureViewController.h"
#import "AFOAuth2Client.h"
#import "OACSNetStatusHelper.h"

@interface OACSAuthorizedViewController ()
@property (strong) OACSNetStatusHelper *statusHelper;
@end

@implementation OACSAuthorizedViewController

- (IBAction)resignAuthentication:(id)sender
{
    [self.client.oauthClient clearAuthorizationHeader];
    [(OACSConfigureViewController *)self.parentViewController didReset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusHelper = [[OACSNetStatusHelper new] initWithLabel:self.authNetLabel
                                                  statusCallback:^(BOOL status){}];
    [self.client observeNetworkAvailabilityChanges:self.statusHelper];
    [self.statusHelper updateStatus:[self.client networkAvailable]];
}

@end
