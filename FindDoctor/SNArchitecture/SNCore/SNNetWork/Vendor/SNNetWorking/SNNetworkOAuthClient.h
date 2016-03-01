//
//  SNNetworkOAuthClient.h
//  Weibo
//
//  Created by Wade Cheng on 3/21/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNetworkClient.h"

@interface SNNetworkOAuthClient : SNNetworkClient
{
    BOOL _xAuth;						// YES for retrieving access token & access token secret by xAuth.
	NSString *_xAuthUsername;
	NSString *_xAuthPassword;
	NSString *_xAuthSource;				// Same as App key.
	NSString *_xAuthMode;				// Default is "client_auth"
	
	NSString *_consumerKey;				// App key.
	NSString *_consumerSecret;			// App secret.
	
	NSString *_tokenKey;				// OAuth token key.
	NSString *_tokenSecret;				// OAuth token secret.
	
	// Token or secret returned by the server, if found.
	NSString *_returnedTokenKey;
	NSString *_returnedTokenSecret;
	NSNumber *_returnedUserID;
	
	BOOL _shouldNotBuildOAuthHeaders;
}

@property (nonatomic, assign, getter=isXAuth) BOOL xAuth;
@property (nonatomic, retain) NSString *xAuthUsername;
@property (nonatomic, retain) NSString *xAuthPassword;
@property (nonatomic, retain) NSString *xAuthSource;
@property (nonatomic, retain) NSString *xAuthMode;
@property (nonatomic, retain) NSString *consumerKey;
@property (nonatomic, retain) NSString *consumerSecret;
@property (nonatomic, retain) NSString *tokenKey;
@property (nonatomic, retain) NSString *tokenSecret;
@property (nonatomic, readonly) NSString *returnedTokenKey;
@property (nonatomic, readonly) NSString *returnedTokenSecret;
@property (nonatomic, readonly) NSNumber *returnedUserID;
@property (nonatomic, assign) BOOL shouldNotBuildOAuthHeaders;

@end

@interface SNNetworkOAuth2Client : SNNetworkClient

@end