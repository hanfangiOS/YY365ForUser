//
//  SubObject.h
//  FindDoctor
//
//  Created by chai on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFFilter.h"

@interface SubObject : NSObject

@property long long type_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *localImageName;

@end

@interface SubObjectFilter : HFFilter

@end
