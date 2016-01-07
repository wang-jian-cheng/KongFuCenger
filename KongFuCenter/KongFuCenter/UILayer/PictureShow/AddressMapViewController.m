//
//  AddressMapViewController.m
//  HiHome
//
//  Created by Rain on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddressMapViewController.h"
#import <MAMapKit/MAPointAnnotation.h>
#import "CCLocationManager.h"
#import "SVProgressHUD.h"

#define APIKey @"54ac51d63f911c49a38c5fd842337264"

@interface AddressMapViewController ()<MAMapViewDelegate>{
    MAPointAnnotation *pointAnnotation;
    CGFloat _lat;
    CGFloat _long;
    NSString * address;
    NSUserDefaults *mUserDefault;
}

@property (nonatomic,strong) MAMapView *mapView;

@end

@implementation AddressMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mUserDefault = [NSUserDefaults standardUserDefaults];

  //  [self.mBtnRight setTitle:@"保存" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _mapView.delegate = self;
    _mapView.centerCoordinate=CLLocationCoordinate2DMake([[mUserDefault valueForKey:@"lat"] floatValue], [[mUserDefault valueForKey:@"long"] floatValue]);

    MACoordinateSpan span = MACoordinateSpanMake(0.004913, 0.013695);
    MACoordinateRegion region = MACoordinateRegionMake(_mapView.centerCoordinate, span);
    _mapView.region = region;
    
    pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = @"任务位置";
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([[mUserDefault valueForKey:@"lat"] floatValue], [[mUserDefault valueForKey:@"long"] floatValue]);
    [_mapView addAnnotation:pointAnnotation];
    [self.view addSubview:_mapView];
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
    } withAddress:^(NSString *addressString) {
        address=[addressString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }];
    
    _lat = [[mUserDefault valueForKey:@"lat"] floatValue];
    _long = [[mUserDefault valueForKey:@"long"] floatValue];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image=[UIImage imageNamed:@"shoppingcar_select_icon@2x.png"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    if (newState == MAAnnotationViewDragStateEnding) {
        [SVProgressHUD showWithStatus:@"正在获取位置信息" maskType:SVProgressHUDMaskTypeBlack];
        _lat=pointAnnotation.coordinate.latitude;
        _long=pointAnnotation.coordinate.longitude;
        
        CLLocation *mLocation = [[CLLocation alloc] initWithLatitude:_lat longitude:_long];
        
        //获取当前所在地的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:mLocation completionHandler:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                CLPlacemark *placemark = [array objectAtIndex:0];
                //获取城市
                address = placemark.name;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:address delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [SVProgressHUD dismiss];
            }
        }];
    }
}

-(void)btnRightClick:(id)sender{
    _mLag = [NSString stringWithFormat:@"%f",_lat];
    _mLong = [NSString stringWithFormat:@"%f",_long];
    _mAddress = address;
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
