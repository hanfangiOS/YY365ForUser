//
//  SNTableView.h
//  YiRen
//
//  Created by Nova on 13-4-8.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNTableView : UITableView

- (void) reloadDataWithCompletion:( void (^) (void) )completionBlock;


@end
