//
//  CKFormTableViewController.h
//  CloudKit
//
//  Created by Sebastien Morel on 11-04-06.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKObjectTableViewController.h"
#import "CKTableViewCellController.h"
#import "CKModelObject.h"
#import "CKObjectController.h"
#import "CKDocumentController.h"

@class CKFormTableViewController;


/** TODO
 */
@interface CKFormSectionBase : CKModelObject
{
	NSString* _headerTitle;
	UIView* _headerView;
	NSString* _footerTitle;
	UIView* _footerView;
	CKFormTableViewController* _parentController;
	BOOL _hidden;
}

@property (nonatomic,retain) NSString* headerTitle;
@property (nonatomic,retain) UIView* headerView;
@property (nonatomic,retain) NSString* footerTitle;
@property (nonatomic,retain) UIView* footerView;
@property (nonatomic,assign) CKFormTableViewController* parentController;
@property (nonatomic,readonly) NSInteger sectionIndex;
@property (nonatomic,readonly) NSInteger sectionVisibleIndex;
@property (nonatomic,readonly) BOOL hidden;

- (NSInteger)numberOfObjects;
- (id)objectAtIndex:(NSInteger)index;
- (void)removeObjectAtIndex:(NSInteger)index;
- (void)fetchRange:(NSRange)range;

- (void)updateStyleForNonNewVisibleCells;
- (void)updateStyleForExistingCells;

- (void)start;
- (void)stop;

- (void)lock;
- (void)unlock;

- (CKObjectViewControllerFactoryItem*)factoryItemForIndex:(NSInteger)index;

@end


@class CKFormCellDescriptor;


/** TODO
 */
@interface CKFormSection : CKFormSectionBase{
	
	NSMutableArray* _cellDescriptors;
}

@property (nonatomic,retain) NSArray* cellDescriptors;

- (id)initWithCellDescriptors:(NSArray*)cellDescriptors headerTitle:(NSString*)title;
- (id)initWithCellDescriptors:(NSArray*)cellDescriptors headerView:(UIView*)view;
- (id)initWithCellDescriptors:(NSArray*)cellDescriptors footerTitle:(NSString*)title;
- (id)initWithCellDescriptors:(NSArray*)cellDescriptors footerView:(UIView*)view;
- (id)initWithCellDescriptors:(NSArray*)cellDescriptors;

+ (CKFormSection*)section;
+ (CKFormSection*)sectionWithHeaderTitle:(NSString*)title;
+ (CKFormSection*)sectionWithHeaderView:(UIView*)view;
+ (CKFormSection*)sectionWithFooterTitle:(NSString*)title;
+ (CKFormSection*)sectionWithFooterView:(UIView*)view;
+ (CKFormSection*)sectionWithCellDescriptors:(NSArray*)cellDescriptors;
+ (CKFormSection*)sectionWithCellDescriptors:(NSArray*)cellDescriptors headerTitle:(NSString*)title;
+ (CKFormSection*)sectionWithCellDescriptors:(NSArray*)cellDescriptors headerView:(UIView*)view;
+ (CKFormSection*)sectionWithCellDescriptors:(NSArray*)cellDescriptors footerTitle:(NSString*)title;
+ (CKFormSection*)sectionWithCellDescriptors:(NSArray*)cellDescriptors footerView:(UIView*)view;

- (CKFormCellDescriptor*)insertCellDescriptor:(CKFormCellDescriptor *)cellDescriptor atIndex:(NSUInteger)index;
- (CKFormCellDescriptor*)addCellDescriptor:(CKFormCellDescriptor *)cellDescriptor;
- (void)removeCellDescriptor:(CKFormCellDescriptor *)cellDescriptor;
- (void)removeCellDescriptorAtIndex:(NSUInteger)index;

@end


/** TODO
 */
@interface CKFormDocumentCollectionSection : CKFormSectionBase<CKObjectControllerDelegate>{
	CKDocumentCollectionController* _objectController;
	CKObjectViewControllerFactory* _controllerFactory;
	
	NSMutableArray* _headerCellDescriptors;
	NSMutableArray* _footerCellDescriptors;
	NSMutableArray* _changeSet;
	
	BOOL sectionUpdate;
}

