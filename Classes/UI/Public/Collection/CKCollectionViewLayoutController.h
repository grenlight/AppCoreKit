//
//  CKCollectionViewLayoutController.h
//  AppCoreKit
//
//  Created by Sebastien Morel on 2013-10-22.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKCollectionViewLayout.h"
#import "CKCollectionViewMorphableLayout.h"
#import "CKCollectionViewController.h"

@interface CKCollectionViewLayoutController : CKCollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate,CKCollectionViewMorphableLayoutDelegate>

- (id)initWithLayout:(CKCollectionViewLayout*)layout collection:(CKCollection*)collection factory:(CKCollectionCellControllerFactory*)factory;

- (void)setupWithLayout:(CKCollectionViewLayout*)layout collection:(CKCollection*)collection factory:(CKCollectionCellControllerFactory*)factory;

@property(nonatomic,retain,readonly) UICollectionView* collectionView;

@property(nonatomic,retain) CKCollectionViewLayout* layout;

/** Default value is YES.
    Enabling this flag will optimize device orientation changes by taking a snapshot of the collectionView before and after rotation, hidding the collection view and cross fading between the 2 snapshots.
 */
@property(nonatomic,assign) BOOL optimizedOrientationChangedEnabled;


///-----------------------------------
/// @name Scrolling
///-----------------------------------
/**
 Returns the scrolling state of the table. Somebody can bind himself on this property to act depending on the scrolling state for example.
 */
@property (nonatomic, assign, readonly) BOOL scrolling;

@end
