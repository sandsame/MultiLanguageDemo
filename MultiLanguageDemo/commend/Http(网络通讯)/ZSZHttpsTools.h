//
//  ZSZHttpsTools.h
//  ZSZSecondAFNetworking
//
//  Created by 朱松泽 on 16/12/13.
//  Copyright © 2016年 gdtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock)(id responseObject);
typedef void (^HttpFailedBlock) (NSError *error);
typedef void (^HttpDownloadProgressBlock)(CGFloat progress);
typedef void (^HttpUploadProgressBlock) (NSProgress *progress);
typedef void (^HttpDownloadZSZHandleBlock) (NSURLResponse *response, NSURL *filePath, NSError *error);
typedef NSURL* (^HttpDownloadDestinationBlock) (NSURL *targetPath, NSURLResponse *response);


@interface ZSZHttpsTools : NSObject

/**
 *  get网络请求
 *
 *  @param path    请求路径
 *  @param params  url参数 NSDictinory类型
 *  @param success 请求成功 返回NSDictinory 或NSArray
 *  @param failure 请求失败 返回NSError
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure;


/**
 *  post网络请求
 *
 *  @param path    请求路径
 *  @param params  url参数 NSDictinory类型
 *  @param success 请求成功 返回NSDictinory 或NSArray
 *  @param failure 请求失败 返回NSError
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure;

/**
 *  post网络请求语音下载
 *
 *  参数同上
 */
+ (void)downLoadVoiceWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure;

/**
 *  下载文件
 *
 *  @param path     下载路径
 *  @param success  下载成功
 *  @param failure  下载失败
 *  @param progress 下载进度
 */
//+ (void)downloadWithPath:(NSString *)path andRequest:(NSURLRequest *)request success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure progress:(HttpDownloadProgressBlock)progress;

+ (void)downloadTaskWithRequest:(NSURLRequest *)request andProgress:(HttpUploadProgressBlock)progress destination:(HttpDownloadDestinationBlock)destination handle:(HttpDownloadZSZHandleBlock)myHandle;


/**
 *  上传图片
 *
 *  @param path     上传路径
 *  @param params   上传参数
 *  @param imageKey 关键字
 *  @param image    上传的图片
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */
+ (NSURLSessionDataTask *)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params imageKey:(NSString *)imageKey image:(NSData *)image fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(HttpSuccessBlock)success failure:(HttpFailedBlock)failure progress:(HttpUploadProgressBlock)progress;



@end
