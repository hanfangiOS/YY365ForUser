//
//  NearbyController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/10/18.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "NearbyController.h"

#import "UIConstants.h"
#import "UIBarButtonItem+CommenButton.h"
#import "StarRatingView.h"
#import "Doctor.h"
#import "MapMerchantView.h"
#import "MapMerchantButtonView.h"
#import "SNLocationManager.h"
#import "TipHandler+HUD.h"
#import "CUClinicManager.h"
#import "SNBaseListModel.h"
#import "MBProgressHUD.h"
#import "ClinicMainViewController.h"

@interface NearbyController ()<MapMerchantViewDelegate>

// 长按选中的点
@property (nonatomic, strong) TapLocationAnnotation *currentLocation;
@property (nonatomic, strong) BMKAnnotationView *tapLocationView;

//@property (nonatomic, strong) UIImageView *tapLocationView;

@end

@implementation NearbyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)requestDataAtPage:(NSInteger)page
{
    ClinicFilter *filter = [[ClinicFilter alloc] init];
    filter.regionID = 510100;
    filter.latitude = [kCurrentLat floatValue];
    filter.longitude = [kCurrentLng floatValue];
    
    __weak typeof(self) weakSelf = self;
    
    [[CUClinicManager sharedInstance] getClinicNearbyListWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (!result.hasError)
        {
            SNBaseListModel *listModel = result.parsedModelObject;
            NSArray *arr = listModel.items;
            if (arr.count) {
                if (page == 0) {
                    weakSelf.dataArray = [NSMutableArray array];
                }
                
                [weakSelf.dataArray addObjectsFromArray:arr];
                
                [weakSelf updateMapWithData:weakSelf.dataArray];
            }
        }
    } pageName:@"getMapDoctorList"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"附近医生";
    self.view.backgroundColor = kTableViewGrayColor;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds) - Height_Tabbar)];
    [_mapView setZoomLevel:13];
    _mapView.isSelectedAnnotationViewFront = YES;
    //_mapView.showsUserLocation = YES;
    //_mapView.userTrackingMode = BMKUserTrackingModeNone;
    [self.contentView addSubview:_mapView];
    
    _poisearch = [[BMKPoiSearch alloc] init];
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    
    _mapView.delegate = self;
    _poisearch.delegate = self;
    
//    [self initButtonView];
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = (id)self;
    [_locService startUserLocationService];
    
    [_mapView setCenterCoordinate:{[kCurrentLat floatValue], [kCurrentLng floatValue]} animated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self requestDataAtPage:0];
}

- (void)initButtonView
{
    _buttonView = [[MapMerchantButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - [MapMerchantButtonView defaultHeight], kScreenWidth, [MapMerchantButtonView defaultHeight])];
    [self.view addSubview:_buttonView];
    
    __block typeof(self) weakSelf = self;
    _buttonView.gpsAction = ^{
        [weakSelf onClickGPS];
    };
    
    _buttonView.routeAction = ^{
        [weakSelf onClickDriveSearch];
    };
}

- (void)initNavigationBar
{
    
}

- (void)updateButtonView
{
    _buttonView.title = self.merchant.name;
//    _buttonView.address = self.merchant.address;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestDataAtPage:0];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
    
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    
    if (_currentLocation!=nil) {
        [_currentLocation release];
        _currentLocation = nil;
    }
    
    if (_poisearch != nil) {
        [_poisearch release];
        _poisearch = nil;
    }
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
    [super dealloc];
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"] autorelease];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    else if ([annotation isKindOfClass:[TapLocationAnnotation class]]) {
        static NSString *AnnotationViewID = @"TapPointMark";
        
        BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (annotationView == nil) {
            annotationView = [[[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
            annotationView.draggable = NO;
        }
        
        UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/pin_red.png"]];
        annotationView.image = image;
        
        self.tapLocationView = annotationView;
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        // 生成重用标示identifier
        static NSString *AnnotationViewID = @"MpaListPointMark";
        
        // 检查是否有重用的缓存
        BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (annotationView == nil) {
            annotationView = [[[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
            annotationView.canShowCallout = YES;
            annotationView.draggable = NO;
        }
        
        if (annotationView.paopaoView == nil) {
            MapMerchantView *paopaoView = [[[MapMerchantView alloc] initWithFrame:CGRectMake(0, 0, [MapMerchantView defaultWidth], [MapMerchantView defaultHeight])] autorelease];
            paopaoView.delegate = self;
            annotationView.paopaoView = [[[BMKActionPaopaoView alloc] initWithCustomView:paopaoView] autorelease];
        }
        
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.calloutOffset = CGPointMake(annotationView.calloutOffset.x, 15);
        
        annotationView.annotation = annotation;
        
        int index = [self.pointAnnotations indexOfObject:annotation];
        if (annotationView.paopaoView.subviews.count) {
            MapMerchantView *paopaoView = (MapMerchantView *)[annotationView.paopaoView.subviews objectAtIndex:0];
            paopaoView.merchant = [self.dataArray objectAtIndex:index];
            [paopaoView update];
        }
        
        if (index == [self.dataArray indexOfObject:self.merchant]) {
            annotationView.image = [UIImage imageNamed:kAnnotationImageSel];
            
            [annotationView setSelected:YES];
            self.selectedAnnotationView = annotationView;
        }
        else {
            annotationView.image = [UIImage imageNamed:kAnnotationImageNor];
        }
        return annotationView;
    }
    
    return nil;
}

- (void)MapMerchantViewturnToClinicVCWithMerchant:(Clinic *)merchant{
    ClinicMainViewController *clinicMainViewController = [[ClinicMainViewController alloc]initWithPageName:@"NearbyController"];
    clinicMainViewController.clinic = merchant;
    [self.slideNavigationController pushViewController:clinicMainViewController animated:YES];
    NSLog(@"跳转啊跳转");
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[RouteAnnotation class]] || [view.annotation isKindOfClass:[TapLocationAnnotation class]]) {
        return;
    }
    
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        self.selectedAnnotationView.image = [UIImage imageNamed:kAnnotationImageNor];
        
        self.selectedAnnotationView = view;
        self.selectedAnnotationView.image = [UIImage imageNamed:kAnnotationImageSel];
        
        [mapView bringSubviewToFront:view];
        [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
        int index = [self.pointAnnotations indexOfObject:view.annotation];
        self.merchant = [self.dataArray objectAtIndex:index];
        [self updateButtonView];
    }
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    
}



- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[RouteAnnotation class]] || [view.annotation isKindOfClass:[TapLocationAnnotation class]]) {
        return;
    }
    
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if (self.clickAction) {
            int index = [self.pointAnnotations indexOfObject:view.annotation];
            self.clickAction([NSNumber numberWithInt:index]);
        }
    }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self removeRouteAnnotations];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = self.merchant.name;//@"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
                [item release];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

