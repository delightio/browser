//
//  Task.h
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TaskStatusNew = 0,
    TaskStatusInProgress = 1,
    TaskStatusCompleted = 2
} TaskStatus;

@interface Task : NSObject

@property (assign, nonatomic) NSInteger taskID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (assign, nonatomic) TaskStatus status;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
