//
//  RYCAddressModel.h
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/31.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RYCAddressModel : NSObject

@property (nonatomic, strong) NSString *adcode;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typecode;

+ (RYCAddressModel *)deserializeWith:(NSDictionary *)dic;
+ (NSArray *)deserializeWithArr:(NSArray *)arr;

@end
