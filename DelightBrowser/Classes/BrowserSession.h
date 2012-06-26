//
//  BrowserSession.h
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrowserSession : NSObject

@property (assign, nonatomic) NSInteger sessionID;
@property (strong, nonatomic) NSString *appToken;
@property (assign, nonatomic) NSInteger annotationMode;
@property (assign, nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;
@property (assign, nonatomic, getter=isPrototypeApp) BOOL prototypeApp;
@property (strong, nonatomic) NSURL *URL;
@property (strong, nonatomic) NSArray *tasks;

- (id)initWithJSONData:(NSData *)data;

@end
