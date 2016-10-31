//
//  ViewController.m
//  RoutineCreatorForTransition
//
//  Created by Ryan on 2016/10/8.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "ViewController.h"
#import "RYCOrderCheckTableViewController.h"
#import "RYCDataManager.h"
#import "RYCRoundCornerButton.h"
#import "RYCAddressModel.h"


@interface ViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton*completeButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet RYCRoundCornerButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedFillingPartViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *selectedFillingPartView;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *orderNOTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UITableView    *tableView;

@property (nonatomic, strong) RYCAddressModel   *selectedAddressModel;

@end

@implementation ViewController


-(RYCTransitoinOrderModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [RYCTransitoinOrderModel new];
    }
    return _dataModel;
}
- (IBAction)respondsToCityChange:(UIBarButtonItem *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加待送配单";
    [self setUI];
    [self createSearchHintTable];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidLayoutSubviews
{
    self.tableView.frame = CGRectMake(75, 114.5 + 94,285, self.view.frame.size.height - 114.5 - 30);
    
}

-(NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray new];
    }
    return _dataSourceArray;
}
//创建搜索结果显示表单
- (void)createSearchHintTable
{
    UITableView *searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.addressTF.frame.origin.x, self.addressTF.bounds.origin.y + self.addressTF.bounds.size.height,self.addressTF.frame.size.width , self.view.frame.size.height - self.addressTF.frame.origin.y - self.addressTF.frame.size.height) style:UITableViewStylePlain];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchTableView];
    searchTableView.alpha = 0;
    self.tableView = searchTableView;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    RYCAddressModel *model = self.dataSourceArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

//调整UI
- (void)setUI
{
    self.openButton.layer.cornerRadius = 15;
    self.openButton.layer.borderColor = [UIColor whiteColor]
    .CGColor;
    self.openButton.layer.borderWidth = 2;
    
    self.helpButton.layer.cornerRadius = 15;
    self.helpButton.layer.borderColor = [UIColor whiteColor]
    .CGColor;
    self.helpButton.layer.borderWidth = 2;
    
    [self.openButton setTitle:@"展开" forState:UIControlStateNormal];
    self.selectedFillingPartViewHeightConstraint.constant = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成输入" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToComplete:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if (self.currentModel == OperationModel_Edit) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEdit:)];
        self.navigationItem.rightBarButtonItem = button;
        
        [self restoreData];
        
        self.completeButton.alpha = 0;
        self.addButton.alpha = 0;
    }
}

- (void)restoreData
{
    self.addressTF.text = self.dataModel.address;
    self.nameTF.text = self.dataModel.name;
    self.phoneTF.text = self.dataModel.tel;
    self.orderNOTF.text = self.dataModel.orderNO;
}


- (void)doneEdit:(UIBarButtonItem *)button
{
    [self saveCurrentOrder];
    if (self.block) {
        self.block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToComplete:(UIButton *)sender {
    if ([self.addressTF.text length] > 0) {
        [self saveCurrentOrder];
    }
    if ([RYCDataManager ShareInsurance].dataContainer.count > 0) {
        RYCOrderCheckTableViewController *listVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"orderList"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else{
        [self alertToNilAddress];
    }
}
- (IBAction)respondsToAdd:(UIButton *)sender {
    if ([self.addressTF.text length] > 0) {
        [self saveCurrentOrder];
        ViewController *inputVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"inputVC"];
        [self.navigationController pushViewController:inputVC animated:YES];
    }else{
        [self alertToNilAddress];
    }

}

- (void)alertToNilAddress
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)respondsToOpenButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.openButton setTitle:@"收起" forState:UIControlStateNormal];
        self.selectedFillingPartViewHeightConstraint.constant = 153;
    }else{
        [self.openButton setTitle:@"展开" forState:UIControlStateNormal];
        self.selectedFillingPartViewHeightConstraint.constant = 0;
    }
}
- (IBAction)respondsToHelpButton:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提醒" message:@"选填的内容可以使接下来的服务更加的细致和周到，\n如果不是特别紧急，建议填写" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveCurrentOrder
{
    self.dataModel.address = self.addressTF.text;
    self.dataModel.name = self.nameTF.text;
    self.dataModel.tel = self.phoneTF.text;
    self.dataModel.orderNO = self.orderNOTF.text;
    self.dataModel.location = self.selectedAddressModel.location;
    if (self.currentModel == OperationModel_Edit) {
        return;
    }
    [[RYCDataManager ShareInsurance].dataContainer addObject:self.dataModel];
    [self clearTFs];
}


- (void)clearTFs{
    self.addressTF.text = @"";
    self.nameTF.text = @"";
    self.phoneTF.text = @"";
    self.orderNOTF.text = @"";
}

#pragma mark  -- TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *baseUrl = @"http://restapi.amap.com/v3/assistant/inputtips";
    NSDictionary *parameters = @{@"keywords":[textField.text stringByReplacingCharactersInRange:range withString:string],@"city":@"上海",@"types":@"050301",@"key":@"b93a104a2acef205847e0ac8c339d39c"};
    [[AFHTTPSessionManager manager] GET:baseUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSArray *tips = [responseObject objectForKey:@"tips"];
        NSArray *arr = [RYCAddressModel deserializeWithArr:tips];
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:arr];
        [self.tableView reloadData];
        self.tableView.alpha = 1;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed");
    }];
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYCAddressModel *model = self.dataSourceArray[indexPath.row];
    self.selectedAddressModel = model;
    self.addressTF.text = model.name;
    [self.addressTF resignFirstResponder];
    self.tableView.alpha = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
