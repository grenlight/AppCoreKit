//
//  RootViewController.h
//  FeedView
//
//  Created by Sebastien Morel on 11-03-16.
//  Copyright Wherecloud 2011. All rights reserved.
//

#import <CloudKit/CKTableViewController.h>
#import "CKObjectController.h"
#import "CKObjectViewControllerFactory.h"
#import "CKNSDictionary+TableViewAttributes.h"

@interface CKObjectTableViewController : CKTableViewController<CKObjectControllerDelegate> {
	id _objectController;
	CKObjectViewControllerFactory* _controllerFactory;
	
	CKTableViewOrientation _orientation;
	BOOL _resizeOnKeyboardNotification;
	
	int _currentPage;
	int _numberOfObjectsToprefetch;
	
	BOOL _scrolling;
	
	//internal
	NSMutableDictionary* _cellsToControllers;
	NSMutableDictionary* _cellsToIndexPath;
	NSMutableDictionary* _indexPathToCells;
	NSMutableArray* _weakCells;
	NSIndexPath* _indexPathToReachAfterRotation;
}

@property (nonatomic, retain) id objectController;
@property (nonatomic, retain) CKObjectViewControllerFactory* controllerFactory;

@property (nonatomic, assign) CKTableViewOrientation orientation;
@property (nonatomic, assign) BOOL resizeOnKeyboardNotification;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int numberOfObjectsToprefetch;
@property (nonatomic, assign, readonly) BOOL scrolling;

- (id)initWithObjectController:(id)controller withControllerFactory:(CKObjectViewControllerFactory*)factory;

@end
