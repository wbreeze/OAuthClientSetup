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
        [self.errorLabel setHidden:YES];
        [self.workinOnIt startAnimating];
        [self.client authorizeUser:email password:pwd
         onSuccess:^() {
             [self.workinOnIt stopAnimating];
             [self.connectButton setEnabled:YES];
             [(OACSConfigureViewController *)self.parentViewController didConnect];
         }
         onFailure:^(NSString *localizedErrorDescription) {
             self.errorLabel.text = localizedErrorDescription;
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
                                                  statusCallback:^(BOOL isEnabled){
                                                      [self.connectButton setEnabled:isEnabled];
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
