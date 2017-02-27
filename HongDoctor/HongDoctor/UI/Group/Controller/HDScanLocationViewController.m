//
//  HDScanLocationViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/17.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDScanLocationViewController.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HLBarButtonItem.h"

@interface HDScanLocationViewController ()

@property (nonatomic, strong) MKMapView                 *mapView;
@property (nonatomic, strong) AMapLocationManager       *locationManager;
@property (nonatomic, assign) double LocationLatitude;
@property (nonatomic, assign) double LocationLongitude;
@property (nonatomic, strong) NSString *locationAddress;

@end

@implementation HDScanLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupMapView];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"位置";
    
    HLBarButtonItem *rightItem = [[HLBarButtonItem alloc] initWithTitle:@"导航" target:self action:@selector(respondsToStartNavigation)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    CLLocationCoordinate2D coordintate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordintate, MKCoordinateSpanMake(.1, .1));
    [self.mapView setRegion:region animated:YES];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 2;
    self.locationManager.reGeocodeTimeout = 2;
    [self startLocation];
}

- (void)startLocation
{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        self.LocationLatitude = location.coordinate.latitude;
        self.LocationLongitude = location.coordinate.longitude;
        self.locationAddress = regeocode.formattedAddress ? regeocode.formattedAddress : @"";
    }];
}

#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToStartNavigation
{
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:nil message:nil viewController:self];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消"];
    [alert addButton:cancelItem type:RIButtonItemType_Cancel];
    RIButtonItem *baiduItem = [RIButtonItem itemWithLabel:@"百度地图" action:^{
        [self openNavigationForBaiduMap];
    }];
    [alert addButton:baiduItem type:RIButtonItemType_Other];
    RIButtonItem *gaodeItem = [RIButtonItem itemWithLabel:@"高德地图" action:^{
        [self openNavigationForGaoDeMap];
    }];
    [alert addButton:gaodeItem type:RIButtonItemType_Other];
    [alert showInView:self.view];
}

- (void)openNavigationForGaoDeMap
{
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",_LocationLatitude,_LocationLongitude, self.latitude,self.longitude,@"终点",@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) // -- 使用 canOpenURL:[NSURL URLWithString:@"iosamap://"] 判断不明白为什么为否。
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }else{
        BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:@"您还未安装高德地图，请先下载安装" viewController:self];
        RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:nil];
        [alert addButton:okItem type:RIButtonItemType_Other];
        [alert show];
    }
}

- (void)openNavigationForBaiduMap
{
    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%f,%f&mode=%@&src=公司|APP",_LocationLatitude,_LocationLongitude,self.latitude,self.longitude,@"driving"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:@"您还未安装百度地图，请先下载安装" viewController:self];
        RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:nil];
        [alert addButton:okItem type:RIButtonItemType_Other];
        [alert show];
    }
}

@end
