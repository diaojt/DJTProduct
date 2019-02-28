//
//  TYNetWorking.m
//  ToolYu
//
//  Created by LiuPW on 16/7/19.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import "EN_NetWorking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "EN_CacheData.h"
#import "EN_PrintLog.h"
#import "NSString+ENNetWorking.h"
#import "NSString+ENCheck.h"

#pragma mark 设置默认值

static NSString *tcen_privateNetworkBaseUrl = nil;
static BOOL en_isEnableInterfaceDebug = NO;
static BOOL en_shouldAutoEncode = NO;
static NSDictionary *en_httpHeaders = nil;
static ENResponseType en_responseType = ENResponseTypeJson;
static ENRequestType en_requestType = ENRequestTypeJson;
static ENNetWorkStatus en_networkStatus = ENNetWorkStatusReachableViaWIFI;
static NSMutableArray *en_requestTasks;
static BOOL en_cacheGet = YES;
static BOOL en_cachePost = NO;           //post 方法默认不做缓存
static BOOL en_shouldCallbackOnCancelRequest = YES;
static NSTimeInterval en_timeout = 30.0f;
static BOOL en_shouldObtainLocalWhenUnconnected = NO;
static BOOL en_isBaseURLChanged = YES;
static AFHTTPSessionManager *en_sharedManager = nil;
static NSUInteger en_maxCacheSize = 0;


@implementation EN_NetWorking

//如果设有最大缓存值，每次启动时，尝试清除缓存
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (en_maxCacheSize > 0 && [EN_CacheData totalCacheSize]>1024*1024*en_maxCacheSize) {
            [EN_CacheData clearCaches];
        }
    });
}

+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize
{
    en_maxCacheSize = mSize;
}

+ (void)cacheGetRequest:(BOOL)isCacheGet
{
    en_cacheGet = isCacheGet;
}

+ (void)cachePostRequest:(BOOL)isCachePost
{
    en_cachePost = isCachePost;
}

+ (void)updateBaseUrl:(NSString *)baseUrl
{
    
    //与原作者的判断条件不一样
    if (![baseUrl isEqualToString:tcen_privateNetworkBaseUrl] &&baseUrl && baseUrl.length) {
        en_isBaseURLChanged = YES;
    }
    else
    {
        en_isBaseURLChanged = NO;
    }
    
    tcen_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl
{
    return tcen_privateNetworkBaseUrl;
}

+ (void)setTimeOut:(NSTimeInterval)timeOut
{
    en_timeout = timeOut;
}

+ (void)startHttpsChallenge:(BOOL)start
{
    if (start) {
        //兼容HTTPS  正式环境需要安全策略进行更改
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName = YES;
        
        [self manager].securityPolicy = securityPolicy;
    }
    
}

+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain
{
    en_shouldObtainLocalWhenUnconnected = shouldObtain;
    en_cachePost = shouldObtain;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug
{
    en_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug
{
    return en_isEnableInterfaceDebug;
}

+ (NSMutableArray *)allTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (en_requestTasks == nil) {
            en_requestTasks = [[NSMutableArray alloc]init];
        }
    });
    return en_requestTasks;
}

