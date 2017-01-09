//
//  RYCOrderListTableViewCell.m
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/10.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "RYCOrderListTableViewCell.h"


@interface RYCOrderListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *orderNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *telButton;

@property (nonatomic, strong) RYCTransitoinOrderModel *model;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation RYCOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)resetCellWithEntity:(RYCTransitoinOrderModel *)entity
{
    self.model = entity;
    [_telButton setTitle:entity.tel.length > 0?entity.tel:@"未填" forState:UIControlStateNormal];
    _addressLabel.text = entity.address > 0?entity.address:@"未填";
    _orderNOLabel.text = entity.orderNO.length > 0?entity.orderNO:@"未填";
    _nameLabel.text = entity.name.length > 0?entity.name:@"未填";
    
    if (entity.isResult) {
        [self.editButton setTitle:@"导航" forState:UIControlStateNormal];
    }else{
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
}
- (IBAction)respondsToEdit:(UIButton *)sender {
    if ([self.editButton.titleLabel.text isEqualToString:@"导航"]) {
        if ([self.delegate respondsToSelector:@selector(toGuideWithModel:)]) {
            [self.delegate toGuideWithModel:self.model];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(toEditWithModel:)]) {
            [self.delegate toEditWithModel:self.model];
        }
    }
}

- (IBAction)repondsToDial:(UIButton *)sender {
    if (sender.titleLabel.text.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.titleLabel.text]]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
