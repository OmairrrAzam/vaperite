//
//  VPAddReviewVC.m
//  vaperite
//
//  Created by Apple on 21/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPAddReviewVC.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface VPAddReviewVC ()<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfSubject;
@property (weak, nonatomic) IBOutlet UITextView *tvReview;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *containerView;



@end

@implementation VPAddReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureInterface{
    CGFloat borderWidth = 0.5f;
    UIColor *borderColor = [UIColor colorWithRed:252/255 green:252/255 blue:252/255 alpha:0.1];
    
    CGPoint bottomOffset = CGPointMake(0, self.containerView.contentSize.height + 50);
    [self.containerView setContentOffset:bottomOffset animated:YES];
    
    self.tfName.delegate    = self;
    self.tfSubject.delegate = self;
        
    self.ratingView.frame = CGRectInset(self.ratingView.frame, -borderWidth, -borderWidth);
    self.ratingView.layer.borderColor = borderColor.CGColor;
    self.ratingView.layer.borderWidth = borderWidth;
    
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    
    self.tvReview.frame = CGRectInset(self.ratingView.frame, -borderWidth, -borderWidth);
    self.tvReview.layer.borderColor = borderColor.CGColor;
    self.tvReview.layer.borderWidth = borderWidth;
    
    //placeholder code
    self.tvReview.delegate = self;
    self.tvReview.text = @"Enter your review...";
    self.tvReview.textColor = [UIColor lightGrayColor];
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.tvReview.text isEqualToString:@"Enter your review..."]) {
        self.tvReview.text = @"";
        self.tvReview.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.tvReview.text isEqualToString:@""]) {
        self.tvReview.text = @"Enter your review...";
        self.tvReview.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)btnSave:(id)sender {
}

- (IBAction)btnBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
