//
//  OACSConnectViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSConnectViewController.h"
#import "OACSConfigureViewController.h"
#import "AFOAuth2Client.h"
#import "OACSAppDelegate.h"

@interface OACSConnectViewController ()
    @property (weak, nonatomic) UITextField *liveTextField;
@end

@implementation OACSConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.errorLabel setHidden:YES];
    [self.password setDelegate:self];
    [self.userName setDelegate:self];
    self.liveTextField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendGrantRequest
{
    if (self.liveTextField) {
        [self.liveTextField resignFirstResponder];
        self.liveTextField = nil;
    }
    [self.connectButton setEnabled:NO];
    NSString *pwd = [self.password text];
    NSString *email = [self.userName text];
    if (pwd && 0 < pwd.length && email && 0 < email.length) {
        [self.errorLabel setHidden:YES];
        [self.workinOnIt startAnimating];
//        OACSAppDelegate *app = (OACSAppDelegate *)([UIApplication sharedApplication].delegate);
//        [app.oauthClient
//         authenticateUsingOAuthWithPath:app.auth_path
//         username:email
//         password:pwd
//         scope:nil
//         success:^(AFOAuthCredential *credential) {
//             [AFOAuthCredential storeCredential:credential
//                                 withIdentifier:app.oauthClient.serviceProviderIdentifier];
//             [self.workinOnIt stopAnimating];
//             [self.connectButton setEnabled:YES];
        [(OACSConfigureViewController *)self.parentViewController didConnect];
//         }
//         failure:^(NSError *error) {
//             NSLog(@"OAuth client authorization error: %@", error);
//             self.errorLabel.text = @"Failed to connect using these credentials.";
//             [self.errorLabel setHidden:NO];
//             [self.workinOnIt stopAnimating];
//             [self.connectButton setEnabled:YES];
//         }];
    }
    else {
        [self.errorLabel setHidden:NO];
        self.errorLabel.text = @"Supply email and password";
        [self.connectButton setEnabled:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.liveTextField = textField;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    self.liveTextField = nil;
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    self.liveTextField = nil;
    [textField resignFirstResponder];
    return YES;
}

@end
