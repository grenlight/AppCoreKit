//
//  CKWebSource.h
//  CloudKit
//
//  Created by Fred Brunel on 11-01-14.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CKWebRequest2.h>
#import "CKFeedSource.h"

extern NSString* const CKWebSourceErrorNotification;

@class CKWebSource;

typedef CKWebRequest2 *(^CKWebSourceRequestBlock)(NSRange range);
typedef id (^CKWebSourceTransformBlock)(id value);
typedef void (^CKWebSourceFailureBlock)(NSError *error);

@interface CKWebSource : CKFeedSource <CKWebRequestDelegate> {
	CKWebRequest2 *_request;
	NSUInteger _requestedBatchSize;
	CKWebSourceRequestBlock _requestBlock;
	CKWebSourceTransformBlock _transformBlock;
	CKWebSourceFailureBlock _failureBlock;
}

@property (nonatomic, copy) CKWebSourceRequestBlock requestBlock;
@property (nonatomic, copy) CKWebSourceTransformBlock transformBlock;
@property (nonatomic, copy) CKWebSourceFailureBlock failureBlock;

@end