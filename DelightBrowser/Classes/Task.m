//
//  Task.m
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize taskID = _taskID;
@synthesize name = _name;
@synthesize description =_description;
@synthesize status = _status;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.taskID = [[dictionary objectForKey:@"id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.description = [dictionary objectForKey:@"description"];        
        self.status = [[dictionary objectForKey:@"status"] integerValue];
    }
    return self;
}

@end
