//
//  CUUser CUUserManager.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserManager.h"
#import "CUServerAPIConstant.h"
#import "AppCore.h"
#import "CUUserParser.h"
#import "SNPlatFormManager.h"
#import "SNNetworkClient.h"
#import "JSONKit.h"
#import "Address.h"
#import "SNHTTPRequestOperationWrapper.h"
#import "TipHandler+HUD.h"


@implementation CUUserManager

SINGLETON_IMPLENTATION(CUUserManager);

- (BOOL)isLogin
{
    return (self.user.token != nil)?YES:NO;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.user = [[CUUser alloc] init];
    }
    return self;
}

- (void)load
{
    CUUser * user = [[AppCore sharedInstance].fileAccessManager loadObjectForKey:Plist_User error:nil];
    if (user != nil)
    {
        self.user = user;
    }
}

- (void)save
{
    [[AppCore sharedInstance].fileAccessManager saveObject:self.user forKey:Plist_User error:nil];
}

- (void)clear
{
    self.user.token = nil;
    self.user.profile = nil;
    self.user.nickname = nil;
    self.user.cellPhone = nil;
    self.user.userId = -1;
    self.user.points = 0;
    self.user.gender = 0;
    self.user.age = 0;
    self.user.level = 0;
    self.user.name = nil;
    [[AppCore sharedInstance].fileAccessManager removeObjectForKey:Plist_User error:nil];
}

@end

@implementation CUUserManager (Network)

// 获取手机验证码
- (void)requireVerifyCodeWithCellPhone:(NSString *)cellPhone resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:@"0" forKey:@"token"];
    [param setObjectSafely:@"PhoneVerify" forKey:@"require"];
    [param setObjectSafely:@(10000) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@"user" forKey:@"appType"];
    [dataParam setObjectSafely:cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:@"0" forKey:@"phoneCode"];
    [dataParam setObjectSafely:[SNPlatformManager deviceString] forKey:@"clientType"];
    [dataParam setObjectSafely:@"1.0.1" forKey:@"clientVer"];
    [dataParam setObjectSafely:[SNPlatformManager deviceId] forKey:@"device"];
    [dataParam setObjectSafely:[SNPlatformManager deviceIdAddress] forKey:@"ip"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:resultBlock
      forKey:@"PhoneVerify" forPageNameGroup:pageName];
}

