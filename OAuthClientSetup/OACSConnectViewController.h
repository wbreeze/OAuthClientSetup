//
//  OACSConnectViewController.h
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

#import <UIKit/UIKit.h>
#import "OACSAuthClient.h"

@interface OACSConnectViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *userName;
@property (nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic) IBOutlet UIActivityIndicatorView *workinOnIt;
@property (nonatomic) IBOutlet UILabel *connectNetLabel;
@property (weak, nonatomic) OACSAuthClient *client;

- (IBAction)sendGrantRequest;

@end
