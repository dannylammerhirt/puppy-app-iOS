//
//  ViewController.m
//  OpenPuppies
//
//  Created by Dylan Peters on 7/16/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize movieController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //NSURL *url=[NSURL fileURLWithPath:@""];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    NSURL *movieURL = [NSURL URLWithString:@"http://www.openpuppies.com/mp4/HblQhgb.mp4"];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    //[self.view addSubview:movieController.view];
    [self presentMoviePlayerViewControllerAnimated:movieController];
    //[self presentViewController:movieController animated:true completion:nil];
    [movieController.moviePlayer play];
}

/*
 
 @synthesize movieController;
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
 //NSURL *url=[NSURL fileURLWithPath:@""];
 
 NSURL *movieURL = [NSURL URLWithString:@"http://www.openpuppies.com/mp4/HblQhgb.mp4"];
 movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
 [self.view addSubview:movieController.view];
 [self presentMoviePlayerViewControllerAnimated:movieController];
 [movieController.moviePlayer play];
 }
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