// 注册
- (void)registerWithCellPhone:(NSString *)cellPhone verifyCode:(NSInteger)verifyCode resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"kPlatForm user" forKey:@"from"];
    [param setObjectSafely:@"V1.0" forKey:@"version"];
    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
    [param setObjectSafely:@"0" forKey:@"token"];
    [param setObjectSafely:@"register" forKey:@"require"];
    [param setObjectSafely:@"0" forKey:@"lantitude"];
    [param setObjectSafely:@"0" forKey:@"lontitude"];
    [param setObjectSafely:@"true" forKey:kPlatForm];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:@(verifyCode) forKey:@"code"];
    [dataParam setObjectSafely:self.user.codetoken forKey:@"codetoken"];
    [dataParam setObjectSafely:@"0" forKey:@"accountid"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
//    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
//        if (!result.hasError && ![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue])
        if (!result.hasError)
        {
            // 赋值user数据
            blockSelf.user.token = [result.responseObject stringForKeySafely:@"token"];
            blockSelf.user.cellPhone = [[result.responseObject dictionaryForKeySafely:@"data"] stringForKeySafely:@"phone"];
            blockSelf.user.userId = [[result.responseObject dictionaryForKeySafely:@"data"] integerForKeySafely:@"iduser"];
            [blockSelf save];
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

// 手机号+验证码登录
- (void)loginWithCellPhone:(NSString *)cellPhone code:(NSString *)code codetoken:(NSString *)codetoken resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:codetoken forKey:@"token"];
    [param setObjectSafely:@"UserLogin" forKey:@"require"];
    [param setObjectSafely:@(13002) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(0) forKey:@"accID"];
    [dataParam setObjectSafely:@([cellPhone longLongValue]) forKey:@"phone"];
    [dataParam setObjectSafely:codetoken forKey:@"token"];
    [dataParam setObjectSafely:code forKey:@"phoneCode"];
    [dataParam setObjectSafely:[SNPlatformManager deviceString] forKey:@"clientType"];
    [dataParam setObjectSafely:@"1.0.1" forKey:@"clientVer"];
    [dataParam setObjectSafely:[SNPlatformManager deviceId] forKey:@"device"];
    [dataParam setObjectSafely:[SNPlatformManager deviceIdAddress] forKey:@"ip"];
    [dataParam setObjectSafely:@"成都市" forKey:@"region"];
    [dataParam setObjectSafely:kCurrentLat forKey:@"latitude"];
    [dataParam setObjectSafely:kCurrentLng forKey:@"longtitude"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    __block CUUserManager * blockSelf = self;
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            // 赋值user数据
            NSInteger err_code = [[result.responseObject valueForKey:@"errorCode"]integerValue];
            switch (err_code) {
                case 0:{

                    
                    NSDictionary *data = [result.responseObject dictionaryForKeySafely:@"data"];
                    
                    blockSelf.user.userId = [data integerForKeySafely:@"accID"];
                    blockSelf.user.nickname = [data stringForKeySafely:@"nickname"];
                    blockSelf.user.name = [data stringForKeySafely:@"name"];
                    blockSelf.user.icon = [data stringForKeySafely:@"icon"];
                    blockSelf.user.cellPhone =  [data stringForKeySafely:@"phone"];
                    blockSelf.user.token =  [data stringForKeySafely:@"token"];
                    blockSelf.user.age =  [[data objectForKeySafely:@"age"] integerValue];
                    NSString * sexStr = [data stringForKeySafely:@"sex"];
                    if([sexStr isEqualToString:@"女"]) {
                        blockSelf.user.gender = CUUserGenderFemale;
                    }
                        
                    if ([sexStr isEqualToString:@"男"]) {
                        blockSelf.user.gender = CUUserGenderMale;
                    }
                    
                    NSLog(@"cellPhone:%@",blockSelf.user.cellPhone);
                    NSLog(@"userId:%d",blockSelf.user.userId );
                    [blockSelf save];
                }
                    break;
                case -1:{
                    [TipHandler showTipOnlyTextWithNsstring:[NSString stringWithFormat:@"%@",[result.responseObject stringForKeySafely:@"data"]]];
                }
                    break;
                default:
                    break;
            }
        }else if(result.hasError){
            [TipHandler showTipOnlyTextWithNsstring:[NSString stringWithFormat:@"网络连接错误"]];
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}
- (void)loginWithCellPhone:(NSString *)name password:(NSString *)password resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"kPlatForm user" forKey:@"from"];
    [param setObjectSafely:@"V1.0" forKey:@"version"];
    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
    [param setObjectSafely:@"0" forKey:@"token"];
    [param setObjectSafely:@"login_my" forKey:@"require"];
    [param setObjectSafely:@"0" forKey:@"lantitude"];
    [param setObjectSafely:@"0" forKey:@"lontitude"];
    [param setObjectSafely:@"phonecode" forKey:@"logintype"];
    [param setObjectSafely:@"true" forKey:kPlatForm];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:name forKey:@"phone"];
    [dataParam setObjectSafely:password forKey:@"code"];
    [dataParam setObjectSafely:@"0" forKey:@"email"];
    [dataParam setObjectSafely:@"0" forKey:@"account"];
    [dataParam setObjectSafely:@"2" forKey:@"accountid"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseLoginWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError && ![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue])
        {
            // 赋值user数据
//            blockSelf.user.name = name;
//            blockSelf.user.userId = ((CUUser *)result.parsedModelObject).userId;
            blockSelf.user.token = [result.responseObject stringForKeySafely:@"token"];
            NSDictionary *data = [result.responseObject dictionaryForKeySafely:@"data"];
            
            blockSelf.user.cellPhone = [data stringForKeySafely:@"phone"];
            if ((NSNumber *)[data stringForKeySafely:@"ismail"]) {
            }
            blockSelf.user.userId = [data integerForKeySafely:@"no"];
            [blockSelf save];
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

// 99999 登出
- (void)logoutWithUser:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:99999 require:@"ExitAccount"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseLogoutWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            NSNumber * errorCode = [result.responseObject objectForKeySafely:@"errorcode"];
            if ([errorCode integerValue] != -1) {
                // 赋值user数据
                [blockSelf clear];
                [blockSelf save];
            }
        }
        resultBlock(request,result);
    }  forKey:URL_AfterBase forPageNameGroup:pageName];
}