@property (nonatomic,retain,readonly) CKDocumentCollectionController* objectController;
@property (nonatomic,retain,readonly) NSMutableArray* headerCellDescriptors;
@property (nonatomic,retain,readonly) NSMutableArray* footerCellDescriptors;

- (id)initWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings;
+ (CKFormDocumentCollectionSection*)sectionWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings;
+ (CKFormDocumentCollectionSection*)sectionWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings headerTitle:(NSString*)title;

+ (CKFormDocumentCollectionSection*)sectionWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings displayFeedSourceCell:(BOOL)displayFeedSourceCell;
+ (CKFormDocumentCollectionSection*)sectionWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings headerTitle:(NSString*)title displayFeedSourceCell:(BOOL)displayFeedSourceCell;

- (CKFormCellDescriptor*)addFooterCellDescriptor:(CKFormCellDescriptor*)descriptor;
- (void)removeFooterCellDescriptor:(CKFormCellDescriptor*)descriptor;
- (CKFormCellDescriptor*)addHeaderCellDescriptor:(CKFormCellDescriptor*)descriptor;
- (void)removeHeaderCellDescriptor:(CKFormCellDescriptor*)descriptor;

@end

typedef void(^CKFormCellInitializeBlock)(CKTableViewCellController* controller);


/** TODO
 */
@interface CKFormCellDescriptor : CKObjectViewControllerFactoryItem{
	id _value;
}

@property (nonatomic,retain) id value;

- (id)initWithValue:(id)value controllerClass:(Class)controllerClass;
+ (CKFormCellDescriptor*)cellDescriptorWithValue:(id)value controllerClass:(Class)controllerClass;

@end


/** TODO
 */
@interface CKFormTableViewController : CKObjectTableViewController {
	NSMutableArray* _sections;
	BOOL _autoHideSections;
	BOOL _autoHideSectionHeaders;
	BOOL reloading;
    BOOL _validationEnabled;
}
@property (nonatomic,retain, readonly) NSMutableArray* sections;
@property (nonatomic,readonly) BOOL reloading;
@property (nonatomic,assign) BOOL autoHideSections;
@property (nonatomic,assign) BOOL autoHideSectionHeaders;
@property (nonatomic,assign) BOOL validationEnabled;

///-----------------------------------
/// @name Initializing CKFormTableViewController
///-----------------------------------

- (id)initWithSections:(NSArray*)sections;
- (id)initWithSections:(NSArray*)sections withNibName:(NSString*)nibName;

///-----------------------------------
/// @name Clearing CKFormTableViewController
///-----------------------------------

- (void)clear;

///-----------------------------------
/// @name Creating or inserting the sections
///-----------------------------------

- (CKFormSectionBase*)addSection:(CKFormSectionBase *)section;
- (NSArray*)addSections:(NSArray *)sections;
- (CKFormSection *)addSectionWithCellDescriptors:(NSArray *)cellDescriptors;
- (CKFormSection *)addSectionWithCellDescriptors:(NSArray *)cellDescriptors headerTitle:(NSString *)headerTitle;

- (CKFormSection *)insertSectionWithCellDescriptors:(NSArray *)cellDescriptors atIndex:(NSInteger)index;
- (CKFormSection *)insertSectionWithCellDescriptors:(NSArray *)cellDescriptors headerTitle:(NSString *)headerTitle  atIndex:(NSInteger)index;

- (CKFormDocumentCollectionSection *)addSectionWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings;
- (CKFormDocumentCollectionSection *)insertSectionWithCollection:(CKDocumentCollection*)collection mappings:(NSArray*)mappings  atIndex:(NSInteger)index;

- (void)setSections:(NSArray*)sections hidden:(BOOL)hidden;

///-----------------------------------
/// @name Accessing the sections
///-----------------------------------

- (CKFormSectionBase *)sectionAtIndex:(NSUInteger)index;
- (NSInteger)indexOfSection:(CKFormSectionBase *)section;

- (NSInteger)numberOfVisibleSections;
- (CKFormSectionBase*)visibleSectionAtIndex:(NSInteger)index;
- (NSInteger)indexOfVisibleSection:(CKFormSectionBase*)section;

@end


//Adds extensions here to avoid importing to much files in client projects

#import "CKFormTableViewController+PropertyGrid.h"
#import "CKFormTableViewController+Menus.h"