- (void)updateMapWithData:(NSArray *)dataArray
{
    [self updateMapWithData:dataArray animated:YES];
}

- (void)updateMapWithData:(NSArray *)dataArray animated:(BOOL)animated
{
    [self setupAnnotationsWithAnimated:animated];
}

- (void)removeRouteAnnotations
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    NSMutableArray *routeArray = [NSMutableArray array];
    for (RouteAnnotation *annotation in array) {
        if ([annotation isKindOfClass:[RouteAnnotation class]]) {
            [routeArray addObject:annotation];
        }
    }
    // 去掉路线节点的annotation（需过滤，以区别point annotation）
    [_mapView removeAnnotations:routeArray];
    
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
}

- (void)setupAnnotationsWithAnimated:(BOOL)animated
{
    self.selectedAnnotationView = nil;
    
    [self removeRouteAnnotations];
    
    // 清楚屏幕中所有的商户annotation
    if (self.pointAnnotations.count) {
        [_mapView removeAnnotations:self.pointAnnotations];
    }
    
    self.pointAnnotations = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        Clinic *merchant = (Clinic *)[self.dataArray objectAtIndex:i];
        
        if (i == 0) {
            self.merchant = merchant;
            [self updateButtonView];
        }
        
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
        item.coordinate = {merchant.latitude, merchant.longitude};
        item.title = merchant.name;
        [self.pointAnnotations addObject:item];
        
        if(i == 0 && animated) {
            //将第一个点的坐标移到屏幕中央
            _mapView.centerCoordinate = item.coordinate;
        }
        
        [item release];
    }
    
    if (self.pointAnnotations.count) {
        [_mapView addAnnotations:self.pointAnnotations];
    }
}

- (void)updateTapLocation:(CLLocationCoordinate2D)coordinate completion:(void (^)(void))completion
{
    if (self.currentLocation) {
        CGPoint p = [_mapView convertCoordinate:coordinate toPointToView:_mapView];
        
        [UIView animateWithDuration:.25 animations:^{
            self.tapLocationView.center = p;
        } completion:^ (BOOL isFinish) {
            [_mapView removeAnnotation:self.currentLocation];
            
            TapLocationAnnotation *tapAnnotation = [[[TapLocationAnnotation alloc] init] autorelease];
            tapAnnotation.coordinate = coordinate;
            self.currentLocation = tapAnnotation;
            [_mapView addAnnotation:self.currentLocation];
            
            if (completion) {
                completion();
            }
        }];
    }
    else {
        TapLocationAnnotation *tapAnnotation = [[[TapLocationAnnotation alloc] init] autorelease];
        tapAnnotation.coordinate = coordinate;
        self.currentLocation = tapAnnotation;
        [_mapView addAnnotation:self.currentLocation];
        
        if (completion) {
            completion();
        }
    }
}

- (void)updateTapLocation:(CLLocationCoordinate2D)coordinate
{
    if (self.currentLocation) {
        [_mapView removeAnnotation:self.currentLocation];
    }
    
    TapLocationAnnotation *tapAnnotation = [[[TapLocationAnnotation alloc] init] autorelease];
    tapAnnotation.coordinate = coordinate;
    self.currentLocation = tapAnnotation;
    [_mapView addAnnotation:self.currentLocation];
}

- (IBAction)onClickDriveSearch
{
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
    start.cityName = @"北京市";
    start.pt = {[kCurrentLat floatValue], [kCurrentLng floatValue]};
    BMKPlanNode* end = [[[BMKPlanNode alloc] init] autorelease];
    end.name = self.merchant.name;
    end.cityName = @"北京市";
    
    end.pt = {self.merchant.latitude, self.merchant.longitude};
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    [drivingRouteSearchOption release];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
}

- (void)onClickGPS
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定导航类型
    para.naviType = BMK_NAVI_TYPE_NATIVE;
    
    //初始化终点节点
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    //指定终点经纬度
    end.pt = {self.merchant.latitude, self.merchant.longitude};
    //指定终点名称
    end.name = self.merchant.name;
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
    [para release];
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //[_mapView updateLocationData:userLocation];
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //[_mapView updateLocationData:userLocation];
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end

