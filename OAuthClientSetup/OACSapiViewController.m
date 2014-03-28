//
//  OACSapiViewController.m
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

#import "OACSapiViewController.h"
#import "OACSAuthOpAF.h"

@interface OACSapiViewController ()
@property (strong, nonatomic) IBOutlet UIButton *meButton;
@property (strong, nonatomic) IBOutlet UIButton *profilesButton;
@property (strong, nonatomic) IBOutlet UILabel *resultText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *workinOnIt;
@property (weak) OACSAuthClient *client;
@end

@implementation OACSapiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMeRequest
{
    [self.meButton setEnabled:NO];
    [self.workinOnIt startAnimating];
    OACSAuthOpAF *op = [[OACSAuthOpAF alloc] initWithAFHTTPClient:[self.client httpClient]
                                                    requestMethod:@"GET"
                                                          forPath:@"api/v1/me.json"
                                                   withParameters:nil];
    [self.client authorizedOp:op
                    onSuccess:^() {
                        [self.workinOnIt stopAnimating];
                        [self.meButton setEnabled:YES];
                        [self.resultText setText:[op.responseObject description]];
                    }
                    onFailure:^(NSString *localizedDescription) {
                        [self.workinOnIt stopAnimating];
                        [self.meButton setEnabled:YES];
                        [self.resultText setText:localizedDescription];
                    }];
}

- (IBAction)sendProfilesRequest
{
    [self.profilesButton setEnabled:NO];
    [self.workinOnIt startAnimating];
    OACSAuthOpAF *op = [[OACSAuthOpAF alloc] initWithAFHTTPClient:[self.client httpClient]
                                                    requestMethod:@"GET"
                                                          forPath:@"api/v1/profiles.json"
                                                   withParameters:nil];
    [self.client authorizedOp:op
                    onSuccess:^(NSDictionary *response) {
                        [self.workinOnIt stopAnimating];
                        [self.profilesButton setEnabled:YES];
                        NSArray *profiles = (NSArray *)[op responseObject];
                        NSString *showProfiles = [NSString stringWithFormat:@"%lu profiles.  First is %@", (unsigned long)profiles.count, profiles[0]];
                        [self.resultText setText:showProfiles];
                    } onFailure:^(NSString *localizedDescription) {
                        [self.workinOnIt stopAnimating];
                        [self.profilesButton setEnabled:YES];
                        [self.resultText setText:localizedDescription];
                    }];
}

#pragma mark OACSAuthClientConsumer

- (void)setAuthClient: (OACSAuthClient *)client {
    self.client = client;
}

@end
