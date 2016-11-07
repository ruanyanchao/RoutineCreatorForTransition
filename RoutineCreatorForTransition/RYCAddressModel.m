//
//  RYCAddressModel.m
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/31.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "RYCAddressModel.h"
@implementation RYCAddressModel

+(RYCAddressModel *)deserializeWith:(NSDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    RYCAddressModel *model = [RYCAddressModel new];
    model.name = [dic objectForKey:@"name"];
    NSString *locationString = [dic objectForKey:@"location"];
    model.address_id = [dic objectForKey:@"id"];
    if ([locationString isKindOfClass:[NSString class]]) {
        NSArray *arr = [locationString componentsSeparatedByString:@","];
        model.location = CLLocationCoordinate2DMake([arr.lastObject floatValue],[arr.firstObject floatValue]);
        NSLog(@"%f,%f",[arr.lastObject floatValue],[arr.firstObject floatValue]);
    }
    
    return model;
}

+(NSArray *)deserializeWithArr:(NSArray *)arr
{
    if (!arr) {
        return nil;
    }
    NSMutableArray *marr = [NSMutableArray new];
    for (NSDictionary *obj in arr) {
        [marr addObject:[RYCAddressModel deserializeWith:obj]];
    }
    return marr.mutableCopy;
}

@end
