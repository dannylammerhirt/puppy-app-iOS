//
//  ViewController.m
//  OpenPuppies
//
//  Created by Dylan Peters on 7/16/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController

bool shouldAllowTouch;

@synthesize movieController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //NSURL *url=[NSURL fileURLWithPath:@""];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    NSURL *movieURL = [NSURL URLWithString:@"http://www.openpuppies.com/mp4/HblQhgb.mp4"];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    
    [movieController.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [movieController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    shouldAllowTouch = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView:)];
    [tap setDelegate:self];
    
    [movieController.moviePlayer.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressOnView:)];
    [longPress setDelegate:self];
    
    [movieController.moviePlayer.view addGestureRecognizer:longPress];
    
    //[self.view addSubview:movieController.view];
    [self presentMoviePlayerViewControllerAnimated:movieController];
    //[self presentViewController:movieController animated:true completion:nil];
    [movieController.moviePlayer play];
}

- (void) didTapOnView:(UITapGestureRecognizer *)sender{
//    shouldAllowTouch = false;
//    NSLog(@"tap");
//    //shouldAllowTouch = true;
}

- (void) didLongPressOnView:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"long");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NULL message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self click];}];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {[self click];}];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        
        [movieController presentViewController:alert animated:YES completion:nil];
    }
//    shouldAllowTouch = false;
//    NSLog(@"long");
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NULL message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {[self click];}];
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * action) {[self click];}];
//    
//    [alert addAction:defaultAction];
//    [alert addAction:cancelAction];
//    
//    [movieController presentViewController:alert animated:YES completion:nil];
    //shouldAllowTouch = true;
}

- (void) click {
    shouldAllowTouch = true;
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

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return shouldAllowTouch;
}


// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}


@end