+ (void)cancelAllRequest
{
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(ENURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[ENURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url
{
    if (url == nil) {
        return;
    }
    
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(ENURLSessionTask *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[ENURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                
                [task cancel];
                
                [[self allTasks] removeObject:task];
                
                return ;
            }
        }];
    };
}

+ (void)configRequestType:(ENRequestType)requestType
             responseType:(ENResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest
{
    en_requestType = requestType;
    en_responseType = responseType;
    en_shouldAutoEncode = shouldAutoEncode;
    en_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode
{
    return en_shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders
{
    en_httpHeaders = httpHeaders;
}

#pragma mark- Get请求
+ (ENURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(ENResponseSuccess)success
                            fail:(ENResponseFail)fail
{
    return [self getWithUrl:url
        refreshCache:refreshCache
                     params:@{}
             success:success
                fail:fail];
}

+ (ENURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(ENResponseSuccess)success
                            fail:(ENResponseFail)fail
{
    return [self getWithUrl:url
        refreshCache:refreshCache
              params:params
                   progress:nil
             success:success
                fail:fail];
}

+ (ENURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(TYGetProgress)progress
                         success:(ENResponseSuccess)success
                            fail:(ENResponseFail)fail
{
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                      httpMethod:1
                          params:params
                        progress:progress
                         success:success
                            fail:fail];
}

#pragma mark -POST 请求
+ (ENURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(ENResponseSuccess)success
                             fail:(ENResponseFail)fail
{
   return  [self postWithUrl:url
         refreshCache:refreshCache
               params:params
             progress:nil
              success:success
                 fail:fail];
}

+ (ENURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(TYPostProgress)progress
                          success:(ENResponseSuccess)success
                             fail:(ENResponseFail)fail
{
   return  [self _requestWithUrl:url
             refreshCache:refreshCache
               httpMethod:2
                   params:params
                 progress:progress
                  success:success
                     fail:fail];
}

#pragma mark -private
//初始化HTTPSessionManager
+ (AFHTTPSessionManager *)manager
{
    //互斥锁
    @synchronized (self) {
        //只要不切换baseURL，就一直使用同一个sessionManager
        if (en_sharedManager == nil || en_isBaseURLChanged) {
            
            en_isBaseURLChanged = NO;
            
            //开启转圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            AFHTTPSessionManager *mananger = nil;
            if ([self baseUrl] != nil) {
                mananger = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
            }
            else
            {
                mananger = [AFHTTPSessionManager manager];
            }
            
            //请求数据类型
            switch (en_requestType) {
                case ENRequestTypeJson:{
                    mananger.requestSerializer = [AFJSONRequestSerializer serializer];
                    
                    
                    break;
                }
                case ENRequestTypePlainText:{
                    mananger.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default:{
                    break;
                }
            }
            
            //返回数据类型
            switch (en_responseType) {
                case ENResponseTypeJson:{
                    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case ENResponseTypeXML:{
                    mananger.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case ENResponseTypeData:{
                    mananger.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default:
                    break;
            }
            
            mananger.requestSerializer.stringEncoding = NSUTF8StringEncoding;
          
            
            for (NSString *key in en_httpHeaders.allKeys) {
                if (en_httpHeaders[key] != nil) {
                    [mananger.requestSerializer setValue:en_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            mananger.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                       @"text/html",
                                                                                       @"text/json",
                                                                                       @"text/plain",
                                                                                       @"text/javascript",
                                                                                       @"text/xml",
                                                                                       @"image/*"]];
            
            mananger.requestSerializer.timeoutInterval = en_timeout;
            
            //兼容HTTPS  正式环境需要安全策略进行更改
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            securityPolicy.allowInvalidCertificates = YES;
            securityPolicy.validatesDomainName = NO;
            
//            mananger.securityPolicy = securityPolicy;
            
            //设置允许同时最大并发量，过大容易出问题
            mananger.operationQueue.maxConcurrentOperationCount = 3;
            
            en_sharedManager = mananger;
            
        }
    }
    
    return en_sharedManager;
}
#pragma mark -发起请求
+ (ENURLSessionTask *)_requestWithUrl:(NSString *)url
                         refreshCache:(BOOL)refreshCache
                           httpMethod:(NSInteger)httpMethod
                               params:(NSDictionary *)params
                             progress:(ENDownLoadProgress)progress
                              success:(ENResponseSuccess)success
                                 fail:(ENResponseFail)fail
{
    //如果没有网络且不允许读取缓存时，直接返回错误
    if (!en_shouldObtainLocalWhenUnconnected &&
        (en_networkStatus == ENNetWorkStatusUnknown || en_networkStatus == ENNetWorkStatusNotReachable)) {
            if(fail){
                NSError *error = [NSError errorWithDomain:@"no netWork" code:5001 userInfo:nil];
                fail(error);
            }
    }
    
    if ([self shouldEncode]) {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSString *absoluteUrl = [self absoluteUrlWithPath:url];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试EncodeURL");
            return nil;
        }
    }
    else
    {
        NSURL *absoluteURL = [NSURL URLWithString:absoluteUrl];
        if (absoluteURL ==nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试EncodeURL");
        }
    }
    
    ENURLSessionTask *session = nil;
    
    if (httpMethod == 1) {
        //get 请求
        if (en_cacheGet) {
            //获取缓存相关操作
            
            //网络状况不佳时，从本地读取
            if (en_shouldObtainLocalWhenUnconnected) {
                if (en_networkStatus == ENNetWorkStatusUnknown || en_networkStatus == ENNetWorkStatusNotReachable) {
                    id response = [EN_CacheData readCacheResponseWithURL:url
                                                               params:params];
                    
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                        
                        
                            if ([self isDebug]) {
                                [EN_PrintLog logWithSuccessResponse:response
                                                         url:url
                                                      params:params];
                            }
                        }
                        return  nil;
                    }
                }
            }
            
            if (!refreshCache) {
                //获取缓存
                id response = [EN_CacheData readCacheResponseWithURL:url
                                                           params:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [EN_PrintLog logWithSuccessResponse:response
                                                     url:url
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
            
        }
        
        
        session = [manager GET:url
                    parameters:params
                      progress:^(NSProgress * _Nonnull downloadProgress) {
                          if (progress) {
                              progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
                          }
                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          //成功后，处理回调函数
                          [self successResponse:responseObject
                                       callback:success];
                          
                          //判断是否需要缓存，若需要则进行数据缓存
                          if (en_cacheGet) {
                              [EN_CacheData cacheResponseObject:responseObject
                                                     request:task.currentRequest
                                                  parameters:params];
                          }
                          
                          //移除当前任务
                          [[self allTasks] removeObject:task];
                          
                          if ([self isDebug]) {
                              [EN_PrintLog logWithSuccessResponse:responseObject
                                                       url:url
                                                    params:params];
                          }
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          [[self allTasks]removeObject:task];
                          
                          if ([error code] < 0 && en_cacheGet) {
                              id response = [EN_CacheData readCacheResponseWithURL:absoluteUrl
                                                                         params:params];
                              
                              if (response) {
                                  if (success) {
                                      [self successResponse:response callback:success];
                                      
                                      if ([self isDebug]) {
                                          [EN_PrintLog logWithSuccessResponse:response
                                                                   url:url
                                                                params:params];
                                      }
                                  }
                              }
                              else{
                                  [self handleCallbackWithError:error
                                                           fail:fail];
                                  
                                  if ([self isDebug]) {
                                      [self logWithFailError:error
                                                         url:absoluteUrl
                                                      params:params];
                                  }
                              }
                          }
                          else
                          {
                              [self handleCallbackWithError:error fail:fail];
                              
                              if ([self isDebug]) {
                                  [self logWithFailError:error url:absoluteUrl params:params];
                              }
                          }
                      }];
        
    }
    
    else if(httpMethod == 2){
    //POST 请求
        if(en_cachePost)
        {
            if (en_shouldObtainLocalWhenUnconnected) {
                if (en_networkStatus == ENNetWorkStatusUnknown || en_networkStatus==ENNetWorkStatusNotReachable) {
                    id response = [EN_CacheData readCacheResponseWithURL:absoluteUrl
                                                               params:params];
                    
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [EN_PrintLog logWithSuccessResponse:response
                                                         url:absoluteUrl
                                                      params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            
            if (!refreshCache) {
                id response = [EN_CacheData readCacheResponseWithURL:absoluteUrl
                                                           params:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [EN_PrintLog logWithSuccessResponse:response
                                                     url:absoluteUrl
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        session = [manager POST:url
                     parameters:params
                       progress:^(NSProgress * _Nonnull downLoadProgress) {
                           if (progress) {
                               progress(downLoadProgress.completedUnitCount,downLoadProgress.totalUnitCount);
                           }
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                           [self successResponse:responseObject callback:success];
                           
                            //是否缓存数据
                           if (en_cachePost) {
                               [EN_CacheData cacheResponseObject:responseObject request:task.currentRequest parameters:params];
                           }
                           
                           [[self allTasks] removeObject:task];
                           
                           if ([self isDebug]) {
                               NSLog(@"task.currentRequest.allHTTPHeaderFields:%@",task.currentRequest.allHTTPHeaderFields);
                               [EN_PrintLog logWithSuccessResponse:responseObject url:absoluteUrl params:params];
                           }
                           
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                           //从任务队列中移除本次请求
                           [[self allTasks]removeObject:task];
                           
                           if ([error code]<0 && en_cachePost) {
                               //获取缓存
                               id response = [EN_CacheData readCacheResponseWithURL:absoluteUrl params:params];
                               
                               if (response && success) {
                                   
                                   [self successResponse:response callback:success];
                                   
                                   if ([self isDebug]) {
                                       [EN_PrintLog logWithSuccessResponse:response url:absoluteUrl params:params];
                                   }
                               }
                               else
                               {
                                   [self handleCallbackWithError:error fail:fail];;
                                   
                                   if ([self isDebug]) {
                                       [self logWithFailError:error url:absoluteUrl params:params];
                                   }
                               }
                           }
                           else
                           {
                               [self handleCallbackWithError:error fail:fail];
                               
                               if ([self isDebug]) {
                                   [self logWithFailError:error url:absoluteUrl params:params];
                               }
                           }
                       }];
    }
    
    if (session) {
        [[self allTasks]addObject:self];
    }
    
    return session;
}



#pragma mark -上传文件
+ (ENURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(ENUploadProgress)progress
                                success:(ENResponseSuccess)success
                                   fail:(ENResponseFail)fail
{
    if ([NSURL URLWithString:uploadingFile] == nil) {
        NSLog(@"uploadFile 无效，无法生成URL，请检查待传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    }
    else
    {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]];
    }
    
    if (uploadURL == nil) {
        NSLog(@"UpLoadUrl 无效，无法生成URL，可能是因为有中文的原因，尝试进行编码");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    ENURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request
     
                          fromFile:[NSURL URLWithString:uploadingFile]
     
                          progress:^(NSProgress * _Nonnull uploadProgress) {
                                if (progress) {
                                    progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                                }
                            }
                 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                     
                     [[self allTasks] removeObject:session];
                     
                     [self successResponse:responseObject callback:success];
                     
                     if(error){
                         [self handleCallbackWithError:error fail:fail];
                         
                         if ([self isDebug]) {
                             [self logWithFailError:error
                                                url:url
                                             params:nil];
                         }
                     }
                     else
                     {
                         if ([self isDebug]) {
                             [EN_PrintLog logWithSuccessResponse:responseObject
                                                      url:response.URL.absoluteString
                                                   params:nil];
                         }
                     }
                 }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark -上传照片
+ (ENURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             fileName:(NSString *)fileName
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(ENUploadProgress)progress
                              success:(ENResponseSuccess)success
                                 fail:(ENResponseFail)fail
{
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"urlString 无效，无法生成URL，可能是因为有中文的原因，请尝试encodeURL");
            return nil;
        }
    }
    else
    {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]] == nil) {
            NSLog(@"URLString 无效，无法生成URL，可能是因为有中文的原因，请尝试encodeURL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absoluteString = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager = [self manager];
    ENURLSessionTask *uploadSession = [manager POST:url
                                   parameters:parameters
                    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        NSData *imageData = UIImageJPEGRepresentation(image, 1);
                        
                        NSString *imageFileName = fileName;
                        if (fileName == nil || fileName.length == 0 || ![fileName isKindOfClass:[NSString class]]) {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                            dateFormatter.dateFormat = @"yyyyMMddHHmmss";
                            NSString *str = [dateFormatter stringFromDate:[NSDate date]];
                            imageFileName = [NSString stringWithFormat:@"%@.jpg",str];
                        }
                        
                        //上传图片，以文件流格式
                        [formData appendPartWithFileData:imageData
                                                    name:name
                                                fileName:imageFileName
                                                mimeType:mimeType];
                        
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
                        
                        [[self allTasks] removeObject:uploadSession];
                        
                        [self successResponse:responseObject callback:success];
                        
                        if ([self isDebug]) {
                            [EN_PrintLog logWithSuccessResponse:responseObject
                                                     url:absoluteString
                                                  params:parameters];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [[self allTasks] removeObject:uploadSession];
                        
                        [self handleCallbackWithError:error fail:fail];
                        
                        if ([self isDebug]) {
                            [self logWithFailError:error url:absoluteString params:parameters];
                        }
                    }];
    //开始工作
    [uploadSession resume];
    
    if (uploadSession) {
        [[self allTasks] addObject:uploadSession];
    }
    
    return uploadSession;
}

#pragma mark 下载
+ (ENURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(ENDownLoadProgress)progress
                              success:(ENResponseSuccess)success
                                 fail:(ENResponseFail)fail
{
    if ([self baseUrl]==nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString 无效，无法生成URL，可能是因为有中文，请尝试encodeURL");
            return nil;
        }
    }
    else
    {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]]== nil) {
            NSLog(@"URLString 无效，无法生成URL，可能是因为有中文，请尝试encodeURL");
            return nil;
        }
    }
    
    //待确认是absoluteString或URL
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPSessionManager *manager = [self manager];
    
    ENURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest
                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                          progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
                                      } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                          return [NSURL fileURLWithPath:saveToPath];;
                                      } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                          
                                          [[self allTasks] removeObject:session];
                                         
                                          if (error == nil) {
                                              if (success) {
                                                  success(filePath.absoluteString);
                                              }
                                              
                                              if ([self isDebug]) {
                                                  NSLog(@"Download success for url %@",[self absoluteUrlWithPath:url]);
                                              }
                                          }
                                          else
                                          {
                                              [self handleCallbackWithError:error
                                                                       fail:false ];
                                              if ([self isDebug]) {
                                                  [self logWithFailError:error
                                                                     url:[self absoluteUrlWithPath:url]
                                                                  params:nil];
                                              }
                                          }
                                      }];
    [session resume];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (NSString *)encodeUrl:(NSString *)url
{
    return [self en_URLEncode:url];
}

+ (NSString *)en_URLEncode:(NSString *)url
{
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//获取绝对URL
+ (NSString *)absoluteUrlWithPath:(NSString *)path
{
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl]==nil || [self baseUrl].length == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString *mutalbePath = [NSMutableString stringWithString:path];
                [mutalbePath deleteCharactersInRange:NSMakeRange(0, 1)];
                
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],mutalbePath];
            }
            else{
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
            }
        }
        else
        {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
            }
            else
            {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",[self baseUrl],path];
            }
        }
    }
    
    return absoluteUrl;
}


+ (void)successResponse:(id)responseData callback:(ENResponseSuccess)success
{
    if (success) {
        success([self tryToPraseData:responseData]);
    }
}

//尝试解析json
+ (id)tryToPraseData:(id)responseData
{
    if ([responseData isKindOfClass:[NSData class]]) {
        if (responseData == nil) {
            return  responseData;
        }
        else
        {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            if (error != nil) {
                return responseData;
            }
            else
            {
                return response;
            }
        }
    }
    else
    {
        return responseData;
    }
}

+ (void)handleCallbackWithError:(NSError *)error fail:(ENResponseFail)fail
{
    if ([error code] == NSURLErrorCancelled) {
        if (en_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    }
    else
    {
        if (fail) {
            fail(error);
        }
    }
}


#pragma mark -判断网络状况
+ (void)detectNetwork
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachabilityManager startMonitoring];
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        if (status == AFNetworkReachabilityStatusUnknown)
        {
            en_networkStatus = ENNetWorkStatusUnknown;
        }
        else if(status == AFNetworkReachabilityStatusNotReachable)
        {
            en_networkStatus = ENNetWorkStatusNotReachable;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            en_networkStatus = ENNetWorkStatusReachableViaWWAN;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            en_networkStatus = ENNetWorkStatusReachableViaWIFI;
        }
    }];
}

#pragma mark -Debug Log
//+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params{
//    NSLog(@"\n");
//    NSLog(@"\nRequest success,URL: %@\n prams:%@\n  response:%@\n",
//             [NSString generateGetAbsoluteURL:url params:params],
//             params,
//             [self tryToPraseData:response]);
//}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params
{
    NSString *format = @"params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    NSLog(@"\n");
    
    if ([error code] == NSURLErrorCancelled) {
        NSLog(@"Request was canceled manully,URL:%@ %@ %@\n",[NSString generateGetAbsoluteURL:url params:params],format,params);
    }
    else
    {
        NSLog(@"\n Request error, URL:%@ %@%@\n errorInfo:%@\n\n",
                 [NSString generateGetAbsoluteURL:url params:params],format,params,[error localizedDescription]);
    }
}
@end
