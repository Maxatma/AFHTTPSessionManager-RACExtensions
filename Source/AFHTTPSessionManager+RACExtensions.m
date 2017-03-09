//
//  AFHTTPSessionManager+RACExtensions.m
//  GETPET
//
//  Created by Alexander Zaporozhchenko on 1/4/16.
//  Copyright © 2016 Alexander Zaporozhchenko. All rights reserved.
//

#import "AFHTTPSessionManager+RACExtensions.h"

@implementation AFHTTPSessionManager (RACExtensions)

NSString * const RACAFNResponseObjectErrorKey = @"responseObject";


- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(nullable id)parameters
constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self POST:URLString
                                     parameters:parameters
                      constructingBodyWithBlock:block
                                       progress:nil
                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                            [subscriber sendNext:responseObject];
                                            [subscriber sendCompleted];
                                        }
                                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            [subscriber sendError:error];
                                        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


- (RACSignal *)rac_requestWithMethod:(HTTPMethodType)method
                                 URL:(NSString *)urlString
                          parameters:(id)parameters
{
    NSString *methodString = [self methodWithHTTPMethodType:method];
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSURLRequest *request = [self.requestSerializer requestWithMethod:methodString
                                                                URLString:[[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteString]
                                                               parameters:parameters
                                                                    error:nil];
        
        NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                             completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                 if (error) {
                                                     NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                                                     if (responseObject) {
                                                         userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                                                     }
                                                     NSError *errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
                                                     [subscriber sendError:errorWithRes];
                                                 }
                                                 else {
                                                     
                                                     [subscriber sendNext:responseObject];
                                                     [subscriber sendCompleted];
                                                 }
                                             }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

#pragma mark - Private


- (NSString *)methodWithHTTPMethodType:(HTTPMethodType)type
{
    switch (type) {
        case GET: {
            return @"GET";
        }
        case POST: {
            return @"POST";
        }
        case HEAD: {
            return @"HEAD";
        }
        case PUT: {
            return @"PUT";
        }
        case PATCH: {
            return @"PATCH";
        }
        case DELETE: {
            return @"DELETE";
        }
    }
}


@end
