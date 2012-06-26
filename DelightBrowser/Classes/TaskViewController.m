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
@synthesize firstAppearance = _firstAppearance;
@synthesize scrollView = _scrollView;
@synthesize titleLabel = _titleLabel;
@synthesize countLabel = _countLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize actionButtonsView = _actionButtonsView;
@synthesize nextTaskButton = _nextTaskButton;
@synthesize endTestButton = _endTestButton;
@synthesize continueButton = _continueButton;

- (id)initWithTasks:(NSArray *)tasks firstAppearance:(BOOL)firstAppearance
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Tasks";
        self.tasks = tasks;
        self.firstAppearance = firstAppearance;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Find the current task
    for (Task *task in self.tasks) {
        if (task.status != TaskStatusCompleted) {
            currentTaskIndex = [self.tasks indexOfObject:task];
            break;
        }
    }
        
    actionGradient = [CAGradientLayer layer];
    actionGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor, nil];
    actionGradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
    [self.actionButtonsView.layer insertSublayer:actionGradient atIndex:0];
    
    UIImage *normalImage = [[UIImage imageNamed:@"button_rounded.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 3, 9, 3)];
    UIImage *pressedImage = [[UIImage imageNamed:@"button_rounded_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 3, 9, 3)];
    [self.nextTaskButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.nextTaskButton setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [self.endTestButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.endTestButton setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [self.continueButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.continueButton setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    if (self.firstAppearance) {
        [self showStartButtonAnimated:NO];
    }
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
    self.endTestButton = nil;
    self.continueButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    [self updateViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateViews];
}

#pragma mark - Actions

- (IBAction)nextTaskButtonPressed:(id)sender
{
    Task *completedTask = [self.tasks objectAtIndex:currentTaskIndex];
    completedTask.status = TaskStatusCompleted;
    
    currentTaskIndex++;
    [self showStartButtonAnimated:YES];
}

- (IBAction)endTestButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"End Test" message:@"Are you sure you want to end the test?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Test", nil];
    [alertView show];
}

- (IBAction)continueButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private methods

- (void)updateViews
{
    // Update the text for the current task
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
    
    // Show next task button if there is a next task, otherwise end test
    self.nextTaskButton.hidden = (currentTaskIndex >= [self.tasks count] - 1) || self.firstAppearance;
    self.endTestButton.hidden = !self.nextTaskButton.hidden || self.firstAppearance;
    
    // Make sure gradient size matches up with its superview
    actionGradient.frame = self.actionButtonsView.bounds;
}

- (void)showStartButtonAnimated:(BOOL)animated
{
    // Show "Start" rather than "Continue" and hide the next task button
    CGFloat buttonsHeightDecrease = CGRectGetMaxY(self.continueButton.frame) - CGRectGetMaxY(self.nextTaskButton.frame);
    CGRect newActionButtonsFrame = CGRectMake(self.actionButtonsView.frame.origin.x, self.actionButtonsView.frame.origin.y + buttonsHeightDecrease, 
                                              self.actionButtonsView.frame.size.width, self.actionButtonsView.frame.size.height - buttonsHeightDecrease);
    
    void (^animations)(void) = ^{
        self.actionButtonsView.frame = newActionButtonsFrame;        
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        [self updateViews];
        self.nextTaskButton.hidden = YES;
        self.endTestButton.hidden = YES;
        self.continueButton.frame = self.nextTaskButton.frame;
        [self.continueButton setTitle:@"Start" forState:UIControlStateNormal];
    };

    if (animated) {
        [UIView animateWithDuration:0.25 
                         animations:^{
                             self.actionButtonsView.frame = CGRectMake(self.actionButtonsView.frame.origin.x, CGRectGetMaxY(self.actionButtonsView.frame),
                                                                       self.actionButtonsView.frame.size.width, self.actionButtonsView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             completion(finished);
                             [UIView animateWithDuration:0.25 animations:animations];
                         }];
    } else {
        animations();
        completion(YES);
    }
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
