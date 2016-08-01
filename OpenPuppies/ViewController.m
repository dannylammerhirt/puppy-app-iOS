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
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void) viewDidAppear:(BOOL)animated {
    strings = [(AppDelegate *)[[UIApplication sharedApplication] delegate] strings];
    NSURL *movieURL = [self nextURL];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    
    [movieController.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [movieController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(didTapOnView:)];
    [tap setDelegate:self];
    [movieController.moviePlayer.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressOnView:)];
    longPress.delegate = self;
    [movieController.moviePlayer.view addGestureRecognizer:longPress];
    
    
    [tap requireGestureRecognizerToFail:longPress];
    [self presentMoviePlayerViewControllerAnimated:movieController];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NULL message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Save To Camera Roll" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self save];}];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        
        [movieController presentViewController:alert animated:YES completion:nil];
    }
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
}


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