// 获取用户信息
- (void)getUserInfo:(NSString *)token resultBlock:(SNServerAPIResultBlock)resultBlock// pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"kPlatForm user" forKey:@"from"];
    [param setObjectSafely:@"V1.0" forKey:@"version"];
    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
    [param setObjectSafely:token forKey:@"token"];
    [param setObjectSafely:@"myspace" forKey:@"require"];
    [param setObjectSafely:@"0" forKey:@"lantitude"];
    [param setObjectSafely:@"0" forKey:@"lontitude"];
    [param setObjectSafely:@"true" forKey:kPlatForm];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:[CUUserManager sharedInstance].user.cellPhone forKey:@"phone"];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    __block CUUserManager * blockSelf = self;
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError && ![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue])
        {
            // 赋值user数据
            NSDictionary *data = [result.responseObject dictionaryForKeySafely:@"data"];
            NSArray *expressAddressList = [data valueForKey:@"list_express_address"];
            [expressAddressList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                
                Address *addressItem = [[Address alloc] init];
                addressItem.cellPhone = [obj valueForKey:@"phone"];
                // TODO: Address数据结构与服务器返回不统一，且服务器返回明显有误
                
            }];
            [blockSelf save];
        }else{
            NSLog(@"获取用户信息 出错");
        }
        resultBlock(request,result);
    }   forKey:@"myspace"];
}

// 修改个人资料
- (void)updateUserInfo:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14100 require:@"PersonalProfile"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];

    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    [dataParam setObjectSafely:user.nickname forKey:@"nickname"];
    [dataParam setObjectSafely:user.name forKey:@"name"];
    [dataParam setObjectSafely:@(user.gender) forKey:@"sex"];
    [dataParam setObjectSafely:@(user.age) forKey:@"age"];
    [dataParam setObjectSafely:user.cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:user.nickname forKey:@"nickname"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    
    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUpdateUserInfoWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {

            // 赋值user数据
//            NSString * profile = user.profile;
//            NSString * nickname = user.nickname;
//            
//            if (profile != nil)
//            {
//                blockSelf.user.profile = profile;
//            }
//            if (nickname != nil)
//            {
//                blockSelf.user.nickname = nickname;
//            }
//            [blockSelf save];
 
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}



- (void)uploadAvatar:(UIImage *)image resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:[NSString stringWithFormat:@"%ld",(long)[CUUserManager sharedInstance].user.userId] forKey:@"imgofwho"];
    [param setObjectSafely:@"pud" forKey:@"imgtype"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.cellPhone forKey:@"phone"];
    
    SNNetworkClient * httpClient = [[SNNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://123.56.251.146:8080"]];
    
    NSMutableURLRequest * request = [httpClient multipartFormRequestWithMethod:@"POST" path:URL_ImageUpload parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:@"upload.png" mimeType:@"image/png"];
    }];
    
    SNHTTPRequestOperationWrapper *wrapper = [[SNHTTPRequestOperationWrapper alloc] initWithRequest:request successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
    }
    failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
                                                                                           
                                                                                       }];
    wrapper.uploadProgressBlock = ^(double progress, long long totalBytes, long long uploadedBytes){
        NSLog(@"%0.1f", progress);
        if (progressBlock) {
            progressBlock(progress);
        }
    };
    
    AFHTTPRequestOperation *operation = [[SNNetworkClient alloc] HTTPRequestOperationWithRequest:request wrapper:wrapper];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string objectFromJSONString];
        
        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        
        result.responseObject = dic;
        result.hasError = NO;
        resultBlock(nil, result);
        
        NSLog(@"传图片成功 %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        result.hasError = YES;
        resultBlock(nil, result);
    }];
    [operation start];
    
}

