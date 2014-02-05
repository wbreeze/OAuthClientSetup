//
//  OACSapiViewController.m
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 1/31/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//

#import "OACSapiViewController.h"
#import "OACSAppDelegate.h"
#import "AFHTTPRequestOperation.h"

@interface OACSapiViewController ()
@property (strong, nonatomic) IBOutlet UIButton *meButton;
@property (strong, nonatomic) IBOutlet UIButton *profilesButton;
@property (strong, nonatomic) IBOutlet UILabel *resultText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *workinOnIt;
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
    OACSAppDelegate *app = (OACSAppDelegate *)([UIApplication sharedApplication].delegate);
    AFHTTPClient *client = app.httpClient;
    [client setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", [app.creds accessToken]]];
    [client getPath:@"api/v1/me.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response has %@", responseObject);
        [self.workinOnIt stopAnimating];
        [self.meButton setEnabled:YES];
        [self.resultText setText:[(NSObject *)responseObject description]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"me request failure is %@", error);
        NSHTTPURLResponse *response = operation.response;
        [self.workinOnIt stopAnimating];
        [self.meButton setEnabled:YES];
        NSString *resultText  = [error localizedDescription];
        if (response.statusCode == 401) {
            resultText = @"Failed to authorize";
        }
        [self.resultText setText:resultText];
    }];
}

- (IBAction)sendProfilesRequest
{
    [self.profilesButton setEnabled:NO];
    [self.workinOnIt startAnimating];
}

@end
