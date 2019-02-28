//
//  TYNetWorking.h
//  ToolYu
//
//  Created by LiuPW on 16/7/19.
//  Copyright © 2016年 LiuPW. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  下载进度
 *
 *  @param bytesRead      已下载文件大小
 *  @param totalBytesRead 总文件大小
 */
typedef void (^ENDownLoadProgress)(int64_t bytesRead,
                                   int64_t totalBytesRead);


typedef ENDownLoadProgress TYGetProgress;
typedef ENDownLoadProgress TYPostProgress;


/**
 *  上传进度
 *
 *  @param bytesWritten      已上传的大小
 *  @param totalBytesWritten 总上传大小
 */
typedef void(^ENUploadProgress) (int64_t bytesWritten,
                                 int64_t totalBytesWritten);

typedef NS_ENUM(NSInteger, ENResponseType){
    ENResponseTypeJson = 1,//默认
    ENResponseTypeXML = 2, //XML
    //特殊情况下，已转换服务器就无法识别的，默认会尝试转换成JSON，若失败，则需要自己手动转换
    ENResponseTypeData = 3,
};

typedef NS_ENUM(NSInteger, ENRequestType){
    ENRequestTypeJson = 1,//默认为JSON传输
    ENRequestTypePlainText = 2,//普通text/html
};

typedef NS_ENUM(NSInteger,ENNetWorkStatus){
    ENNetWorkStatusUnknown = -1,//未知网络
    ENNetWorkStatusNotReachable = 0,//网络无连接
    ENNetWorkStatusReachableViaWWAN = 1,//2,3,4G网络
    ENNetWorkStatusReachableViaWIFI = 2,//WIFI网络
};

@class NSURLSessionTask;

//请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
//所有接口返回的类型都是基类NSURLSessionTask,若要接收返回值且处理，请转换成对应的子类型
typedef NSURLSessionTask ENURLSessionTask;

/**
 *  对请求结果进行处理
 *
 *  @param response 返回值
 */
typedef void(^ENResponseSuccess) (id response);
typedef void(^ENResponseFail) (NSError *error);


/**
 *  @author LiuPW, 16-07-19 17:07:29
 *
 *  基于AFNetWorking的网络层进行封装
 *  @这里只提供公共API
 */
@interface EN_NetWorking : NSObject
/**
 *  @author LiuPW, 16-07-19 17:07:54
 *
 *  用于指定网络请求接口的基础URL，如：http://henishuo.com或者http://101.200.209.244
 *  通常在APPDelegate中启动一次就可以了
 *  如果接口有来源于多个服务器，可以调用更新
 *
 *
 *  @param baseUrl 网络接口的基础URL
 */
+ (void)updateBaseUrl:(NSString*)baseUrl;
+ (NSString *)baseUrl;


/**
 *  @author LiuPW, 16-07-19 17:07:46
 *
 *  设置
 *
 *  @param timeOut 请求超时时间
 */
+ (void)setTimeOut:(NSTimeInterval)timeOut;



/**
 监听网络状态
 */
+ (void)detectNetwork;

/**
 是否开启HTTPS信任挑战
 默认关闭
 @param start 开启HTTPS信任挑战
 */
+ (void)startHttpsChallenge:(BOOL)start;

/**
 *  @author LiuPW, 16-07-19 19:07:58
 *
 *  当检测到网络状况异常时，是否从本地读取数据。默认为NO
 *  一旦这是为YES，设置刷新缓存时，若网络异常也会从缓存中读取数据
 *  同样，如果设置超时不回调，同样也会在网络异常时回调，除非本地没有数据
 *
 *  @param shouldObtain YES/NO
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;


/**
 *  @author LiuPW, 16-07-19 19:07:37
 *
 *  默认只会缓存Get数据，对Post请求是不缓存的。如果要缓存Post数据，需要手动调用设置
 *  对JSON数据类型有效，对于PLIST、XML不确定！
 *
 *  @param isCacheGet      默认为YES
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet;


/**
 是否缓存Post数据

 @param isCachePost 是否缓存 默认为NO
 */
//+ (void)cachePostRequest:(BOOL)isCachePost;

/**
 *  @author LiuPW, 16-07-19 21:07:44
 *
 *  获取缓存总大小 为便于文件维护，此方法放在cacheData中
 *
 *  @return 缓存大小
 */
//+ (unsigned long long)totalCacheSize;


/**
 *  @author LiuPW, 16-07-19 21:07:37
 *
 *  默认不会自动清除缓存，如果需要，可以设置自动清除缓存，并且需要制定上限
 *
 *  若达到了指定上限值，每次启动应用则尝试自动去清理缓存。
 *
 *  @param mSize 缓存上限大小。单位为M(兆)，默认为0，及不清理
 */
+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize;


