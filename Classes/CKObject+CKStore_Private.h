//
//  CKObject+CKStore_Private.h
//  CloudKit
//
//  Created by Martin Dufort on 12-06-21.
//  Copyright (c) 2012 Wherecloud. All rights reserved.
//

#import "CKObject+CKStore.h"

@class CKStoreRequest;
@class CKItem;

extern NSMutableDictionary* CKObjectManager;


/** TODO : clean this API to make public only the strict necessary methods for less confusion
 */
@interface CKObject (CKStoreAddition_private)

- (NSDictionary*) attributesDictionaryForDomainNamed:(NSString*)domain;

- (CKItem*)saveToDomainNamed:(NSString*)domain;
- (CKItem*)saveToDomainNamed:(NSString*)domain recursive:(BOOL)recursive;

+ (CKItem *)createItemWithObject:(CKObject*)object inDomainNamed:(NSString*)domain;

+ (CKItem*)itemWithObject:(CKObject*)object inDomainNamed:(NSString*)domain;
+ (CKItem*)itemWithObject:(CKObject*)object inDomainNamed:(NSString*)domain createIfNotFound:(BOOL)createIfNotFound;
+ (CKItem*)itemWithUniqueId:(NSString*) uniqueId inDomainNamed:(NSString*)domain;

+ (NSArray*)itemsWithClass:(Class)type withPropertiesAndValues:(NSDictionary*)attributes inDomainNamed:(NSString*)domain;

+ (void)registerObject:(CKObject*) object withUniqueId:(NSString*)uniqueId;

@end