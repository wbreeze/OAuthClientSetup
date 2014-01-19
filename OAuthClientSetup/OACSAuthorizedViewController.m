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

@interface OACSAuthorizedViewController ()
@end

@implementation OACSAuthorizedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resignAuthentication:(id)sender
{
    [(OACSConfigureViewController *)self.parentViewController didReset];
}

@end
