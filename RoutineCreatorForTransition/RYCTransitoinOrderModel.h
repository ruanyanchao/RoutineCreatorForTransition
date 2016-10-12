//
//  RYCTransitoinOrderModel.h
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/9.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface RYCTransitoinOrderModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *orderNO;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, assign) BOOL     isResult;

@end
