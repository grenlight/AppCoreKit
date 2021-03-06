//
//  UIColor+ValueTransformer.m
//  AppCoreKit
//
//  Created by Sebastien Morel.
//  Copyright 2011 Wherecloud. All rights reserved.
//

#import "UIColor+ValueTransformer.h"
#import "NSValueTransformer+Additions.h"
#import "UIColor+Additions.h"
#import "CKResourceManager.h"

#import "CKResourceDependencyContext.h"

#import "CKDebug.h"


@implementation UIColor (CKUIColor_ValueTransformer)

+ (UIColor*)convertFromNSString:(NSString*)str{
    //CKResourceDependencyContext for color palettes
    
	NSArray* components = [str componentsSeparatedByString:@" "];
	if([components count] == 4){
		return [UIColor colorWithRed:[[components objectAtIndex:0]floatValue] 
							   green:[[components objectAtIndex:1]floatValue] 
								blue:[[components objectAtIndex:2]floatValue] 
							   alpha:[[components objectAtIndex:3]floatValue]];
	}
	else {
		str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        
		if([str hasPrefix:@"0x"]){
			NSArray* components = [str componentsSeparatedByString:@" "];
			CKAssert([components count] >= 1,@"Invalid format for color");
			unsigned outVal;
			NSScanner* scanner = [NSScanner scannerWithString:[components objectAtIndex:0]];
			[scanner scanHexInt:&outVal];
			UIColor* color = [UIColor colorWithRGBValue:outVal];
			
			if([components count] > 1){
				color = [color colorWithAlphaComponent:[[components objectAtIndex:1] floatValue] ];
			}
			return color;
		}
		else{
			SEL colorSelector = NSSelectorFromString(str);
			if(colorSelector && [[UIColor class] respondsToSelector:colorSelector]){
				UIColor* color = [[UIColor class] performSelector:colorSelector];
				return color;
			}
			else{
                UIImage* image = [CKResourceManager imageNamed:str];
                if(image){
                    UIColor* color = [UIColor colorWithPatternImage:image];
                    return color;
                }
                else{
                    NSLog(@"Couldn't a valid format for converting color '%@'",str);
                    //CKAssert(NO,@"invalid format for color with text : %@",str);
                }
			}
		}
	}
	
	return [UIColor clearColor];
}

+ (UIColor*)convertFromNSNumber:(NSNumber*)n{
	UIColor* result = [UIColor colorWithRGBValue:[n intValue]];
	return result;
}

+ (UIColor*)convertFromNSValue:(NSValue*)v{
    return [UIColor clearColor];
}

+ (NSString*)convertToNSString:(UIColor*)color{
	return [color description];
}

@end
