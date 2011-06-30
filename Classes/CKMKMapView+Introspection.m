//
//  CKMKMapView+Introspection.m
//  CloudKit
//
//  Created by Sebastien Morel on 11-06-10.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import "CKMKMapView+Introspection.h"
#import "CKNSValueTransformer+Additions.h"
#import "CKModelObject.h"


@implementation MKMapView (CKIntrospectionAdditions)

- (void)annotationsMetaData:(CKModelObjectPropertyMetaData*)metaData{
	metaData.contentProtocol = @protocol(MKAnnotation);
}

//informal protocol for CKObjectProperty arrays insert/remove
//will get call when acting in property grids or table views ...
- (void)insertAnnotationsObjects:(NSArray *)annotations atIndexes:(NSIndexSet*)indexes{
	[self addAnnotations:annotations];
}

//informal protocol for CKObjectProperty arrays insert/remove
//will get call when acting in property grids or table views ...
- (void)removeAnnotationsObjectsAtIndexes:(NSIndexSet*)indexes{
	NSArray* annotations = [self.subviews objectsAtIndexes:indexes];
	[self removeAnnotations:annotations];
}

//informal protocol for CKObjectProperty arrays insert/remove
//will get call when acting in property grids or table views ...
- (void)removeAllAnnotationsObjects{
	[self removeAnnotations:self.annotations];
}

- (void)mapTypeMetaData:(CKModelObjectPropertyMetaData*)metaData{
	metaData.enumDefinition = CKEnumDictionary(MKMapTypeStandard,
											   MKMapTypeSatellite,
											   MKMapTypeHybrid);
}

@end