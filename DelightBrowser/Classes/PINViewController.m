//
//  PINViewController.m
//  DelightBrowser
//
//  Created by Chris Haugli on 6/19/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "PINViewController.h"
#import "WebViewController.h"
#import "BrowserSession.h"

@implementation PINViewController

@synthesize pinTextField = _pinTextField;
@synthesize goButton = _goButton;
@synthesize activityIndicator = _activityIndicator;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.pinTextField.frame;
    frame.size.height = self.goButton.frame.size.height - 7;
    self.pinTextField.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.pinTextField = nil;
    self.goButton = nil;
    self.activityIndicator = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pinTextField.text = @"";
    self.goButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pinTextField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - IBActions

- (IBAction)goButtonPressed:(id)sender
{    
    self.goButton.hidden = YES;
    [self.activityIndicator startAnimating];
    [self performSelector:@selector(parseResponse) withObject:nil afterDelay:1.0];
}

- (IBAction)helpButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.delight.io"]];
}

#pragma mark - Private methods

- (void)parseResponse
{
    NSString *filePath = nil;
    if ([self.pinTextField.text isEqualToString:@"1234"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"browser_session" ofType:@"json"];
    } else if ([self.pinTextField.text isEqualToString:@"5678"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"usability_session" ofType:@"json"];
    } else if ([self.pinTextField.text isEqualToString:@"2468"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"prototype_session" ofType:@"json"];
    }
    
    if (filePath) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        BrowserSession *browserSession = [[BrowserSession alloc] initWithJSONData:data];
        
        [[UIApplication sharedApplication] setStatusBarHidden:browserSession.statusBarHidden withAnimation:UIStatusBarAnimationSlide];
        
        WebViewController *webController = [[WebViewController alloc] initWithBrowserSession:browserSession];
        [self.navigationController pushViewController:webController animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid PIN" message:@"Try one of the following:\n\n1234 (screen recording only)\n5678 (screen + camera recording)\n2468 (prototype app demo)" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        self.goButton.hidden = NO;
        self.pinTextField.text = @"";
    }
    
    [self.activityIndicator stopAnimating];
}

@end
