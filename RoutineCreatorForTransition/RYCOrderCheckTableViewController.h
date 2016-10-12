//
//  RYCOrderCheckTableViewController.h
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/10.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ListType){
    ListType_Check = 0,
    ListType_Result
};

@interface RYCOrderCheckTableViewController : UITableViewController

@property (nonatomic, assign) ListType type;


@end
