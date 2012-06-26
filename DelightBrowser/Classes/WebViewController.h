//
//  WebViewController.h
//  DelightBrowser
//
//  Created by Chris Haugli on 6/19/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrowserSession;

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) BrowserSession *browserSession;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *floatingTasksButton;

- (id)initWithBrowserSession:(BrowserSession *)browserSession;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forwardButtonPressed:(id)sender;
- (IBAction)reloadButtonPressed:(id)sender;
- (IBAction)tasksButtonPressed:(id)sender;

@end
