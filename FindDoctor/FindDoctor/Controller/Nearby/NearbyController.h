//
//  NearbyController.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/10/18.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "CUViewController.h"
#import "MapMerchantButtonView.h"
#import "HYCAnnotation.h"
#import "Clinic.h"

typedef void(^MapClickAction)(id merchant);

@class Doctor;

@interface NearbyController : CUViewController<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKRouteSearchDelegate>
{
    BMKMapView         *_mapView;
    BMKPoiSearch       *_poisearch;
    BMKRouteSearch     *_routesearch;
    BMKLocationService *_locService;
    MapMerchantButtonView     *_buttonView;
}

@property (nonatomic, copy) MapClickAction clickAction;

@property BOOL isMerchantList;

// 当前选中的商户
@property (nonatomic, strong) Clinic *merchant;

@property (nonatomic, retain) BMKAnnotationView *selectedAnnotationView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *pointAnnotations;

- (void)updateMapWithData:(NSArray *)dataArray;

- (void)updateButtonView;

@end