- (void)uploadImageArray:(NSMutableArray *)imageArray resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:[NSString stringWithFormat:@"%ld",(long)[CUUserManager sharedInstance].user.userId] forKey:@"imgofwho"];
    [param setObjectSafely:@"pud" forKey:@"imgtype"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.cellPhone forKey:@"phone"];
    
    SNNetworkClient * httpClient = [[SNNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://123.56.251.146:8080"]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:URL_ImageUpload parameters:param constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        for (int i = 0; i < imageArray.count; ++i) {
            UIImage *image = (UIImage *)[imageArray objectAtIndex:i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"file" fileName:[NSString stringWithFormat:@"DiseaseImage%d.png",i] mimeType:@"image/png"];
        }
    }];
    
    SNHTTPRequestOperationWrapper *wrapper = [[SNHTTPRequestOperationWrapper alloc] initWithRequest:request successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
    }
       failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
       
    }];
    wrapper.uploadProgressBlock = ^(double progress, long long totalBytes, long long uploadedBytes){
        NSLog(@"%0.1f", progress);
        if (progressBlock) {
            progressBlock(progress);
        }
    };
    
    AFHTTPRequestOperation *operation = [[SNNetworkClient alloc] HTTPRequestOperationWithRequest:request wrapper:wrapper];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string objectFromJSONString];
        
        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        
        result.responseObject = dic;
        result.hasError = NO;
        resultBlock(nil, result);
        
        NSLog(@"传图片成功 %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"传图片失败 %@",error);
    }];
    [operation start];
}

- (void)checkIfHasOldPasswordWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14000 require:@"CheckExistPwd"];
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:@selector(parseUpdateUserInfoWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        resultBlock(request,result);
    } forKey:@"CheckExistPwd" forPageNameGroup:pageName];
}

- (void)updateUser:(CUUser *)user oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:oldPassword forKey:@"password"];
    [param setObjectSafely:newPassword forKey:@"password"];
    
    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    [[AppCore sharedInstance].apiManager GET:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUpdateUserInfoWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)updateUser:(CUUser *)user password:(NSString *)password verifyCode:(NSString *)code resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:password forKey:@"password"];
    [param setObjectSafely:code forKey:@"code"];
    
    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    [[AppCore sharedInstance].apiManager GET:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUpdateUserInfoWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)updateUser:(CUUser *)user password:(NSString *)password resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"kPlatForm user" forKey:@"from"];
    [param setObjectSafely:@"V1.0" forKey:@"version"];
    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
//    [param setObjectSafely:@"this-token-for-debug" forKey:Key_Token];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:@"first_set_password" forKey:@"require"];
    [param setObjectSafely:@"0" forKey:@"lantitude"];
    [param setObjectSafely:@"0" forKey:@"lontitude"];
    [param setObjectSafely:@"true" forKey:kPlatForm];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
//    [dataParam setObjectSafely:@"15008441755" forKey:@"phone"];
    [dataParam setObjectSafely:user.cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:password forKey:@"code"];
    [dataParam setObjectSafely:user.codetoken forKey:@"codetoken"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
//    __block __weak CUUserManager *blockSelf = self;
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:resultBlock forKey:@"first_set_password" forPageNameGroup:pageName];
}

- (void)updateUser:(CUUser *)user emailAddress:(NSString *)emailAddress resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:@"V1.0" forKey:@"version"];
    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:@"account_mail" forKey:@"require"];
    [param setObjectSafely:kCurrentLat forKey:@"lantitude"];
    [param setObjectSafely:kCurrentLng forKey:@"lontitude"];
    [param setObjectSafely:@"true" forKey:kPlatForm];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:user.cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:user.codetoken forKey:@"codetoken"];
    [dataParam setObjectSafely:emailAddress forKey:@"newemail"];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    //    __block __weak CUUserManager *blockSelf = self;
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:resultBlock forKey:@"account_mail" forPageNameGroup:pageName];
}