/**
 *  @author LiuPW, 16-07-19 21:07:42
 *
 *  清除缓存 为便于维护，放在CacheData文件中
 */
//+ (void)clearCaches;


/**
 *  @author LiuPW, 16-07-19 21:07:18
 *
 *  开启或关闭打印信息
 *
 *  @param isDebug 开发期最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;


/**
 *  @author LiuPW, 16-07-19 21:07:18
 *
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType                   请求格式，默认为JSON
 *  @param responseType                  相应格式，默认为JSON
 *  @param shouldAutoEncode              YES/NO，默认为NO，是否自动encodeUrl
 *  @param shouldCallbackOnCancelRequest 当请求取消时，是否需要回调，默认为YES
 */

+ (void)configRequestType:(ENRequestType)requestType
             responseType:(ENResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;


/**
 *  @author LiuPW, 16-07-19 21:07:51
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;


/**
 *  @author LiuPW, 16-07-19 21:07:54
 *
 *  取消所有请求
 */
+ (void)cancelAllRequest;


/**
 *  @author LiuPW, 16-07-19 21:07:43
 *
 *  取消某个请求。如果要取消某个请求，最好是引用接口所返回来的ENURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *  @param url URL可以是绝对URL，也可以是PATH，也就是不包含baseURL
 */
+ (void)cancelRequestWithURL:(NSString *)url;

#pragma mark -get post请求
/**
 *  @author LiuPW, 16-07-19 21:07:32
 *
 *  GET 请求接口，若不指定URL，可传完整的URL
 *
 *  @param url          接口路径，如path/getArticleList
 *  @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人工判断
 *  @param success      接口成功请求道数据的回调
 *  @param fail         接口失败数据的回调
 *
 *  @return 返回的数据中有可取消请求的API
 */
+ (ENURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(ENResponseSuccess)success
                            fail:(ENResponseFail)fail;


//多一个params参数
+ (ENURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(ENResponseSuccess)success
                            fail:(ENResponseFail)fail;

//多带一个进度回调
+ (ENURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(TYGetProgress)progress
                         success:(ENResponseSuccess)success
                            fail:(ENResponseFail)fail;


/**
 *  @author LiuPW, 16-07-19 21:07:42
 *
 *  POST 请求接口，若不指定baseURL，可传完整的URL
 *
 *  @param url          接口路径，如path/getArticleList
 *  @param refreshCache 是否刷新缓存，默认为NO，仅在缓存开启时，才起作用
 *  @param params       接口中所需的参数，如@{“categoryID”：@(12)}
 *  @param success      接口成功请求得到数据的回调
 *  @param fail         接口请求失败得到的数据回调
 *
 *  @return 返回对象中有可取消请求的API
 */
+ (ENURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(ENResponseSuccess)success
                             fail:(ENResponseFail)fail;

+ (ENURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(TYPostProgress)progress
                          success:(ENResponseSuccess)success
                             fail:(ENResponseFail)fail;


#pragma Mark - 图片上传接口
/**
 *  @author LiuPW, 16-07-19 21:07:04
 *
 *  图片上传接口，若不指定baseURL，可传完整的URL
 *
 *  @param image      图片对象
 *  @param url        上传图片的接口路径，如path/images/
 *  @param fileName   给图片起一个名字，默认为当前日期时间，格式为”yyyyMMddHHmmss“,后缀为ijpg
 *  @param name       与指定的图片相关联的名称，由后端写入接口的人指定的
 *  @param mimeType   默认为iamge/jpeg
 *  @param parameters 参数
 *  @param progress   上传进度
 *  @param success    上传成功回调
 *  @Param fail       上传失败回调
 *  @return sessionTask
 */
+ (ENURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             fileName:(NSString *)fileName
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(ENUploadProgress)progress
                              success:(ENResponseSuccess)success
                                 fail:(ENResponseFail)fail;

/**
 *  @author LiuPW, 16-07-19 22:07:01
 *
 *  上传文件操作
 *
 *  @param url           上传路径
 *  @param uploadingFile 待上传文件的路径
 *  @param progress      上传进度
 *  @param success       上传成功回调
 *  @param fail       上传失败回调
 *
 *  @return session
 */
+ (ENURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(ENUploadProgress)progress
                                success:(ENResponseSuccess)success
                                   fail:(ENResponseFail)fail;

/**
 *  @author LiuPW, 16-07-19 22:07:11
 *
 *  下载文件
 *
 *  @param url        下载URL
 *  @param saveToPath 下载到哪个路径
 *  @param progress   下载进度
 *  @param success    下载成功回调
 *  @param fail       下载失败回调
 *
 *  @return  session
 */
+ (ENURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(ENDownLoadProgress)progress
                              success:(ENResponseSuccess)success
                                 fail:(ENResponseFail)fail;
@end
