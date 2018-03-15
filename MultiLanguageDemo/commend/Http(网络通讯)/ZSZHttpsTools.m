//
//  ZSZHttpsTools.m
//  ZSZSecondAFNetworking
//
//  Created by 朱松泽 on 16/12/13.
//  Copyright © 2016年 gdtech. All rights reserved.
//

#import "ZSZHttpsTools.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "ZSZNavigationController.h"
@interface AFHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
static AFHTTPClient *client = nil;
@implementation AFHTTPClient

+ (instancetype)sharedClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [AFHTTPClient manager];
        //     dispatch_queue_t myQueue = dispatch_queue_create("ZSZAFNetWorkingQueue", DISPATCH_QUEUE_SERIAL);
        //     [client setCompletionQueue:myQueue];
        client.requestSerializer.timeoutInterval = 8;
        client.requestSerializer = [AFHTTPRequestSerializer serializer];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
//        client.responseSerializer = [AFHTTPResponseSerializer serializer];
//        client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        client.requestSerializer = requestSerializer;
        
        // 接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"application/x-json", nil];
        //  安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    return client;
}


@end


@implementation ZSZHttpsTools

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure {
    // 获取完整的路径
    [[AFHTTPClient sharedClient] GET:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [self dictionaryWithJsonString:receiveStr];
        if (dict[@"error"][@"code"] != nil && [dict[@"error"][@"code"] isEqualToString:@"-32604"]) {
            // 把login标志置为NO
            [DataBaseManager shareDataManager].isLogin = NO;
            [SimpleAlertView showAlert:@"请重新登录账号~"];
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            ZSZNavigationController *nav = [[ZSZNavigationController alloc] initWithRootViewController:loginVC];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        success(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure {
    
    // 获取完整的路径
    [[AFHTTPClient sharedClient] POST:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [self dictionaryWithJsonString:receiveStr];
        if (dict[@"error"][@"code"] != nil && [[dict[@"error"][@"code"] description] isEqualToString:@"-32604"]) {
            // 把login标志置为NO
            [DataBaseManager shareDataManager].isLogin = NO;
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            ZSZNavigationController *nav = [[ZSZNavigationController alloc] initWithRootViewController:loginVC];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        success(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//下载音频
+ (void)downLoadVoiceWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure {
    
    [[AFHTTPClient sharedClient] POST:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
    
    
}

//+ (void)downloadWithPath:(NSString *)path andRequest:(NSURLRequest *)request success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure progress:(HttpDownloadProgressBlock)progress {
//
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
////    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
////    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    [downloadTask resume];
//
//}


+ (void)downloadTaskWithRequest:(NSURLRequest *)request andProgress:(HttpUploadProgressBlock)progress destination:(HttpDownloadDestinationBlock)destination handle:(HttpDownloadZSZHandleBlock)myHandle {
    
    NSURLSessionDownloadTask *downloadTask = [[AFHTTPClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return  destination(targetPath,response);
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        myHandle(response,filePath,error);
    }];
    
    [downloadTask resume];
    
}

+ (NSURLSessionDataTask *)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params imageKey:(NSString *)imageKey image:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure progress:(HttpUploadProgressBlock)progress {
    
    //    NSData *data = [NSData data];
    //    if (image != nil) {
    //       data = UIImagePNGRepresentation(image);
    //    }
    
    
    NSURLSessionDataTask *task = [[AFHTTPClient sharedClient] POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (data.class == [UIImage class]) {
            NSData *imageData = UIImagePNGRepresentation((UIImage *)data);
            if (!imageData) {
                imageData = UIImageJPEGRepresentation((UIImage *)data, 1);
            }
            [formData appendPartWithFileData:imageData name:imageKey fileName:fileName mimeType:mimeType];
        } else {
            if (!data) {
                NSData *nonData = [NSData data];
                [formData appendPartWithFileData:nonData name:imageKey fileName:fileName mimeType:mimeType];
            } else {
                [formData appendPartWithFileData:data name:imageKey fileName:fileName mimeType:mimeType];
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    return task;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

@end

