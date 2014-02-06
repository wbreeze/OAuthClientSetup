//
//  OACSConfigureViewController.h
//  
//
//  Created by Douglas Lovell on 1/18/14.
//
//

#import <UIKit/UIKit.h>
#import "OACSAuthClient.h"

@interface OACSConfigureViewController : UIViewController <OACSAuthClientConsumer>

- (void)didConnect;
- (void)didReset;

@end
