//
//  CKPageScrollView.h
//  CloudKit
//
//  Created by Olivier Collet.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CKPageScrollViewDataSource;
@protocol CKPageScrollViewDelegate;


/** TODO
 */
@interface CKPageScrollView : UIView <UIScrollViewDelegate> {
	id<CKPageScrollViewDataSource> _dataSource;
	id<CKPageScrollViewDelegate> _delegate;

	NSUInteger _currentPageIndex;
	NSUInteger _nbPages;

	UIScrollView *_scrollView;
	NSMutableArray *_views;
	BOOL _didSendMoveNotification;
	BOOL _isScrolling;
}

@property (nonatomic, assign) IBOutlet id<CKPageScrollViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<CKPageScrollViewDelegate> delegate;
@property (nonatomic, readonly) NSUInteger currentIndex;
@property (nonatomic, readonly) BOOL isScrolling;

- (void)reloadData;

- (void)scrollToIndex:(NSInteger)index;

@end

// DataSource


/** TODO
 */
@protocol CKPageScrollViewDataSource

@required
- (NSUInteger)numberOfPagesInPageScrollView:(CKPageScrollView *)pageScrollView;
- (UIView *)pageScrollView:(CKPageScrollView *)pageScrollView viewForPageAtIndex:(NSUInteger)index;

@end

// Delegate


/** TODO
 */
@protocol CKPageScrollViewDelegate

@optional
- (void)pageScrollDidBeginScrolling:(CKPageScrollView *)pageScrollView;
- (void)pageScrollDidEndScrolling:(CKPageScrollView *)pageScrollView;

@end