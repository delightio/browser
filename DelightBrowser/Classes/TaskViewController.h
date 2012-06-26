//
//  TaskViewController.h
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskViewController : UIViewController <UIAlertViewDelegate> {
    NSUInteger currentTaskIndex;
    CAGradientLayer *actionGradient;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *actionButtonsView;
@property (strong, nonatomic) IBOutlet UIButton *nextTaskButton;
@property (strong, nonatomic) NSArray *tasks;

- (id)initWithTasks:(NSArray *)tasks;
- (IBAction)nextTaskButtonPressed:(id)sender;
- (IBAction)endTestButtonPressed:(id)sender;

@end
