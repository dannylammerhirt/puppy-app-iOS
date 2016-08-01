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
#import "SavingActivityView.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (strong, atomic) NSArray *strings;
@property SavingActivityView *indicator;

@end

@implementation ViewController

NSURL *currentURL;
NSString *currentString;
@synthesize strings;
@synthesize indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    strings = [(AppDelegate *)[[UIApplication sharedApplication] delegate] strings];
    NSURL *movieURL = [self nextURL];
    [self.moviePlayer setContentURL:movieURL];
    
    [self.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(didTapOnView:)];
    [tap setDelegate:self];
    [self.moviePlayer.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressOnView:)];
    longPress.delegate = self;
    [self.moviePlayer.view addGestureRecognizer:longPress];
    
    
    [tap requireGestureRecognizerToFail:longPress];
    
    [self.moviePlayer play];
    
    indicator = [[SavingActivityView alloc] init];
    [self.moviePlayer.view addSubview:indicator];
    [self applyConstraints];
    [self.moviePlayer.view bringSubviewToFront:indicator];
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void) applyConstraints{
    [self.moviePlayer.view setTranslatesAutoresizingMaskIntoConstraints:false];
    [indicator setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.moviePlayer.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.moviePlayer.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self.moviePlayer.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.moviePlayer.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.moviePlayer.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.moviePlayer.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.moviePlayer.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.moviePlayer.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void) didTapOnView:(UITapGestureRecognizer *)sender{
        
        NSURL *url = [self nextURL];
        [self.moviePlayer setContentURL:url];
        [self.moviePlayer play];
    
    if (arc4random()%2==1){
        
        [indicator setBackgroundColor:[UIColor clearColor]];
    } else {
        [indicator setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];

    }
    
    
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
        
        [self presentViewController:alert animated:YES completion:nil];
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
        [self presentViewController:alert animated:true completion:nil];
    }
    
    [indicator beginSaving];
    
    NSURL *sourceURL = currentURL;
    NSURLRequest *request = [NSURLRequest requestWithURL:sourceURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[sourceURL lastPathComponent]];
        [data writeToURL:tempURL atomically:YES];
        UISaveVideoAtPathToSavedPhotosAlbum(tempURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [indicator successSaving];
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
