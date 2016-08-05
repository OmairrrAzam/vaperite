//
//  VPAddReviewVC.m
//  vaperite
//
//  Created by Apple on 21/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPAddReviewVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "VPReviewManager.h"
#import "VPReviewsModel.h"

@interface VPAddReviewVC ()<UITextViewDelegate, UITextFieldDelegate, VPReviewManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfSubject;
@property (weak, nonatomic) IBOutlet UITextView *tvReview;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *containerView;

@property (strong, nonatomic) VPReviewManager *manager;


@end

@implementation VPAddReviewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureInterface];
}

#pragma mark - Private Methods

- (VPReviewsModel *)validate {
    
    NSString *nickName = [self.tfName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *title = [self.tfSubject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *desc = [self.tvReview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (nickName.length == 0) {
        [self showError:@"Please enter your name"];
        return nil;
    }
    
    if (title.length == 0) {
        [self showError:@"Subject is required."];
        return nil;
    }
    
    if (desc.length == 0) {
        [self showError:@"Review is required."];
        return nil;
    }
    
    VPReviewsModel *review = [[VPReviewsModel alloc] init];
    review.nickName   = nickName;
    review.titl       = title;
    review.desc       = desc;
    review.storeId    = self.currentStore.id;
    review.productId  = self.productId;
    review.customerId = self.loggedInUser.customer_id;
    review.rating     = @"20";
    return review;
    
}

- (void)addReview:(VPReviewsModel *)review {
    
    if (!self.manager) {
        self.manager = [[VPReviewManager alloc] init];
        self.manager.delegate = self;
        [self.manager addReview:review];
    }
}

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
    [self startAnimating];
    
    VPReviewsModel *review = [self validate];
    
    if (review) {
        [self addReview:review];
    }
}



- (IBAction)btnBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - VPReviewManagerDelegate Methods 

- (void)reviewManager:(VPReviewManager *)manager didAddReview:(VPReviewsModel *)review {
    [self stopAnimating];
    [self startAnimatingWithSuccessMsg:@"Review Successfully added"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reviewManager:(VPReviewManager *)manager didFailToAddReview:(NSString *)message {
    [self stopAnimating];
    [self showError:message];
}

#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
