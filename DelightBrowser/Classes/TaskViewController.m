//
//  TaskViewController.m
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
#import <Delight/Delight.h>
#import <QuartzCore/QuartzCore.h>

@implementation TaskViewController

@synthesize tasks = _tasks;
@synthesize scrollView = _scrollView;
@synthesize titleLabel = _titleLabel;
@synthesize countLabel = _countLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize actionButtonsView = _actionButtonsView;
@synthesize nextTaskButton = _nextTaskButton;

- (id)initWithTasks:(NSArray *)tasks
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Tasks";
        self.tasks = tasks;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    
    // Find the current task
    for (Task *task in self.tasks) {
        if (task.status != TaskStatusCompleted) {
            currentTaskIndex = [self.tasks indexOfObject:task];
            break;
        }
    }
    
    [self updateViews];
    
    actionGradient = [CAGradientLayer layer];
    actionGradient.frame = self.actionButtonsView.bounds;
    actionGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor, nil];
    actionGradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
    [self.actionButtonsView.layer insertSublayer:actionGradient atIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.titleLabel = nil;
    self.countLabel = nil;
    self.descriptionLabel = nil;
    self.actionButtonsView = nil;
    self.nextTaskButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    [self updateViews];
}

#pragma mark - Actions

- (void)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)nextTaskButtonPressed:(id)sender
{
    Task *completedTask = [self.tasks objectAtIndex:currentTaskIndex];
    completedTask.status = TaskStatusCompleted;
    
    currentTaskIndex++;
    [self updateViews];
}

- (IBAction)endTestButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"End Test" message:@"Are you sure you want to end the test?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Test", nil];
    [alertView show];
}

#pragma mark - Private methods

- (void)updateViews
{
    // Update the task text
    if (currentTaskIndex < [self.tasks count]) {
        Task *task = [self.tasks objectAtIndex:currentTaskIndex];
        self.titleLabel.text = [task.name uppercaseString];
        self.descriptionLabel.text = task.description;
        self.countLabel.text = [NSString stringWithFormat:@"Task %i of %i", currentTaskIndex + 1, [self.tasks count]];
    }
    
    // Size description label to fit
    CGRect overlyTallFrame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.superview.frame.size.width - 2 * self.descriptionLabel.frame.origin.x, 1000);
    self.descriptionLabel.frame = overlyTallFrame;
    [self.descriptionLabel sizeToFit];
    CGRect frame = self.descriptionLabel.frame;
    frame.size.width = overlyTallFrame.size.width;
    self.descriptionLabel.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, CGRectGetMaxY(frame) + self.titleLabel.frame.origin.y);
    
    self.nextTaskButton.enabled = (currentTaskIndex < [self.tasks count] - 1);
    actionGradient.frame = self.actionButtonsView.bounds;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // End the test
        [Delight stop];

        for (Task *task in self.tasks) {
            task.status = TaskStatusNew;
        }
        [(UINavigationController *) self.navigationController.presentingViewController popToRootViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
