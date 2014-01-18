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
@property (atomic) NSURL *auth_url;
@property (atomic) NSURL *token_url;
@property (atomic) NSURL *callback_url;
@property (atomic) NSString *client_key;
@property (atomic) NSString *client_secret;
@end

@implementation OACSConnectViewController

- (id)initWithConfiguration: (NSDictionary *)configData {
    self = [super init];
    if (self) {
        self.isConfigured = NO;
        if (configData) {
            self.isConfigured = [self initConfigurationFrom:configData];
        }
        self.isAuthenticated = NO;
    }
    return self;
}

- (BOOL)initConfigurationFrom: (NSDictionary *)config {
        self.auth_url = [self urlFor:[config objectForKey:@"auth_url"]];
        self.token_url = [self urlFor:[config objectForKey:@"token_url"]];
        self.callback_url = [self urlFor:[config objectForKey:@"callback_url"]];
        self.client_key = [config objectForKey:@"client_key"];
        self.client_secret = [config objectForKey:@"client_secret"];

    return self.auth_url && self.token_url && self.callback_url && self.client_key && self.client_secret;
}

- (NSURL *)urlFor: (NSString *)urlString
{
    return urlString ? [[NSURL alloc] initFileURLWithPath:urlString] : nil;
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
