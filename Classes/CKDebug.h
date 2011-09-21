//
//  Debug.h
//
//  Created by Martin Dufort on 04/08/09.
//  Copyright 2009 WhereCloud Inc. All rights reserved.
//

// CKDebugLog Macro

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString* cleanString(NSString* str);

#ifdef DEBUG
  /** TODO
   */
  #define CKDebugLog(s, ...) NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, cleanString([NSString stringWithFormat:(s), ##__VA_ARGS__]))
#else
  #define CKDebugLog(s, ...)
#endif


// UIView
@interface UIView (CKDebug)

- (void)printViewHierarchy;

@end

// CallStack
NSString* CKDebugGetCallStack();
void CKDebugPrintCallStack();
