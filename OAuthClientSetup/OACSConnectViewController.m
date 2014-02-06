//
//  OACSConnectViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSConnectViewController.h"
#import "OACSConfigureViewController.h"
#import "OACSNetStatusHelper.h"

@interface OACSConnectViewController ()
@property (weak) UITextField *currentTextField;
@property (strong) OACSNetStatusHelper *statusHelper;
@end

@implementation OACSConnectViewController

- (IBAction)sendGrantRequest
{
    if (self.currentTextField) {
        [self.currentTextField resignFirstResponder];
        self.currentTextField = nil;
    }
    [self.connectButton setEnabled:NO];
    NSString *pwd = [self.password text];
    NSString *email = [self.userName text];
    if (pwd && 0 < pwd.length && email && 0 < email.length) {
        // curl -F grant_type=password -F username=user@example.com -F password=doorkeeper http://localhost:3000/oauth/token
        //{"access_token":"43fb...ffad","token_type":"bearer","expires_in":300,"refresh_token":"7ebe...743e","scope":"public"}
        [self.errorLabel setHidden:YES];
        [self.workinOnIt startAnimating];
        [self.client.oauthClient
         authenticateUsingOAuthWithPath:self.client.token_path
         username:email
         password:pwd
         scope:nil
         success:^(AFOAuthCredential *credential) {
             [AFOAuthCredential storeCredential:credential
                                 withIdentifier:self.client.oauthClient.serviceProviderIdentifier];
             self.client.creds = credential;
             [self.workinOnIt stopAnimating];
             [self.connectButton setEnabled:YES];
             [(OACSConfigureViewController *)self.parentViewController didConnect];
         }
         failure:^(NSError *error) {
             NSLog(@"OAuth client authorization error: %@", error);
             self.client.creds = nil;
             [self.client.oauthClient clearAuthorizationHeader];
             self.errorLabel.text = @"Failed to connect using this email and password.";
             [self.errorLabel setHidden:NO];
             [self.workinOnIt stopAnimating];
             [self.connectButton setEnabled:YES];
         }];
    }
    else {
        [self.errorLabel setHidden:NO];
        self.errorLabel.text = @"Supply email and password";
        [self.connectButton setEnabled:YES];
    }
}

#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.errorLabel setHidden:YES];
    [self.password setDelegate:self];
    [self.userName setDelegate:self];
    self.statusHelper = [[OACSNetStatusHelper new] initWithLabel:self.connectNetLabel
                                                  statusCallback:^(BOOL status){
                                                      [self.connectButton setEnabled:status];
                                                  }];
    [self.client observeNetworkAvailabilityChanges:self.statusHelper];
    [self.statusHelper updateStatus:[self.client networkAvailable]];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    self.currentTextField = nil;
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    self.currentTextField = nil;
    [textField resignFirstResponder];
    return YES;
}

@end
