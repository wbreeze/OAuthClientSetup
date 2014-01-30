//
//  OACSConfigureViewController.m
//  
//
//  Created by Douglas Lovell on 1/18/14.
//
/*
https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
*/
#import "OACSConfigureViewController.h"
#import "OACSConnectViewController.h"
#import "OACSAuthorizedViewController.h"
#import "OACSAppDelegate.h"

@interface OACSConfigureViewController ()

@property (weak, nonatomic) OACSConnectViewController *connectVC;
@property (weak, nonatomic) OACSAuthorizedViewController *authorizedVC;

@end

@implementation OACSConfigureViewController

- (OACSConnectViewController *)connectVC {
    if (_connectVC == nil) {
        UIStoryboard *storyboard = self.storyboard;
        _connectVC = [storyboard instantiateViewControllerWithIdentifier:@"OACSConnectViewController"];
    }
    return _connectVC;
}

- (OACSAuthorizedViewController *)authorizedVC {
    if (_authorizedVC == nil) {
        UIStoryboard *storyboard = self.storyboard;
        _authorizedVC = [storyboard instantiateViewControllerWithIdentifier:@"OACSAuthorizedViewController"];
    }
    return _authorizedVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    OACSAppDelegate *app = (OACSAppDelegate *)([UIApplication sharedApplication].delegate);
    if (app.creds && app.oauthClient) {
        OACSAuthorizedViewController *avc = self.authorizedVC;
        [self addChildViewController:avc];
        [self.view addSubview:avc.view];
        [avc didMoveToParentViewController:self];
    }
    else if (app.oauthClient && app.auth_path && app.token_path && app.callback_url) {
        OACSConnectViewController *cvc = self.connectVC;
        [self addChildViewController:cvc];
        [self.view addSubview:cvc.view];
        [cvc didMoveToParentViewController:self];
    }
}

- (void)didConnect
{
    [self transitionFrom:self.connectVC To:self.authorizedVC];
}

- (void)didReset
{
    [self transitionFrom:self.authorizedVC To:self.connectVC];
}

- (void)transitionFrom:(UIViewController *)oldC To:(UIViewController *)newC
{
    [oldC willMoveToParentViewController:nil];
    [self addChildViewController:newC];
    [self transitionFromViewController: oldC toViewController: newC
                              duration: 0.25 options:0
                            animations: nil
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];
                                [newC didMoveToParentViewController:self];
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
