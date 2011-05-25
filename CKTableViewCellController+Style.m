//
//  CKTableViewCellController+Style.m
//  CloudKit
//
//  Created by Sebastien Morel on 11-04-21.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import "CKTableViewCellController+Style.h"
#import "CKStyles.h"
#import "CKStyleManager.h"

//HACK : here to know the context of the parent controller ...
#import "CKObjectCarouselViewController.h"
#import "CKTableViewController.h"
#import "CKMapViewController.h"

#import "CKGradientView.h"
#import "CKNSArrayAdditions.h"
#import "CKStyle+Parsing.h"

NSString* CKStyleCellType = @"cellType";
NSString* CKStyleAccessoryImage = @"accessoryImage";
NSString* CKStyleCellSize = @"size";
NSString* CKStyleCellFlags = @"flags";

@implementation NSMutableDictionary (CKTableViewCellControllerStyle)

- (UITableViewCellStyle)cellStyle{
	return (UITableViewCellStyle)[self enumValueForKey:CKStyleCellType 
									 withDictionary:CKEnumDictionary(UITableViewCellStyleDefault, 
																	 UITableViewCellStyleValue1, 
																	 UITableViewCellStyleValue2,
																	 UITableViewCellStyleSubtitle)];
}

- (UIImage*)accessoryImage{
	return [self imageForKey:CKStyleAccessoryImage];
}

- (CGSize)cellSize{
	return [self cgSizeForKey:CKStyleCellSize];
}

- (CKItemViewFlags)cellFlags{
	return (CKItemViewFlags)[self enumValueForKey:CKStyleCellFlags 
										withDictionary:CKEnumDictionary(CKItemViewFlagNone,
																		CKItemViewFlagSelectable,
																		CKItemViewFlagEditable,
																		CKItemViewFlagRemovable,
																		CKItemViewFlagMovable,
																		CKItemViewFlagAll)];
}

@end



@implementation UITableViewCell (CKValueTransformer)

- (void)accessoryTypeMetaData:(CKModelObjectPropertyMetaData*)metaData{
	metaData.enumDefinition = CKEnumDictionary(UITableViewCellAccessoryNone, 
											   UITableViewCellAccessoryDisclosureIndicator, 
											   UITableViewCellAccessoryDetailDisclosureButton,
											   UITableViewCellAccessoryCheckmark);
}

- (void)editingAccessoryTypeMetaData:(CKModelObjectPropertyMetaData*)metaData{
	metaData.enumDefinition = CKEnumDictionary(UITableViewCellAccessoryNone, 
											   UITableViewCellAccessoryDisclosureIndicator, 
											   UITableViewCellAccessoryDetailDisclosureButton,
											   UITableViewCellAccessoryCheckmark);
}

- (void)selectionStyleMetaData :(CKModelObjectPropertyMetaData*)metaData{
	metaData.enumDefinition = CKEnumDictionary(UITableViewCellSelectionStyleNone,
											   UITableViewCellSelectionStyleBlue,
											   UITableViewCellSelectionStyleGray);
}

- (void)editingStyleMetaData :(CKModelObjectPropertyMetaData*)metaData{
	metaData.enumDefinition = CKEnumDictionary(UITableViewCellEditingStyleNone,
											   UITableViewCellEditingStyleDelete,
											   UITableViewCellEditingStyleInsert);
}

@end

@implementation UITableViewCell (CKStyle)

+ (BOOL)applyStyle:(NSMutableDictionary*)style toView:(UIView*)view appliedStack:(NSMutableSet*)appliedStack delegate:(id)delegate{
	if([UIView applyStyle:style toView:view appliedStack:appliedStack delegate:delegate]){
		UITableViewCell* tableViewCell = (UITableViewCell*)view;
		NSMutableDictionary* myCellStyle = style;
		if(myCellStyle){
			//Applying style on UITableViewCell
			if([myCellStyle containsObjectForKey:CKStyleAccessoryImage]){
				UIImage* image = [myCellStyle accessoryImage];
				UIImageView* imageView = [[[UIImageView alloc]initWithImage:image]autorelease];
				tableViewCell.accessoryView = imageView;
			}
			return YES;
		}
	}
	return NO;
}


@end

@implementation CKTableViewController (CKStyle)

- (BOOL)object:(id)object shouldReplaceViewWithDescriptor:(CKClassPropertyDescriptor*)descriptor withStyle:(NSMutableDictionary*)style{
	if(style == nil || [style isEmpty] == YES)
		return NO;
	
	if([object isKindOfClass:[UITableView class]]){
		if([descriptor.name isEqual:@"backgroundView"] && [style isEmpty] == NO){
			return YES;
		}
	}
	return NO;
}

