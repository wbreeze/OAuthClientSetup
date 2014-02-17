//
//  OACSConfigureViewController.m
//  
//
//  Created by Douglas Lovell on 1/18/14.
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

/*
https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
*/
#import "OACSConfigureViewController.h"
#import "OACSConnectViewController.h"
#import "OACSAuthorizedViewController.h"

@interface OACSConfigureViewController ()

@property (weak, nonatomic) OACSConnectViewController *connectVC;
@property (weak, nonatomic) OACSAuthorizedViewController *authorizedVC;
@property (weak, nonatomic) OACSAuthClient *client;

@end

@implementation OACSConfigureViewController

- (OACSConnectViewController *)connectVC {
    if (_connectVC == nil) {
        UIStoryboard *storyboard = self.storyboard;
        _connectVC = [storyboard instantiateViewControllerWithIdentifier:@"OACSConnectViewController"];
        _connectVC.client = self.client;
    }
    return _connectVC;
}

- (OACSAuthorizedViewController *)authorizedVC {
    if (_authorizedVC == nil) {
        UIStoryboard *storyboard = self.storyboard;
        _authorizedVC = [storyboard instantiateViewControllerWithIdentifier:@"OACSAuthorizedViewController"];
        _authorizedVC.client = self.client;
    }
    return _authorizedVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.client.creds && self.client.oauthClient) {
        OACSAuthorizedViewController *avc = self.authorizedVC;
        [self addChildViewController:avc];
        [self.view addSubview:avc.view];
        [avc didMoveToParentViewController:self];
    }
    else if (self.client.oauthClient && self.client.auth_path && self.client.token_path && self.client.callback_url) {
        OACSConnectViewController *cvc = self.connectVC;
        [self addChildViewController:cvc];
        [self.view addSubview:cvc.view];
        [cvc didMoveToParentViewController:self];
    }
}

- (void)didConnect
{
    [self transitionFrom:self.connectVC To:self.authorizedVC];
}

- (void)didReset
{
    [self transitionFrom:self.authorizedVC To:self.connectVC];
}

- (void)transitionFrom:(UIViewController *)oldC To:(UIViewController *)newC
{
    [oldC willMoveToParentViewController:nil];
    [self addChildViewController:newC];
    [self transitionFromViewController: oldC toViewController: newC
                              duration: 0.25 options:0
                            animations: nil
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];
                                [newC didMoveToParentViewController:self];
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark OACSAuthClientConsumer

- (void)setAuthClient: (OACSAuthClient *)client {
    self.client = client;
}

@end
