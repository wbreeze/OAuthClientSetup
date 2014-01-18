//
//  OACSConnectViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/16/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSConnectViewController.h"

@interface OACSConnectViewController ()
@property (atomic) BOOL isAuthenticated;
@property (atomic) BOOL isConfigured;
@end

@implementation OACSConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isConfigured = NO;
        self.isAuthenticated = NO;
    }
    return self;
}

- (BOOL)doesHaveAuthentication
{
    return self.isAuthenticated;
}

- (BOOL)doesHaveConfiguration
{
    return self.isConfigured;
}

- (void)loadView
{
    UIView *configureView = nil;
    if ([self doesHaveAuthentication])
    {
        configureView = [[NSBundle mainBundle] loadNibNamed:@"AuthorizedView" owner:self options:nil][0];
    }
    else if ([self doesHaveConfiguration]) {
        configureView = [[NSBundle mainBundle] loadNibNamed:@"ConnectView" owner:self options:nil][0];
    }
    else {
        configureView = [[NSBundle mainBundle] loadNibNamed:@"ConfigureView" owner:self options:nil][0];
    }
    self.view = configureView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendGrantRequest
{
    self.isAuthenticated = YES;
    [self loadView];
}

- (IBAction)resignAuthentication
{
    self.isAuthenticated = NO;
    [self loadView];
}


@end
