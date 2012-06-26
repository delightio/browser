//
//  BrowserSession.m
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "BrowserSession.h"
#import "Task.h"
#import "JSONKit.h"

@implementation BrowserSession

@synthesize sessionID = _sessionID;
@synthesize appToken = _appToken;
@synthesize annotationMode = _annotationMode;
@synthesize statusBarHidden = _statusBarHidden;
@synthesize URL = _URL;
@synthesize tasks = _tasks;

- (id)initWithJSONData:(NSData *)data
{
    self = [super init];
    if (self) {
        NSDictionary *sessionDict = [data objectFromJSONData];
        self.sessionID = [[sessionDict objectForKey:@"id"] integerValue];
        self.appToken = [sessionDict objectForKey:@"appToken"];
        self.annotationMode = [[sessionDict objectForKey:@"annotation"] integerValue];
        self.statusBarHidden = [[sessionDict objectForKey:@"statusBarHidden"] boolValue];
        self.URL = [NSURL URLWithString:[sessionDict objectForKey:@"url"]];
        
        NSMutableArray *tasksArray = [NSMutableArray array];
        for (NSDictionary *taskDict in [sessionDict objectForKey:@"tasks"]) {
            Task *task = [[Task alloc] initWithDictionary:taskDict];
            [tasksArray addObject:task];
        }
        self.tasks = tasksArray;
    }
    return self;
}

@end
