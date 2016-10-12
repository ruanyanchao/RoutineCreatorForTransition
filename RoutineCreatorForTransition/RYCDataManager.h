//
//  RYCDataManager.h
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/9.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "RYCTransitoinOrderModel.h"

@interface RYCDataManager : NSObject<AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) NSMutableArray *dataContainer;
@property (nonatomic, strong) NSMutableArray *locationToolArray;
@property (nonatomic, strong) NSMutableArray *finalResultArray;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D initiateCoordinate;
@property (nonatomic, strong) AMapSearchAPI *search;


+ (RYCDataManager *)ShareInsurance;
- (void)startTransferAddressToLocation;
- (NSArray *)caculateOrderListWith:(NSArray *)arr;
- (void)configLocationManager;
- (void)startLocation;
- (void)cleanUpAction;
- (RYCTransitoinOrderModel *)filterAddressesWith:(NSArray *)arr withCenterLat:(CLLocationDegrees )latitude CenterLongt:(CLLocationDegrees)longtitude;

//开始导航
- (void)startGuideWithDesModel:(RYCTransitoinOrderModel *)desModel;

- (void)finishRound;

@end
