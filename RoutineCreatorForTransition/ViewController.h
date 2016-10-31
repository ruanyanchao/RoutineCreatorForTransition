//
//  ViewController.h
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/8.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import "AFNetworking.h"
#import "RYCTransitoinOrderModel.h"

typedef NS_ENUM(NSUInteger,OperationModel){
    OperationModel_Input = 0,
    OperationModel_Edit
};
typedef void(^editBlock)();
@interface ViewController : UIViewController

@property (nonatomic, assign) OperationModel currentModel;
@property (nonatomic, strong) RYCTransitoinOrderModel *dataModel;
@property (nonatomic, copy) editBlock block;


@end

