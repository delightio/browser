//
//  AppDelegate.m
//  DelightBrowser
//
//  Created by Chris Haugli on 6/19/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "PINViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PINViewController *pinController = [[PINViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pinController];
    navigationController.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
