//
//  CKNetworkActivityManager.m
//  AppCoreKit
//
//  Created by Sebastien Morel.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import "CKNetworkActivityManager.h"
#import <UIKit/UIKit.h>

@implementation CKNetworkActivityManager

+ (CKNetworkActivityManager*)defaultManager {
	static CKNetworkActivityManager* CKDefaultNetworkActivityManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CKDefaultNetworkActivityManager = [[CKNetworkActivityManager alloc] init];
    });
	return CKDefaultNetworkActivityManager;
}

- (id)init {
	if (self = [super init]) {
		_objects = [[NSMutableSet alloc] initWithCapacity:100];
	}
	return self;
}

- (void)dealloc {
	[_objects release];
	[super dealloc];
}

//

- (void)addNetworkActivityForObject:(id)object {
	[self performSelectorOnMainThread:@selector(doAddNetworkActivityForObject:) withObject:object waitUntilDone:NO];
}

- (void)removeNetworkActivityForObject:(id)object {
	[self performSelectorOnMainThread:@selector(doRemoveNetworkActivityForObject:) withObject:object waitUntilDone:NO];
}

#pragma mark Private

- (void)doAddNetworkActivityForObject:(id)object {
	if ([_objects count] == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	
	NSValue *value = [NSValue valueWithNonretainedObject:object];
	[_objects addObject:value];
	
//	NSLog(@"Add <%p> <%d> %@", value, [self.objects count], object);
}

- (void)doRemoveNetworkActivityForObject:(id)object {
	NSValue *value = [NSValue valueWithNonretainedObject:object];
	[_objects removeObject:value];
	
	if ([_objects count] == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}

//	NSLog(@"Remove <%p> <%d> %@", value, [self.objects count], object);
}

- (NSString *)description {
	NSString *desc = [NSString stringWithFormat:@"CKNetworkActivityManager objects : {\n"];
	for(NSValue *object in _objects) {
		desc = [desc stringByAppendingFormat:@"%@\n", [[object nonretainedObjectValue] description]];
	}
	desc = [desc stringByAppendingFormat:@"}\n"];
	return desc;
}

@end
