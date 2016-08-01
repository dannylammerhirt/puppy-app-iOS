//
//  SavingActivityView.m
//  OpenPuppies
//
//  Created by Dylan Peters on 7/31/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SavingActivityView.h"

@interface SavingActivityView ()

@property UIActivityIndicatorView *indicator;
@property UILabel *label;

@end

@implementation SavingActivityView

@synthesize indicator;
@synthesize label;

- (id) init {
    self = [super init];
    if (self){
        indicator = [[UIActivityIndicatorView alloc] init];
        label = [[UILabel alloc] init];
        
        [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
        
        [indicator setColor:[UIColor whiteColor]];
        [indicator setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        
        [indicator setContentMode:UIViewContentModeCenter];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setContentMode:UIViewContentModeCenter];
        
        [self addSubview:indicator];
        [self addSubview:label];
        [self applyConstraints];
        
        [self setAlpha:0.0];
    }
    return self;
}

- (void) applyConstraints{
    [self setTranslatesAutoresizingMaskIntoConstraints:false];
    [indicator setTranslatesAutoresizingMaskIntoConstraints:false];
    [label setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //set size
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void) setText:(NSString *)text{
    [label setText:text];
}

- (void) startAnimating{
    [indicator startAnimating];
}

- (void) stopAnimating{
    [indicator stopAnimating];
}

- (void) beginSaving{
    [label setText:@"Saving"];
    [indicator startAnimating];
    [self setAlpha:1.0];
}

- (void) successSaving{
    [label setText:@"Saved Successfully!"];
    [indicator stopAnimating];
    [self performSelector:@selector(makeAlphaZero) withObject:nil afterDelay:0.5];
}

- (void) makeAlphaZero{
    [self setAlpha:0.0];
}



@end