- (void)getMyDiagnosisRecordsWithUser:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"MyDiagnosisRecords" forKey:@"require"];
    [param setObjectSafely:@(13103) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            // 赋值user数据
            NSInteger err_code = [[result.responseObject valueForKey:@"errorCode"]integerValue];
            switch (err_code) {
                case 0:{
                    
                    
                    NSDictionary *data = [result.responseObject dictionaryForKeySafely:@"data"];

                }
                    break;
                    
                default:
                    break;
            }
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

//11501接口 添加新约诊人
- (void)AddDiagnosisMemberWithDiagnosisID:(long long)diagnosisID name:(NSString *)name sex:(NSInteger)sex age:(NSInteger)age phone:(long long)phone resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"AddDiagnosisMember" forKey:@"require"];
    [param setObjectSafely:@(11501) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(diagnosisID) forKey:@"diagnosisID"];
    [dataParam setObjectSafely:name forKey:@"name"];
    [dataParam setObjectSafely:@(age) forKey:@"age"];
    [dataParam setObjectSafely:@(sex) forKey:@"sex"];
    [dataParam setObjectSafely:@(phone) forKey:@"phone"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            // 赋值user数据
            NSInteger err_code = [[result.responseObject valueForKey:@"errorCode"]integerValue];
            switch (err_code) {
                case 0:{
                    NSString *string = [[result.responseObject dictionaryForKeySafely:@"data"] valueForKey:@"userID"];
                    result.parsedModelObject = string;
                }
                    break;
                    
                default:
                    break;
            }
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

//14200 查询我的成员
- (void)getUserMemberListWithFilter:(UserFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14200 require:@"UserMemberList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:filter.listType forKey:@"listType"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSMutableArray * data = (NSMutableArray *)[result.responseObject arrayForKeySafely:@"data"];
                [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CUUser * user = [[CUUser alloc] init];
                    user.age = [obj integerForKeySafely:@"age"];
                    user.memberId = [obj integerForKeySafely:@"memberId"];
                    user.name = [obj stringForKeySafely:@"name"];
                    user.cellPhone = [obj stringForKeySafely:@"phone"];
                    NSString * str = [obj stringForKeySafely:@"sex"];
                    if ([str isEqualToString:@"女"]) {
                        user.gender = CUUserGenderFemale;
                    }
                    if ([str isEqualToString:@"男"]) {
                        user.gender = CUUserGenderMale;
                    }

                    [dataList addObjectSafely:user];
                }];
                
                SNBaseListModel * listModel  =[[SNBaseListModel alloc] init];
                listModel.items = dataList;
                result.parsedModelObject = listModel;
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"网络连接失败");
            [TipHandler showTipOnlyTextWithNsstring:@"网络连接失败"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"UserMemberList" forPageNameGroup:pageName];
    
}

//14201 新增我的成员
- (void)InsertMemberWithFilter:(UserFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:142001 require:@"InsertMember"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:filter.user.name forKey:@"name"];
    [dataParam setObjectSafely:filter.user.cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:(filter.user.gender == CUUserGenderMale?@"男":@"女") forKey:@"sex"];
    [dataParam setObjectSafely:@(filter.user.age) forKey:@"age"];
    [dataParam setObjectSafely:@(filter.pageSrc) forKey:@"pageSrc"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    NSString * s = [NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]];
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"UserMemberList" forPageNameGroup:pageName];
    
}

//14202 删除我的成员
- (void)DeleteMemberWithFilter:(UserFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"DeleteMember"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.user.memberId) forKey:@"memberId"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"UserMemberList" forPageNameGroup:pageName];
    
}

//14203 修改我的成员
- (void)ModifyMemberWithFilter:(UserFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14201 require:@"InsertMember"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:filter.user.name forKey:@"name"];
    [dataParam setObjectSafely:filter.user.cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:(filter.user.gender == CUUserGenderMale?@"男":@"女") forKey:@"sex"];
    [dataParam setObjectSafely:@(filter.user.age) forKey:@"age"];
    [dataParam setObjectSafely:@(filter.pageSrc) forKey:@"pageSrc"];
    [dataParam setObjectSafely:@(filter.user.memberId) forKey:@"memberId"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"UserMemberList" forPageNameGroup:pageName];
    
}

- (void)ModifyAvatorWithPath:(NSString *)path resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14101 require:@"AvatarPath"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:path forKey:@"avatarPath"];

    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        __weak __block CUUserManager * blockSelf = self;
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                blockSelf.user.icon = path;
                [blockSelf save];
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"UserMemberList" forPageNameGroup:pageName];
}

@end
