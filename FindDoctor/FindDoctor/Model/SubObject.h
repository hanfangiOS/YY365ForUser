//
//  SubObject.h
//  FindDoctor
//
//  Created by chai on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubTypeObject @end

@interface SubTypeObject : NSObject

@property (nonatomic, copy) NSString *subType_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageURL;

@end

@interface SubObject : NSObject

@property NSInteger type_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <SubTypeObject> *sub_types;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *localImageName;

@end
