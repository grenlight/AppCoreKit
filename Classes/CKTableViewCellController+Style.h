//
//  CKTableViewCellController+Style.h
//  CloudKit
//
//  Created by Sebastien Morel on 11-04-21.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKTableViewCellController.h"
#import "CKUIViewController+Style.h"

extern NSString* CKStyleCellType;
extern NSString* CKStyleAccessoryImage;
extern NSString* CKStyleCellSize;
extern NSString* CKStyleCellFlags;

@interface NSMutableDictionary (CKTableViewCellControllerStyle)

- (CKTableViewCellStyle)cellStyle;
- (UIImage*)accessoryImage;
- (CGSize)cellSize;
- (CKItemViewFlags)cellFlags;

@end

@interface CKTableViewCellController (CKStyle)
@end

@interface UITableViewCell (CKStyle)
@end

@interface CKTableViewController (CKStyle)
@end

@interface CKItemViewController (CKStyle)

- (void)applyStyle:(NSMutableDictionary*)style forView:(UIView*)view;
- (NSMutableDictionary*)controllerStyle;
- (UIView*)parentControllerView;

@end