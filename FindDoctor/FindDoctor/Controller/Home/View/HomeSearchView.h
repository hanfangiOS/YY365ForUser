//
//  HomeSearchView.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeSearchViewDelegate

@required

@optional

@end

@interface HomeSearchView : UIView

@property (nonatomic, weak, nullable) id <HomeSearchViewDelegate> delegate;

- (void)resetData;

@end
