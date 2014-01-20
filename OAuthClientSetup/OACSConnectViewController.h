//
//  OACSConnectViewController.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OACSConnectViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *userName;
@property (nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic) IBOutlet UIActivityIndicatorView *workinOnIt;
@property (nonatomic) IBOutlet UILabel *liveLabel;

- (IBAction)sendGrantRequest;

@end
