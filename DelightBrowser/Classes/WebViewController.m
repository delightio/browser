//
//  WebViewController.m
//  DelightBrowser
//
//  Created by Chris Haugli on 6/19/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "WebViewController.h"
#import "TaskViewController.h"
#import "BrowserSession.h"
#import <Delight/Delight.h>

@interface Delight (Annotation) 
+ (void)startWithAppToken:(NSString *)appToken annotation:(NSInteger)annotation;
@end

@implementation WebViewController

@synthesize browserSession = _browserSession;
@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize reloadButton = _reloadButton;

- (id)initWithBrowserSession:(BrowserSession *)browserSession
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.browserSession = browserSession;
        
        [Delight setDebugLogEnabled:YES];
        [Delight startWithAppToken:browserSession.appToken annotation:browserSession.annotationMode];
    }
    return self;    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.browserSession.URL];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.webView = nil;
    self.toolbar = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.reloadButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateToolbar
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

#pragma mark - IBActions

- (IBAction)backButtonPressed:(id)sender
{
    [self.webView goBack];
}

- (IBAction)forwardButtonPressed:(id)sender
{
    [self.webView goForward];
}

- (IBAction)reloadButtonPressed:(id)sender
{
    [self.webView reload];
}

- (IBAction)tasksButtonPressed:(id)sender
{    
    TaskViewController *taskController = [[TaskViewController alloc] initWithTasks:self.browserSession.tasks];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:taskController];
    navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateToolbar];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateToolbar];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateToolbar];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];    
}

@end
