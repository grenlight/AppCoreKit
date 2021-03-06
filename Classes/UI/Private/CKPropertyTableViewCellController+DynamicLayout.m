//
//  CKPropertyTableViewCellController+DynamicLayout.m
//  AppCoreKit
//
//  Created by Sebastien Morel.
//  Copyright (c) 2012 Wherecloud. All rights reserved.
//

#import "CKPropertyTableViewCellController+DynamicLayout.h"
#import "CKTableViewCellController+DynamicLayout_Private.h"
#import "CKTableViewCellController+DynamicLayout.h"
#import "NSObject+Bindings.h"
#import "CKLocalization.h"
#import "CKAlertView.h"
#import "CKFormTableViewController.h"
#import "CKTableViewCellController+Responder.h"
#import "CKSheetController.h"

#import <QuartzCore/QuartzCore.h>

@interface CKPropertyTableViewCellController () 
@property(nonatomic,retain)UIButton* validationButton;
@property(nonatomic,retain)UIImageView* validationImageView;
@property(nonatomic,retain)UIView* oldAccessoryView;
@property(nonatomic,assign)UITableViewCellAccessoryType oldAccessoryType;
@property(nonatomic,retain)NSString* validationBindingContext;
@end

@implementation CKPropertyTableViewCellController(CKDynamicLayout)

- (void)performLayout{
    [super performLayout];
    [self performValidationLayout];
}

- (CGRect)rectForValidationButtonWithCell:(UITableViewCell*)cell{
    UIImage* img = CLICKABLE_VALIDATION_INFO ? (UIImage*)[self.validationButton currentImage] : (UIImage*)[self.validationImageView image];
    
    if(!img)
        return CGRectMake(0,0,0,0);
    
    UIView* contentView = cell.contentView;
    CGRect contentRect = contentView.frame;
    CGFloat x = MAX(img.size.width / 2.0,contentRect.origin.x / 2.0);
    
    
    CGRect buttonRect = CGRectMake( self.tableViewCell.frame.size.width - x - img.size.width / 2.0,
                                   self.tableViewCell.frame.size.height / 2.0 - img.size.height / 2.0,
                                   img.size.width,
                                   img.size.height);
    return CGRectIntegral(buttonRect);
}

- (void)performValidationLayout{
    if(self.validationButton != nil
       || self.validationImageView != nil){
        BOOL shouldReplaceAccessoryView = (   [[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone
                                           || [self parentTableView].style == UITableViewStylePlain );
        if(!shouldReplaceAccessoryView){
            UIView* newAccessoryView = CLICKABLE_VALIDATION_INFO ? (UIView*)self.validationButton : (UIView*)self.validationImageView;
            newAccessoryView.frame = [self rectForValidationButtonWithCell:self.tableViewCell];
        }
    }
}

@end