- (void)applyStyle{
	NSMutableDictionary* controllerStyle = [[CKStyleManager defaultManager] styleForObject:self  propertyName:nil];
	
	NSMutableSet* appliedStack = [NSMutableSet set];
	[self applySubViewsStyle:controllerStyle appliedStack:appliedStack delegate:self];
}

@end


@implementation CKItemViewController (CKStyle)

- (void)applyStyle:(NSMutableDictionary*)style forView:(UIView*)view{
	NSMutableSet* appliedStack = [NSMutableSet set];
	[self applySubViewsStyle:style appliedStack:appliedStack delegate:self];
}

- (NSMutableDictionary*)controllerStyle{
	NSMutableDictionary* parentControllerStyle = [[CKStyleManager defaultManager] styleForObject:self.parentController  propertyName:nil];
	NSMutableDictionary* controllerStyle = [parentControllerStyle styleForObject:self  propertyName:nil];
	return controllerStyle;
}

- (UIView*)parentControllerView{
	UIView* view = nil;
	if([self.parentController isKindOfClass:[CKObjectCarouselViewController class]] == YES) 
		view = (UIView*)((CKObjectCarouselViewController*)self.parentController).carouselView;
	else if([self.parentController isKindOfClass:[CKTableViewController class]] == YES) 
		view = (UIView*)((CKTableViewController*)self.parentController).tableView;
	else if([self.parentController isKindOfClass:[CKMapViewController class]] == YES) 
		view = (UIView*)((CKMapViewController*)self.parentController).mapView;
	return view;
}

@end

//delegate for tableViewCell styles
@implementation CKTableViewCellController (CKStyle)

- (CKRoundedCornerViewType)view:(UIView*)view cornerStyleWithStyle:(NSMutableDictionary*)style{
	CKRoundedCornerViewType roundedCornerType = CKRoundedCornerViewTypeNone;
	
	switch([style cornerStyle]){
		case CKViewCornerStyleDefault:{
			if(view == self.tableViewCell.backgroundView
			   || view == self.tableViewCell.selectedBackgroundView){
				UIView* parentView = [self parentControllerView];
				if([parentView isKindOfClass:[UITableView class]]){
					UITableView* tableView = (UITableView*)parentView;
					if(tableView.style == UITableViewStyleGrouped){
						NSInteger numberOfRows = [tableView numberOfRowsInSection:self.indexPath.section];
						if(self.indexPath.row == 0 && numberOfRows > 1){
							roundedCornerType = CKRoundedCornerViewTypeTop;
						}
						else if(self.indexPath.row == 0){
							roundedCornerType = CKRoundedCornerViewTypeAll;
						}
						else if(self.indexPath.row == numberOfRows-1){
							roundedCornerType = CKRoundedCornerViewTypeBottom;
						}
					}
				}
			}
			break;
		}
	}
	
	return roundedCornerType;
}

- (CKGradientViewBorderType)view:(UIView*)view borderStyleWithStyle:(NSMutableDictionary*)style{
	CKGradientViewBorderType borderType = CKGradientViewBorderTypeNone;
	
	switch([style cornerStyle]){
		case CKViewCornerStyleDefault:{
			if(view == self.tableViewCell.backgroundView
			   || view == self.tableViewCell.selectedBackgroundView){
				UIView* parentView = [self parentControllerView];
				if([parentView isKindOfClass:[UITableView class]]){
					UITableView* tableView = (UITableView*)parentView;
					if(tableView.style == UITableViewStyleGrouped){
						NSInteger numberOfRows = [tableView numberOfRowsInSection:self.indexPath.section];
						if(self.indexPath.row == numberOfRows - 1){
							borderType = CKGradientViewBorderTypeAll;
						}
						else {
							borderType = CKGradientViewBorderTypeAll &~ CKGradientViewBorderTypeBottom;
						}
					}
					else{
						borderType = CKGradientViewBorderTypeBottom;
					}
				}
			}
			break;
		}
	}
	
	return borderType;
}

- (BOOL)object:(id)object shouldReplaceViewWithDescriptor:(CKClassPropertyDescriptor*)descriptor withStyle:(NSMutableDictionary*)style{
	if(style == nil || [style isEmpty] == YES)
		return NO;
	
	if([object isKindOfClass:[UITableViewCell class]]){
		if(([descriptor.name isEqual:@"backgroundView"]
			|| [descriptor.name isEqual:@"selectedBackgroundView"]) && [style isEmpty] == NO){
			return YES;
		}
	}
	return NO;
}

@end

