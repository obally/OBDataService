//
//  OBDataService.m
//  UCCertificate
//
//  Created by obally on 16/3/14.
//  Copyright © 2016年 ___shangyait___. All rights reserved.
//

#import "OBDataService.h"
#import "AFNetworking.h"
@implementation OBDataService
+ (void)requestWithURL:(NSString *_Nonnull)urlstring
                params:(NSMutableDictionary *_Nullable)params
            httpMethod:(NSString *_Nonnull)httpMethod
         progressBlock:(ProgressBlock _Nonnull)progressBlock
       completionblock:(CompletionLoadHandle _Nonnull)completionBlock
           failedBlock:(FailedLoadBlock _Nonnull)failedBlock
{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if ([httpMethod isEqualToString:@"GET"]) {
        //发送GET请求
        [sessionManager GET:urlstring parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%lld", downloadProgress.totalUnitCount);
            if (progressBlock != nil) {
                progressBlock(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功JSON:%@", JSON);
            if (completionBlock != nil) {
                completionBlock(JSON);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (failedBlock != nil) {
                failedBlock([error localizedDescription]);
            }
        }];

    }else if ([httpMethod isEqualToString:@"POST"]) {
        //发送POST请求
        BOOL isFile = NO;
        for (NSString *key in params) {
            id value = params[key];
            if (value != nil) {
                if ([value isKindOfClass:[NSData class]]) {
                    isFile = YES;
                    break;
                }
            }
        }
        if (!isFile) {
            //如果参数中没有文件
                [sessionManager POST:urlstring parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                        if (progressBlock != nil) {
                            progressBlock(uploadProgress);
                        }
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       NSLog(@"请求成功:%@", responseObject);
          
                        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        NSLog(@"请求成功JSON:%@", JSON);
                        if (completionBlock != nil) {
                        completionBlock(JSON);
                    }
                    
                  
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if (failedBlock != nil) {
                            failedBlock([error localizedDescription]);
                    }
                     
                }];
        } else {
            //如果参数中带有参数
            [sessionManager POST:urlstring parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString *key in params) {
                    id value = params[key];
                    if ([value isKindOfClass:[NSData class]]) {
                        //将文件添加到formData中
                        [formData appendPartWithFileData:value
                                                    name:key
                                                fileName:@"jpg"
                                                mimeType:@"image/jpeg"];
                    }
                }

            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock != nil) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"请求成功JSON:%@", JSON);
                if (completionBlock != nil) {
                    completionBlock(JSON);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock != nil) {
                    failedBlock([error localizedDescription]);
                }

            }];
        }
    }
   //设置返回数据的解析方式
//    sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
//    return operation;
}


@end
