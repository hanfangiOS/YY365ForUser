//
//  SNNetworkOAuthClient.m
//  Weibo
//
//  Created by Wade Cheng on 3/21/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNNetworkOAuthClient.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"

static NSString *sn_RFC3986EncodedString(NSString *string) // UTF-8 encodes prior to URL encoding
{
    NSMutableString *result = [NSMutableString string];
    const char *p = [string UTF8String];
    unsigned char c;
    
    for(; (c = *p); p++)
    {
        switch(c)
        {
            case '0' ... '9':
            case 'A' ... 'Z':
            case 'a' ... 'z':
            case '.':
            case '-':
            case '~':
            case '_':
                [result appendFormat:@"%c", c];
                break;
            default:
                [result appendFormat:@"%%%02X", c];
        }
    }
    return result;
}

static NSString *sn_GUID()
{
    CFUUIDRef u = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, u);
    CFRelease(u);
    return [(NSString *)s autorelease];
}

static NSDictionary *sn_parseURLQueryString(NSString *string)
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [string componentsSeparatedByString:@"&"];
    for(NSString *pair in pairs)
    {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if([keyValue count] == 2)
        {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(key && value)
                [dict setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

static NSInteger sn_SortParameter(NSString *key1, NSString *key2, void *context)
{
	NSComparisonResult r = [key1 compare:key2];
	if(r == NSOrderedSame) { // compare by value in this case
		NSDictionary *dict = (NSDictionary *)context;
		NSString *value1 = [dict objectForKey:key1];
		NSString *value2 = [dict objectForKey:key2];
		return [value1 compare:value2];
	}
	return r;
}

static NSData *sn_HMAC_SHA1(NSString *data, NSString *key)
{
	unsigned char buf[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [data UTF8String], [data length], buf);
	return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
}

@interface SNNetworkClient()

- (NSMutableURLRequest *)_requestWithMethod:(NSString *)method 
                                       path:(NSString *)path 
                                 parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)_multipartFormRequestWithMethod:(NSString *)method
                                                    path:(NSString *)path
                                              parameters:(NSDictionary *)parameters
                               constructingBodyWithBlock:(void (^)(id <AFMultipartFormData>formData))block;

@end

@implementation SNNetworkOAuthClient

@synthesize xAuth = _xAuth;
@synthesize xAuthUsername = _xAuthUsername;
@synthesize xAuthPassword = _xAuthPassword;
@synthesize xAuthSource = _xAuthSource;
@synthesize xAuthMode = _xAuthMode;
@synthesize consumerKey = _consumerKey;
@synthesize consumerSecret = _consumerSecret;
@synthesize tokenKey = _tokenKey;
@synthesize tokenSecret = _tokenSecret;
@synthesize returnedTokenKey = _returnedTokenKey;
@synthesize returnedTokenSecret = _returnedTokenSecret;
@synthesize returnedUserID = _returnedUserID;
@synthesize shouldNotBuildOAuthHeaders = _shouldNotBuildOAuthHeaders;

/********************************************************************
 ** 方法功能说明: 建立OAuth验证请求头.
 ** 首先, 添加基本OAuth字段, 根据是否为xAuth验证, 区分加入的字段.
 ** 然后, 加入POST和GET请求字段, 校正URL地址字符串. 最后进行HMAC-SHA1加密.
 ** 最后, 将所有字段拼装成一个字符串, 加入在请求头中.
 ** 注: xAuth验证用于获取Access token和Access token secret.
 ** 参考: http://open.weibo.com/wiki/index.php/XAuth
 ** 代码源自OAuthCore https://bitbucket.org/atebits/oauthcore
 *******************************************************************/
- (void)buildAuthorizationHeaderForRequest:(NSMutableURLRequest *)request withPostBodyParameters:(NSDictionary *)postBodyParameters
{
	NSString *_oAuthNonce = sn_GUID();
	NSString *_oAuthTimestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
	NSString *_oAuthSignatureMethod = @"HMAC-SHA1";
	NSString *_oAuthVersion = @"1.0";
	
	NSMutableDictionary *oAuthAuthorizationParameters = [NSMutableDictionary dictionary];
	[oAuthAuthorizationParameters setObject:_oAuthNonce forKey:@"oauth_nonce"];
	[oAuthAuthorizationParameters setObject:_oAuthTimestamp forKey:@"oauth_timestamp"];
	[oAuthAuthorizationParameters setObject:_oAuthSignatureMethod forKey:@"oauth_signature_method"];
	[oAuthAuthorizationParameters setObject:_oAuthVersion forKey:@"oauth_version"];
	[oAuthAuthorizationParameters setObject:_consumerKey forKey:@"oauth_consumer_key"];
	
	if(_tokenKey)
		[oAuthAuthorizationParameters setObject:_tokenKey forKey:@"oauth_token"];
	
	if (_xAuth)
    {
		[oAuthAuthorizationParameters setObject:_xAuthUsername forKey:@"x_auth_username"];
		[oAuthAuthorizationParameters setObject:_xAuthPassword forKey:@"x_auth_password"];
		[oAuthAuthorizationParameters setObject:_xAuthMode forKey:@"x_auth_mode"];
	}
	
	// GET query and body parameters (POST).
	NSDictionary *additionalQueryParameters = sn_parseURLQueryString([request.URL query]);
	NSDictionary *additionalBodyParameters = postBodyParameters;
	
	// Combine all parameters.
	NSMutableDictionary *parameters = [[oAuthAuthorizationParameters mutableCopy] autorelease];
	if (additionalQueryParameters) [parameters addEntriesFromDictionary:additionalQueryParameters];
	if (additionalBodyParameters) [parameters addEntriesFromDictionary:additionalBodyParameters];
	
	// -> UTF-8 -> RFC3986.
	NSMutableDictionary *encodedParameters = [NSMutableDictionary dictionary];
	for(NSString *key in parameters)
    {
		NSString *value = [parameters objectForKey:key];
		[encodedParameters setObject:sn_RFC3986EncodedString(value) forKey:sn_RFC3986EncodedString(key)];
	}
	
	NSArray *sortedKeys = [[encodedParameters allKeys] sortedArrayUsingFunction:sn_SortParameter context:encodedParameters];
	
	NSMutableArray *parameterArray = [NSMutableArray array];
	for(NSString *key in sortedKeys)
    {
		[parameterArray addObject:[NSString stringWithFormat:@"%@=%@", key, [encodedParameters objectForKey:key]]];
	}
	NSString *normalizedParameterString = [parameterArray componentsJoinedByString:@"&"];
	
	NSString *normalizedURLString = [NSString stringWithFormat:@"%@://%@%@", [request.URL scheme], [request.URL host], [request.URL path]];
	
	NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@",
									 sn_RFC3986EncodedString([request HTTPMethod]),
									 sn_RFC3986EncodedString(normalizedURLString),
									 sn_RFC3986EncodedString(normalizedParameterString)];
	
	NSString *key = [NSString stringWithFormat:@"%@&%@",
					 sn_RFC3986EncodedString(_consumerSecret),
					 sn_RFC3986EncodedString(_tokenSecret)];
	
	NSData *signature = sn_HMAC_SHA1(signatureBaseString, key);
	NSString *base64Signature = [signature base64EncodedString];
	
	NSMutableDictionary *authorizationHeaderDictionary = [[oAuthAuthorizationParameters mutableCopy] autorelease];
	[authorizationHeaderDictionary setObject:base64Signature forKey:@"oauth_signature"];
	
	if (_xAuth) {
		[authorizationHeaderDictionary setObject:_xAuthSource forKey:@"source"];
	}
	
	NSMutableArray *authorizationHeaderItems = [NSMutableArray array];
	for(NSString *key in authorizationHeaderDictionary) {
		NSString *value = [authorizationHeaderDictionary objectForKey:key];
		[authorizationHeaderItems addObject:[NSString stringWithFormat:@"%@=\"%@\"",
                                             sn_RFC3986EncodedString(key),
                                             sn_RFC3986EncodedString(value)]];
	}
	
	NSString *authorizationHeaderString = [authorizationHeaderItems componentsJoinedByString:@", "];
	authorizationHeaderString = [NSString stringWithFormat:@"OAuth %@", authorizationHeaderString];
	
    [request addValue:authorizationHeaderString forHTTPHeaderField:@"Authorization"];
}

- (NSMutableURLRequest *)_requestWithMethod:(NSString *)method 
                                       path:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [super _requestWithMethod:method path:path parameters:parameters];
    
    if (!_shouldNotBuildOAuthHeaders)
    {
        NSDictionary *postBodyParameters = [[request HTTPMethod] isEqualToString:@"POST"] ? parameters : nil;
        [self buildAuthorizationHeaderForRequest:request withPostBodyParameters:postBodyParameters];
    }
    
    return request;
}

- (NSMutableURLRequest *)_multipartFormRequestWithMethod:(NSString *)method
                                                    path:(NSString *)path
                                              parameters:(NSDictionary *)parameters
                               constructingBodyWithBlock:(void (^)(id <AFMultipartFormData>formData))block
{
    NSMutableURLRequest *request = [super _multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:block];
    
    if (!_shouldNotBuildOAuthHeaders)
    {
        NSDictionary *postBodyParameters = [[request HTTPMethod] isEqualToString:@"POST"] ? parameters : nil;
        [self buildAuthorizationHeaderForRequest:request withPostBodyParameters:postBodyParameters];
    }
    
    return request;
}

- (void)dealloc
{
    [_xAuthUsername release];
    [_xAuthPassword release];
    [_xAuthSource release];
    [_xAuthMode release];
    [_consumerKey release];
    [_consumerSecret release];
    [_tokenKey release];
    [_tokenSecret release];
    [_returnedTokenKey release];
    [_returnedTokenSecret release];
	[_returnedUserID release];
	
	[super dealloc];
}

@end

@implementation SNNetworkOAuth2Client

@end
