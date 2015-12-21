//
//  ViewController.m
//  Diagnosis
//
//  Created by MarkChang on 2015/12/20.
//  Copyright © 2015年 MarkChang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *PlentyComputingIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *GetWebHTMLIndicator;

@end

@implementation ViewController

NSString *StopPlentyComputing = @"Stop Plenty Computing";

- (void)setStandardUserDefaultsBoolValue:(BOOL)v forkey:(NSString *)k {
    [[NSUserDefaults standardUserDefaults] setBool:v forKey:k];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getStandardUserDefaultsBoolForkey:(NSString *)k {
    return [[NSUserDefaults standardUserDefaults] boolForKey:k];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setStandardUserDefaultsBoolValue:NO forkey:StopPlentyComputing];
    [self.PlentyComputingIndicator setHidesWhenStopped:YES];
    [self.GetWebHTMLIndicator setHidesWhenStopped:YES];
}

- (IBAction)PlentyComputing:(UIButton *)sender {
    
    if ([[sender currentTitle] isEqualToString:@"Plenty Computing"]) {
        [sender setTitle:@"Stop Plenty Computing" forState:UIControlStateNormal];
        [self.PlentyComputingIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (![self getStandardUserDefaultsBoolForkey:StopPlentyComputing]) {
                NSLog(@"Plenty Computing...");
            }
            
            [self setStandardUserDefaultsBoolValue:NO forkey:StopPlentyComputing];
        });
    }
    else if ([[sender currentTitle] isEqualToString:@"Stop Plenty Computing"]) {
        [sender setTitle:@"Plenty Computing" forState:UIControlStateNormal];
        [self.PlentyComputingIndicator stopAnimating];
        
        [self setStandardUserDefaultsBoolValue:YES forkey:StopPlentyComputing];
    }
}

- (IBAction)GetWebHTML:(UIButton *)sender {
    
    [self.GetWebHTMLIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *myURL = [NSURL URLWithString:@"https://tw.yahoo.com/"];
        
        NSError *error = nil;
        NSString *myHTMLString = [NSString stringWithContentsOfURL:myURL encoding: NSUTF8StringEncoding error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                NSLog(@"Error : %@", error);
            }
            else {
                NSLog(@"HTML : %@", myHTMLString);
            }
            [self.GetWebHTMLIndicator stopAnimating];
        });
    });
}

@end
