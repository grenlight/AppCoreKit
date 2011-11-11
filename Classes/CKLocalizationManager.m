//
//  CKLocalizationManager.m
//  Volvo
//
//  Created by Sebastien Morel on 11-11-10.
//  Copyright (c) 2011 Wherecloud. All rights reserved.
//

#import "CKLocalizationManager.h"
#import "CKLocalization.h"
#import <UIKit/UIKit.h>
#import "CKNSObject+Introspection.h"
#import "CKDebug.h"

@interface CKLocalizationManager()
- (void)refreshUI;
@end

@implementation CKLocalizationManager
@synthesize language = _language;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;
static CKLocalizationManager *sharedInstance = nil;

+ (CKLocalizationManager *)sharedManager
{
	@synchronized([CKLocalizationManager class])
	{
		if (!sharedInstance){
			[[self alloc] init];
		}
		return sharedInstance;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([CKLocalizationManager class])
	{
		NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedInstance = [super alloc];
		return sharedInstance;
	}
	return nil;
}


- (id)init
{
    if ((self = [super init])) 
    {
		bundle = [NSBundle mainBundle];
	}
    return self;
}

// Gets the current localized string as in NSLocalizedString.
//
// example calls:
// AMLocalizedString(@"Text to localize",@"Alternative text, in case hte other is not find");
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
    return CKGetLocalizedString(bundle,key,value);
}


// Sets the desired language of the ones you have.
// example calls:
// LocalizationSetLanguage(@"Italian");
// LocalizationSetLanguage(@"German");
// LocalizationSetLanguage(@"Spanish");
// 
// If this function is not called it will use the default OS language.
// If the language does not exists y returns the default OS language.
- (void) setLanguage:(NSString*) l{
    if(![l isEqualToString:_language]){
        CKDebugLog(@"preferredLang: %@", l);
        
        [CKLocalizationStringTableNames release];
        CKLocalizationStringTableNames = nil;
        
        NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
        
        if (path == nil)
            //in case the language does not exists
            [self resetToSystemDefaultLanguage];
        else
            bundle = [[NSBundle bundleWithPath:path] retain];
        
        [_language release];
        _language = [l retain];
        
        [self refreshUI];
    }
}

// Resets the localization system, so it uses the OS default language.
//
// example call:
// LocalizationReset;
- (void) resetToSystemDefaultLanguage
{
	bundle = [NSBundle mainBundle];
}


- (void)refreshView:(UIView*)view{
    if([view isKindOfClass:[UITableView class]]){
        UITableView* table = (UITableView*)view;
        [table reloadData];
    }
    else{
        [view setNeedsDisplay];
        [view setNeedsLayout];
        for(UIView* v in [view subviews]){
            [self refreshView:v];
        }
    }
}

- (void)refreshViewController:(UIViewController*)controller{
    if(!controller){
        return;
    }
    
    controller.title = controller.title;
    [self refreshViewController:[controller modalViewController]];
    
    if([NSObject isKindOf:[controller class] parentClassName:@"CKContainerViewController"]
       || [NSObject isKindOf:[controller class] parentClassName:@"CKSplitViewController"]){
        NSArray* controllers = [controller performSelector:@selector(viewControllers)];
        for(UIViewController* c in controllers){
            [self refreshViewController:c];
        }
    }
}

- (void)refreshUI{
    NSArray* windows = [[UIApplication sharedApplication]windows];
    for(UIWindow* window in windows){
        UIViewController* c = [window rootViewController];
        [self refreshViewController:c];
        [self refreshView:window];
    }
}

@end