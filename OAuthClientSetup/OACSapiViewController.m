//
//  OACSapiViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSapiViewController.h"

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
    [self.client authorizedGet:@"api/v1/me.json" parameters:nil
                     onSuccess:^(NSDictionary *response) {
                         [self.workinOnIt stopAnimating];
                         [self.meButton setEnabled:YES];
                         [self.resultText setText:[response description]];
                     } onFailure:^(NSString *localizedDescription) {
                         [self.workinOnIt stopAnimating];
                         [self.meButton setEnabled:YES];
                         [self.resultText setText:localizedDescription];
                     }];
}

- (IBAction)sendProfilesRequest
{
    [self.profilesButton setEnabled:NO];
    [self.workinOnIt startAnimating];
    [self.client authorizedGet:@"api/v1/profiles.json" parameters:nil
                     onSuccess:^(NSDictionary *response) {
                         [self.workinOnIt stopAnimating];
                         [self.profilesButton setEnabled:YES];
                         NSArray *profiles = (NSArray *)response;
                         NSString *showProfiles = [NSString stringWithFormat:@"%d profiles.  First is %@", profiles.count, profiles[0]];
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
