//
//  OACSConfigureViewController.h
//  
//
//  Created by Douglas Lovell on 1/18/14.
//
//

#import <UIKit/UIKit.h>

@interface OACSAuthorizedViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *authNetLabel;

- (IBAction)resignAuthentication:(id)sender;

@end
