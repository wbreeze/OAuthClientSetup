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

@end
