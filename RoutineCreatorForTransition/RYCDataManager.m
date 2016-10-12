//
//  RYCDataManager.m
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/9.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "RYCDataManager.h"

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
static RYCDataManager *manager = nil;
@implementation RYCDataManager

+ (RYCDataManager *)ShareInsurance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RYCDataManager alloc] init];
        [AMapServices sharedServices].apiKey = @"d57bdbf9d3ae7b125ac30464ed33c0a0";
        [manager configLocationManager];
        [manager startLocation];
    });
    return manager;
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

-(void)startLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
    [self.locationManager setDelegate:self];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.initiateCoordinate = location.coordinate;
    [self cleanUpAction];
}

-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        for (RYCTransitoinOrderModel *model in self.dataContainer) {
            if ([model.address isEqualToString:request.address]) {
                model.location = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
                [self.locationToolArray addObject:model];
                if ([self.locationToolArray count] == [self.dataContainer count]) {
                    [self caculateOrderListWith:self.dataContainer];
                    break;
                }
            }
        }
        
    }];
    
}

-(NSMutableArray *)locationToolArray
{
    if (!_locationToolArray) {
        _locationToolArray = [NSMutableArray new];
    }
    return _locationToolArray;
}


-(NSMutableArray *)dataContainer
{
    if (!_dataContainer) {
        _dataContainer = [NSMutableArray new];
    }
    return _dataContainer;
}

-(NSMutableArray *)finalResultArray
{
    if (!_finalResultArray) {
        _finalResultArray = [NSMutableArray new];
    }
    return _finalResultArray;
}

-(void)startTransferAddressToLocation
{
    for (RYCTransitoinOrderModel *obj in self.dataContainer) {
        AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
        geo.address = obj.address;
        [self.search AMapGeocodeSearch:geo];
    }
}

-(NSArray *)caculateOrderListWith:(NSArray *)arr
{
    CLLocationCoordinate2D nearByPoint = self.initiateCoordinate;
    for (RYCTransitoinOrderModel *obj in arr) {
        if ([self.locationToolArray count] == 0) {
            break;
        }
        RYCTransitoinOrderModel *model = [self filterAddressesWith:self.locationToolArray withCenterLat:nearByPoint.latitude CenterLongt:nearByPoint.longitude];
        [self.finalResultArray addObject:model];
        [self.locationToolArray removeObject:model];
        nearByPoint = CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finalRefresh" object:nil];

    return self.finalResultArray;
}

- (RYCTransitoinOrderModel *)filterAddressesWith:(NSArray *)arr withCenterLat:(CLLocationDegrees )latitude CenterLongt:(CLLocationDegrees)longtitude
{
    if (arr.count < 1) {
        return nil;
    }
    NSArray *sortArr = [arr sortedArrayUsingComparator:^NSComparisonResult(RYCTransitoinOrderModel *obj1, RYCTransitoinOrderModel *obj2) {
        //1.将两个经纬度点转成投影点
        MAMapPoint originalPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longtitude));
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(obj1.location.latitude,obj1.location.longitude));
        //2.计算距离
        CLLocationDistance distance1 = MAMetersBetweenMapPoints(originalPoint,point1);
        
        //1.将两个经纬度点转成投影点
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(obj2.location.latitude,obj2.location.longitude));
        
        //2.计算距离
        CLLocationDistance distance2 = MAMetersBetweenMapPoints(originalPoint,point2);
        
        if (distance1 > distance2) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    return sortArr.firstObject;
}

-(void)startGuideWithDesModel:(RYCTransitoinOrderModel *)desModel
{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",self.initiateCoordinate.latitude,self.initiateCoordinate.longitude,@"A",desModel.location.latitude,desModel.location.longitude,@"B"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app//id461703208?mt=8"]];
    }
     
}

-(void)finishRound
{
    [self.finalResultArray removeAllObjects];
    [self.dataContainer removeAllObjects];
    [self.locationToolArray removeAllObjects];
}

@end
