//
//  ViewController.m
//  OpenPuppies
//
//  Created by Dylan Peters on 7/16/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <UIGestureRecognizerDelegate>

@property (strong, atomic) NSArray *strings;

@end

@implementation ViewController

NSURL *currentURL;
NSString *currentString;

@synthesize movieController;
@synthesize strings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //NSURL *url=[NSURL fileURLWithPath:@""];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void) viewDidAppear:(BOOL)animated {
    strings = [(AppDelegate *)[[UIApplication sharedApplication] delegate] strings];
    NSLog(@"view did apear");
    NSURL *movieURL = [self nextURL];
    //NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"HblQhgb" ofType:@"mp4"]];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    
    [movieController.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [movieController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView:)];
    [tap setDelegate:self];
    
    [movieController.moviePlayer.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressOnView:)];
    [longPress setDelegate:self];
    
    [movieController.moviePlayer.view addGestureRecognizer:longPress];*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(didTapOnView:)];
    [tap setDelegate:self];
    [movieController.moviePlayer.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressOnView:)];
    longPress.delegate = self;
    [movieController.moviePlayer.view addGestureRecognizer:longPress];
    
    
    [tap requireGestureRecognizerToFail:longPress];
    
    //[self.view addSubview:movieController.view];
    [self presentMoviePlayerViewControllerAnimated:movieController];
    //[self presentViewController:movieController animated:true completion:nil];
    [movieController.moviePlayer play];
}

- (void) didTapOnView:(UITapGestureRecognizer *)sender{
        
        NSURL *url = [self nextURL];
        [movieController.moviePlayer setContentURL:url];
        [movieController.moviePlayer play];
}

- (NSURL *) nextURL {
    NSString *string = @"http://openpuppies.com/mp4/";
    u_int32_t index = arc4random()%[strings count];
    string = [string stringByAppendingString:[strings objectAtIndex:index]];
    string = [string stringByAppendingString:@".mp4"];
    currentString=[strings objectAtIndex:index];
    currentURL = [NSURL URLWithString:string];
    return currentURL;
}

- (void) didLongPressOnView:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"long");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NULL message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Save To Camera Roll" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self save];}];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        
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

- (void) save {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status != ALAuthorizationStatusAuthorized && status != ALAuthorizationStatusNotDetermined){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could Not Save Video" message:@"Please allow the app permission to access your photos in order to save videos." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:cancel];
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (&UIApplicationOpenSettingsURLString != NULL) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
            else {
                // Present some dialog telling the user to open the settings app.
            }
            //button clicked
        }];
        [alert addAction:settings];
        [movieController presentViewController:alert animated:true completion:nil];
    }
    NSURL *sourceURL = currentURL;
    NSURLRequest *request = [NSURLRequest requestWithURL:sourceURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[sourceURL lastPathComponent]];
        [data writeToURL:tempURL atomically:YES];
        UISaveVideoAtPathToSavedPhotosAlbum(tempURL.path, nil, NULL, NULL);
    }];
//    // I am using simple way to download the video, You can use according to you.
//    NSURL *url = currentURL;
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    // Write it to cache directory
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:currentString];
//    [data writeToFile:path atomically:YES];
//    
//    
//    // After that use this path to save it to PhotoLibrary
//    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path] completionBlock:^(NSURL *assetURL, NSError *error) {
//        
//        if (error) {
//            NSLog(@"%@", error.description);
//        }else {
//            NSLog(@"Done :)");
//        }
//        
//    }];
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
    return true;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}



@end
