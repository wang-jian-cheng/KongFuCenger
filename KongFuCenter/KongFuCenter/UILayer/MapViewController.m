//
//  MapViewController.m
//  KongFuCenter
//
//  Created by Wangjc on 16/1/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MapViewController.h"
//#import "CCLocationManager.h"
@interface MapViewController ()<CLLocationManagerDelegate>
{
    MKMapView *mapView;
    CLLocationManager *locationManager;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    mapView.mapType = MKMapTypeStandard;
    [self addLeftButton:@"left"];
    
    [self.view addSubview:mapView];
    locationManager = [[CLLocationManager alloc] init];
    if(![CLLocationManager locationServicesEnabled])
        return;
    if([Toolkit isSystemIOS8]){
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    [self addAnnotations];
        // Do any additional setup after loading the view.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationManager stopUpdatingLocation ];
}

-(void)addAnnotations
{
//    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
//    annotation1.coordinate =[CLLocation alloc] ini
//    //[[CLLocationCoordinate2D alloc] initWithLatitude:32.029171 longitude:118.788231];//CLLocation(latitude: 32.029171, longitude: 118.788231).coordinate;
//    annotation1.title = @"南京夫子庙";
//    annotation1.subtitle = @"南京市秦淮区秦淮河北岸中华路";
//    self.mapView.addAnnotation(annotation1)
    //MAPointAnnotation
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [mapView addAnnotation:pointAnnotation];
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(39.989631, 116.481018);
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [mapView setRegion:region animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
