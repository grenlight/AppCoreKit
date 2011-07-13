//
//  CKProvisioningController.h
//  CloudKit
//
//  Created by Sebastien Morel on 11-07-06.
//  Copyright 2011 Wherecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 
 TODO
 */
@interface CKProvisioningController : NSObject<UIAlertViewDelegate> {
    NSArray* _items;
    UIViewController* _parentViewController;
}
@property(nonatomic,retain) UIViewController* parentViewController;

- (id)initWithParentViewController:(UIViewController*)controller;
- (void)fetchAndDisplayAllProductReleaseAsModal;

@end
