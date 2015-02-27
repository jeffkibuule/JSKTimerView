//
//  JSKViewController.m
//  JSKTimerView
//
//  Created by Joefrey Kibuule on 02/04/2015.
//  Copyright (c) 2014 Joefrey Kibuule. All rights reserved.
//

#import "JSKViewController.h"

@interface JSKViewController ()

@property (weak, nonatomic) IBOutlet JSKTimerView *timerView;

@end

@implementation JSKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set timer's delegate to this view controller
    self.timerView.delegate = self;
    
    // Start timer
    [self.timerView startTimerWithDuration:60];
    
    
    // Pause timer after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Pausing timer");
        [self.timerView pauseTimer];
    });
    
    
    // Start timer again after 15 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Starting timer");
        [self.timerView startTimer];
    });
    
    
    // Stop timer after 20 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Stopping timer");
        [self.timerView stopTimer];
    });
    
    
    // Reset timer back to original value after 25 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Resetting timer");
        [self.timerView resetTimer];
    });
    
    
    // Restart timer after 30 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Restarting timer");
        [self.timerView restartTimer];
    });
}

#pragma mark - JSK Timer View Delegate 

- (void)timerDidFinish:(JSKTimerView *)timerView {
    // Show an alert when timer finishes
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Timer finished!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    
    NSLog(@"Timer finished!");
}



@end
