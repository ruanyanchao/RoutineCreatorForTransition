//
//  RYCOrderCheckTableViewController.m
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/10.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "RYCOrderCheckTableViewController.h"
#import "ViewController.h"
#import "RYCOrderListTableViewCell.h"
#import "RYCTransitoinOrderModel.h"
#import "RYCDataManager.h"

@interface RYCOrderCheckTableViewController ()<EditDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation RYCOrderCheckTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshResult) name:@"finalRefresh" object:nil];
}

- (void)setUI
{
    
    if (self.type == ListType_Check) {
        self.title = @"配单查看";
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ContinueAdd)];
        self.navigationItem.leftBarButtonItem = leftButton;

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"开始规划" style:UIBarButtonItemStylePlain target:self action:@selector(startPlan)];
        self.navigationItem.rightBarButtonItem = rightButton;
        self.dataSource = [RYCDataManager ShareInsurance].dataContainer;
        
    }else{
        self.title = @"规划结果";
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = leftButton;
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成全部送单" style:UIBarButtonItemStylePlain target:self action:@selector(finishTask)];
        self.navigationItem.rightBarButtonItem = rightButton;
        
        
    }
    
}

- (void)ContinueAdd
{
    ViewController *inputVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"inputVC"];
    [self.navigationController pushViewController:inputVC animated:YES];
}

- (void)startPlan
{
    RYCOrderCheckTableViewController *result = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"orderList"];
    result.type = ListType_Result;
    [[RYCDataManager ShareInsurance] startTransferAddressToLocation];
    [self.navigationController pushViewController:result animated:YES];
}

- (void)finishTask
{
    [self alertToFinish];
}

- (void)alertToFinish
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认已经全部送完？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"还没" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[RYCDataManager ShareInsurance] finishRound];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [[RYCDataManager ShareInsurance].locationToolArray removeAllObjects];
    [[RYCDataManager ShareInsurance].finalResultArray removeAllObjects];
}

- (void)refreshResult
{
    if (self.type == ListType_Result) {
        self.dataSource = [RYCDataManager ShareInsurance].finalResultArray;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"orderlistcell";
    RYCOrderListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    RYCTransitoinOrderModel *entity = self.dataSource[indexPath.row];
    entity.isResult = self.type;
    cell.delegate = self;
    [cell resetCellWithEntity:entity];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(void)toEditWithModel:(RYCTransitoinOrderModel *)model
{
    ViewController *inputVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"inputVC"];
    inputVC.currentModel = OperationModel_Edit;
    inputVC.dataModel = model;
    __weak RYCOrderCheckTableViewController *weakSelf = self;
    inputVC.block = ^{
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:inputVC animated:YES];
}

-(void)toGuideWithModel:(RYCTransitoinOrderModel *)model
{
    [[RYCDataManager ShareInsurance] startGuideWithDesModel:model];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
