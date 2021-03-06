//
//  CKWebRequest+Mapping.m
//  AppCoreKit
//
//  Created by Sebastien Morel.
//  Copyright (c) 2012 Wherecloud. All rights reserved.
//

#import "CKWebRequest+Mapping.h"
#import "CKMappingContext.h"
#import "NSObject+JSON.h"
#import "CKDebug.h"
#import "NSURLRequest+Upload.h"


@implementation CKWebRequest (StandardRequests)

+ (CKWebRequest*) requestForObjectsWithUrl:(NSURL*)url
                                    params:(NSDictionary*)params
                                      body:(NSData*)body
                  mappingContextIdentifier:(NSString*)mappingIdentifier
                          transformRawData:(NSArray*(^)(id value))transformRawDataBlock
                                completion:(void(^)(NSArray* objects))completionBlock 
                                     error:(void(^)(id value, NSHTTPURLResponse* response, NSError* error))errorBlock{
    CKAssert((!params && !body) || (params && !body) || (body && ! params),@"Our standard request is compatible with only params or body");
    
    CKWebRequest* request = nil;
    if(body){
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url body:body];
        request = [[[CKWebRequest alloc]initWithURLRequest:urlRequest parameters:nil transform:nil completion:nil]autorelease];
    }else{
        request = [[[CKWebRequest alloc]initWithURL:url parameters:params]autorelease];
    }
    
    __block CKWebRequest* bRequest = request;
    request.transformBlock = ^id(id value){
        NSError* error = nil;
        
        if(transformRawDataBlock && [value isKindOfClass:[NSDictionary class]]){
            value = transformRawDataBlock(value);
        }
        
        if(![value isKindOfClass:[NSArray class]]){
            return value;
        }
        
        CKMappingContext* context = [CKMappingContext contextWithIdentifier:mappingIdentifier];
        NSArray* models = [context objectsFromValue:value error:&error];
        if(error){
            CKDebugLog(@"request mappings error : %@", error);
        }
        return models;
    };
    
    request.completionBlock = ^(id value, NSHTTPURLResponse* response, NSError* error){
        CKDebugLog(@"%@", [NSString stringWithFormat:@"%@", bRequest.URL]);
        if(error || response.statusCode >= 400 || ![value isKindOfClass:[NSArray class]]){
            if(errorBlock){
                errorBlock(value, response, error);
            }
        }
        else{
            if([value isKindOfClass:[NSArray class]]){
                if([value count] <= 0){
                    CKDebugLog(@"%@",[NSString stringWithFormat:@"No results for Request : %@",[[response URL]description]]);
                }
            }
            
            if(completionBlock){
                CKAssert([value isKindOfClass:[NSArray class]],@"Invalid request transformation");
                completionBlock((NSArray*)value);
            }
        }
    };
    return request;

    
}

+ (CKWebRequest*)requestForObject:(id)object
                              url:(NSURL*)url
                           params:(NSDictionary*)params
                             body:(NSData*)body
         mappingContextIdentifier:(NSString*)identifier
                 transformRawData:(NSDictionary*(^)(id value))transformRawDataBlock
                       completion:(void(^)(id object))completionBlock 
                            error:(void(^)(id value, NSHTTPURLResponse* response, NSError* error))errorBlock{
    CKAssert((!params && !body) || (params && !body) || (body && ! params),@"Our standard request is compatible with only params or body");
    
    CKWebRequest* request = nil;
    if(body){
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url body:body];
        request = [[[CKWebRequest alloc]initWithURLRequest:urlRequest parameters:nil transform:nil completion:nil]autorelease];
    }else{
        request = [[[CKWebRequest alloc]initWithURL:url parameters:params]autorelease];
    }
    
    request.transformBlock = ^(id value){
        NSError* error = nil;
        if(transformRawDataBlock && [value isKindOfClass:[NSDictionary class]]){
            value = transformRawDataBlock(value);
        }
        
        if(![value isKindOfClass:[NSDictionary class]]){
            CKDebugLog(@"standardGetRequestForObject error (Invalid result type): %@", value);
            return value;
        }
        else if (value) {
            CKMappingContext* context = [CKMappingContext contextWithIdentifier:identifier];
            [context mapValue:value toObject:object error:&error];
            if(error){
                CKDebugLog(@"request mappings error : %@", error);
            }
        }
        return (id)object;
    };
    
    request.completionBlock = ^(id value, NSHTTPURLResponse* response, NSError* error){
        if(error || response.statusCode >= 400){
            if(errorBlock){
                errorBlock(value, response, error);
            }
        }
        else{
            if(completionBlock){
                CKAssert(value == object,@"Invalid request transformation");
                completionBlock(value);
            }
        }
    };
    return request;
}

@end
