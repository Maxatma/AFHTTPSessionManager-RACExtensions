//
//  AFHTTPSessionManager+RACExtensions.h
//  GETPET
//
//  Created by Alexander Zaporozhchenko on 1/4/16.
//  Copyright © 2016 Alexander Zaporozhchenko. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "ReactiveCocoa.h"

typedef NS_ENUM(NSUInteger, HTTPMethodType)
{
    GET,
    POST,
    HEAD,
    PUT,
    PATCH,
    DELETE
};

@interface AFHTTPSessionManager (RACExtensions)
- (nullable RACSignal  *)rac_POST:(nullable NSString *)URLString
             parameters:(nullable id)parameters
constructingBodyWithBlock:(nullable void (^)( id <AFMultipartFormData>   formData))block;

- (nullable RACSignal *)rac_requestWithMethod:(HTTPMethodType)method
                                 URL:(nullable NSString *)urlString
                          parameters:(nullable id)parameters;


@end
