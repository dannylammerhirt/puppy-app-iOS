//
//  SavingActivityView.h
//  OpenPuppies
//
//  Created by Dylan Peters on 7/31/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavingActivityView : UIView

- (void) setText:(NSString *)text;
- (void) startAnimating;
- (void) stopAnimating;

- (void) beginSaving;
- (void) successSaving;

@end