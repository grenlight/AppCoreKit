//
//  CKBreadCrumbViewController.m
//  AppCoreKit
//
//  Created by Sebastien Morel.
//  Copyright (c) 2011 Wherecloud. All rights reserved.
//

#import "CKBreadCrumbViewController.h"
#import "NSObject+Bindings.h"

@interface CKTabViewController ()
@property (nonatomic, retain, readwrite) CKTabView *tabBar;
@end

@implementation CKBreadCrumbViewController


- (id)initWithViewControllers:(NSArray *)viewControllers {
    self = [super initWithViewControllers:viewControllers];
    self.selectedIndex = [viewControllers count] - 1;
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.tabBar.style = CKTabViewStyleAlignLeft;
    self.style = CKTabViewControllerStyleBottom;
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    NSMutableArray* newControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [newControllers addObject:viewController];
    NSInteger current = self.selectedIndex;
    self.viewControllers = newControllers;
    self.selectedIndex = current;
    
    [self presentViewControllerAtIndex:[newControllers count] - 1 withTransition:animated ? CKTransitionPush : CKTransitionNone ];
}

- (void)popViewControllerAnimated:(BOOL)animated{
    if(self.selectedIndex > 0){
        NSInteger index = self.selectedIndex - 1;
        [self presentViewControllerAtIndex:index withTransition:animated ? CKTransitionPop : CKTransitionNone ];
        
        NSMutableArray* newControllers = [NSMutableArray arrayWithArray:[self.viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,index)]]];
        self.viewControllers = newControllers;
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated{
    if(self.selectedIndex > 0){
        [self presentViewControllerAtIndex:0 withTransition:animated ? CKTransitionPop : CKTransitionNone ];
        
        NSMutableArray* newControllers = [NSMutableArray arrayWithObject:[self.viewControllers objectAtIndex:0]];
        self.viewControllers = newControllers;
    }
}

- (void)tabView:(CKTabView *)tabView didSelectItemAtIndex:(NSUInteger)index {
    if(index != self.selectedIndex){
        
        if(self.willSelectViewControllerBlock){
            self.willSelectViewControllerBlock(self,index);
        }
        
        CKTransitionType transition = CKTransitionNone;
        if(index > self.selectedIndex){
            transition = CKTransitionPush;
        }
        else if(index < self.selectedIndex){
            transition = CKTransitionPop;
        }
        self.selectedIndex = index;
        
        NSMutableArray* newControllers = [NSMutableArray arrayWithArray:[self.viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,index + 1)]]];
        self.viewControllers = newControllers;
        
        [self presentViewControllerAtIndex:index withTransition:transition];
        
        if(self.didSelectViewControllerBlock){
            self.didSelectViewControllerBlock(self,index);
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
	[super setViewControllers:viewControllers];
    self.selectedIndex = [viewControllers count] - 1;
}

@end

