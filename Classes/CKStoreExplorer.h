//
//  CKStoreExplorer.h
//  Express
//
//  Created by Oli Kenobi on 10-01-24.
//  Copyright 2010 Kenobi Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CKStore.h>


@interface CKStoreExplorer : UITableViewController {
	NSArray *_domains;
	
	NSMutableArray *_stores;
}

@property (retain) NSArray *domains;

- (id)initWithDomains:(NSArray *)domains;

@end
