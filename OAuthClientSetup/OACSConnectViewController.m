//
//  OACSConnectViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSConnectViewController.h"

@interface OACSConnectViewController ()
@property (strong, nonatomic) UILabel *myLabel;
@end

@implementation OACSConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect labelFrame = CGRectMake(0.0f,
                                   0.0f,
                                   220.0f,
                                   90.0f);
    self.myLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.myLabel.numberOfLines = 5;
    self.myLabel.text = @"Edit file, 'oauth_setup_sample.props', save as 'oauth_setup.props', restart the application.";
    self.myLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.myLabel.center = self.view.center;
    [self.view addSubview:self.myLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
