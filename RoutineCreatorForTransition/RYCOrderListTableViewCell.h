//
//  RYCOrderListTableViewCell.h
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/10.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYCTransitoinOrderModel.h"

@protocol EditDelegate <NSObject>

- (void)toEditWithModel:(RYCTransitoinOrderModel *)model;
- (void)toGuideWithModel:(RYCTransitoinOrderModel *)model;

@end

@interface RYCOrderListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<EditDelegate>delegate;
- (void)resetCellWithEntity:(RYCTransitoinOrderModel *)entity;


@end
