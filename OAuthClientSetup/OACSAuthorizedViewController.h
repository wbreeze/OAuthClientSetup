//
//  OACSConfigureViewController.h
//  
//
//  Created by Douglas Lovell on 1/18/14.
//
//

#import <UIKit/UIKit.h>
#include "OACSAuthClient.h"

@interface OACSAuthorizedViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *authNetLabel;
@property (weak, nonatomic) OACSAuthClient *client;

- (IBAction)resignAuthorization:(id)sender;

@end
