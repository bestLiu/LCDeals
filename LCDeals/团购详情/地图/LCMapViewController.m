//
//  LCMapViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCMapViewController.h"
#import <MapKit/MapKit.h>
#import "LCMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DPAPI.h"
#import "LCBusiness.h"
#import "LCDeal.h"
#import "MJExtension.h"
#import "LCDealAnnotation.h"
#import "LCHomeTopItem.h"
#import "LCCategoryViewController.h"

@interface LCMapViewController ()<MKMapViewDelegate, DPRequestDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *coder;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, strong) DPRequest *lastRequest;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) LCHomeTopItem *topItem;

@end

@implementation LCMapViewController


- (CLGeocoder *)coder
{
    if (!_coder) {
        self.coder = [[CLGeocoder alloc] init];
    }
    return _coder;
}
- (CLLocationManager *)manager
{
    if (!_manager) {
        self.manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"地图";
   
    LCHomeTopItem *categoryTopItem = [LCHomeTopItem item];
    categoryTopItem.frame =  CGRectMake(SCREEN_WIDTH - 120, 5, 100, 34);
    categoryTopItem.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [categoryTopItem setTitle:@"全部分类"];
    [categoryTopItem setIcon:@"icon_category_-1" highlightIcon:@"icon_category_highlighted_-1"];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    [self.customNavigationBar addSubview:categoryTopItem];
    _topItem = categoryTopItem;
    
    //请求跟踪
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.manager requestWhenInUseAuthorization];
    }
    
    //    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
    //        [self.manager requestWhenInUseAuthorization];
    //    }
    
    //设置地图跟踪用户的位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //标准地图
    self.mapView.mapType = MKMapTypeStandard;
    
    //设置代理
    self.mapView.delegate = self;
    
    //监听分类改变
    [LCNotifiCationCenter addObserver:self selector:@selector(categoryChange:) name:LCCategoryMapDidChangeNotification object:nil];
    
}

- (void)categoryClick
{
    //显示分类菜单
    LCCategoryViewController *categoryVC = [[LCCategoryViewController alloc] init];
    [self pushViewController:categoryVC animated:YES];
}

- (void)categoryChange:(NSNotification *)noti
{
    LCCategory *category = noti.userInfo[LCCategoryMapSelectKey];
    NSString *subcategoryName = noti.userInfo[LCSubCategoryMapSelectKey];
    
    //改变顶部文字
    [_topItem setIcon:category.icon highlightIcon:category.highlighted_icon];
    [_topItem setTitle:subcategoryName];
    
    if (subcategoryName == nil ||[subcategoryName isEqualToString:@"全部"]) {//点击了没有子分类的类别
        self.selectedCategoryName = category.name;
    }else{
        self.selectedCategoryName = subcategoryName;
    }
    //改变顶部文字
    [_topItem setIcon:category.icon highlightIcon:category.highlighted_icon];
    [_topItem setTitle:self.selectedCategoryName];
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    //移除所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
}

#pragma mark -MKMapViewDelegate
int  count = 0;
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    count += 1;
    userLocation.title = @"不是当前位置";
    userLocation.subtitle = @"才怪";
    self.currentCoordinate = userLocation.coordinate;
    
    //让地图显示用户所在位置
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);//地图经纬度跨度，跨度越小，地图显示的位置越好。
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    if (count == 1) {
        [mapView setRegion:region];
    }
    
    //知道经纬度 ---->>>>> 获取城市名(地理反编码)
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) return;
        CLPlacemark *pm = [placemarks firstObject];
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length - 1];
        
        //第一次进来就发送请求给服务器
        [self mapView:self.mapView regionDidChangeAnimated:YES];
        
    }];
    
}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.city == nil) {
        return;
    }
    //当前地图现实的区域--->>>> mapView.region
    
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"city"] = @"成都";
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    NSString *urlString = @"v1/deal/find_deals";
    self.lastRequest = [api requestWithURL:urlString params:params delegate:self];
}


//自定义大头针视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(LCDealAnnotation *)annotation
{
    // 表示是刚开始蓝色的大头针
    if (![annotation isKindOfClass:[LCDealAnnotation class]]){
        MKPinAnnotationView *pinAnno = [[MKPinAnnotationView alloc] init];
        pinAnno.pinTintColor = [UIColor redColor];
        pinAnno.canShowCallout = YES;
        pinAnno.animatesDrop = YES;
        return pinAnno;
    }
    
    
    //    MKPinAnnotationView : MKAnnotationView
    MKAnnotationView *annoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"deal"];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@"deal"];
    }
    //设置模型(位置、标题、子标题)
    annoView.annotation = annotation;
    //    annoView.animatesDrop = YES;
    //设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];
    annoView.canShowCallout = YES;
    //    annoView.pinTintColor = [UIColor redColor];
    
    return annoView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

#pragma mark - 大众点评请求
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) {
        return;//不是最后一次请求直接返回
    }
    
    NSArray *deals = [LCDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (LCDeal *deal in deals) {
        
        // 获得团购所属的类型
        LCCategory *category = [LCTool categoryWithDeal:deal];
        
        for (LCBusiness *business in deal.businesses) {
            LCDealAnnotation *anno = [[LCDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            
            if ([self.mapView.annotations containsObject:anno]) break;
            
            [self.mapView addAnnotation:anno];
        }
    }
    
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    LCLog(@"%@",error);
}


- (IBAction)currentLocationAction:(id)sender {
    [_mapView setCenterCoordinate:self.currentCoordinate animated:YES];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
