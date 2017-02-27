//
//  HDLocationViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/25.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDLocationViewController.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HDImageManager.h"
#import "HDLocationCell.h"
#import "HDLocationCellEntity.h"

@interface HDLocationViewController () <UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>

@property (nonatomic, strong) AMapLocationManager       *locationManager;
@property (nonatomic, assign) double                    latitude;
@property (nonatomic, assign) double                    longitude;
@property (nonatomic, strong) NSString                  *address;
@property (nonatomic, strong) MKMapView                 *mapView;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray            *dataSourceArray;
@property (nonatomic, strong) AMapSearchAPI             *searchAPI;

@end

@implementation HDLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupSearchAPI];
    [self setupMapView];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"我的位置";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSendItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupMapView
{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    self.mapView = [[MKMapView alloc] initWithFrame:frame];
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 2;
    self.locationManager.reGeocodeTimeout = 2;
    [self startLocation];
}

- (void)setupSearchAPI
{
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
}


#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToSendItem
{
    NSString *imageName = [self mapViewImageName];
    self.locationComplete(self.address, self.latitude, self.longitude, imageName);
    [self.navigationController popViewControllerAnimated:YES];
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
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        self.address = regeocode.formattedAddress ? regeocode.formattedAddress : @"";
        [self requestSearchPOI];
    }];
}

- (NSString *)mapViewImageName
{
    UIGraphicsBeginImageContextWithOptions(self.mapView.bounds.size, YES, 0);
    [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(uiImage, 1);
    NSString *imageName = [HDImageManager saveImageWithData:data];
    return imageName;
}


#pragma -mark tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDLocationCell" forIndexPath:indexPath];
    [cell resetCellWithEntity:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    for (HDLocationCellEntity *entity in self.dataSourceArray) {
        entity.isSelect = NO;
    }
    HDLocationCellEntity *entity = self.dataSourceArray[indexPath.row];
    entity.isSelect = YES;
    [self.tableView reloadData];
    
    self.longitude = entity.longitude;
    self.latitude = entity.latitude;
    self.address = [NSString stringWithFormat:@"%@%@", entity.address, entity.name];
    CLLocationCoordinate2D coordintate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordintate, MKCoordinateSpanMake(.1, .1));
    [self.mapView setRegion:region animated:YES];
}


#pragma -mark searchAPI delegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count <= 0) {
        return;
    }
    
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    HDLocationCellEntity *entity = [[HDLocationCellEntity alloc] init];
    entity.name = self.address;
    entity.address = @"";
    entity.isSelect = YES;
    entity.latitude = self.latitude;
    entity.longitude = self.longitude;
    [self.dataSourceArray addObject:entity];
    for (AMapPOI *poi in response.pois) {
        HDLocationCellEntity *entity = [[HDLocationCellEntity alloc] init];
        entity.name = poi.name;
        entity.address = [NSString stringWithFormat:@"%@%@%@%@", poi.province, poi.city, poi.district, poi.address];
        entity.isSelect = NO;
        entity.latitude = poi.location.latitude;
        entity.longitude = poi.location.longitude;
        [self.dataSourceArray addObject:entity];
    }
    [self.tableView reloadData];
}


#pragma -mark loadData

- (void)requestSearchPOI
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 500;
    [self.searchAPI AMapPOIAroundSearch:request];
}

@end
