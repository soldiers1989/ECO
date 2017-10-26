//
//  ZBDetailViewController.m
//  ECO
//
//  Created by Never on 2017/10/17.
//  Copyright © 2017年 Never. All rights reserved.
//  商品详情页面

#import "ZBDetailViewController.h"
#import "SDCycleScrollView.h"
#import "ZBDetailFirstCell.h"
#import "ZBDetailSecondCell.h"
#import "ZBProductDetailModel.h"

static NSString *ID = @"cell";
static NSString *SCell = @"SCell";

@interface ZBDetailViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) NSMutableArray *bannerImgArr;

@property (nonatomic, strong) ZBProductDetailModel *dataModel;
@end

@implementation ZBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = ViewController_BackGround;
    [self loadUrlData:self.product_id];
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.tableView.tableFooterView = self.buttonView;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZBDetailFirstCell" bundle:nil] forCellReuseIdentifier:ID];
        [self.tableView registerNib:[UINib nibWithNibName:@"ZBDetailSecondCell" bundle:nil] forCellReuseIdentifier:SCell];
}


- (void)loadUrlData:(NSString *)product_id{
    
    
    [ZBHTTPRequestManager requestGETWithURLStr:detail_URL(product_id) paramDic:nil Api_key:nil finish:^(id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        ZBProductDetailModel *model  = [ZBProductDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.dataModel = model;
        for (ZBImagesModel *imageModel in model.imgs) {
            [self.bannerImgArr addObject:imageModel.url];
        }
        //刷新滚动视图
        self.cycleScrollView.imageURLStringsGroup = self.bannerImgArr;
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [Tools MBProgressHUD:@"加载失败"];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZBDetailFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:ID];
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [firstCell refreshUI:self.dataModel];
        return firstCell;
    }else if (indexPath.row == 1){
        ZBDetailSecondCell  *secondCell = [tableView dequeueReusableCellWithIdentifier:SCell];
        secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [secondCell refreshUI:self.dataModel];
        return secondCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}


- (SDCycleScrollView *)cycleScrollView{
    
    if (!_cycleScrollView) {
        //轮播图
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, screen_width*(230/375.0)) delegate:self placeholderImage:[UIImage imageNamed:@"viodImage"]];
        _cycleScrollView.imageURLStringsGroup = self.bannerImgArr;
        _cycleScrollView.autoScrollTimeInterval = 4.0;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _cycleScrollView;
    
}
- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)bannerImgArr{
    
    if (!_bannerImgArr) {
        _bannerImgArr = [NSMutableArray array];
    }
    return _bannerImgArr;
}

- (UIView *)buttonView{
    
    if (!_buttonView) {
        
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-49-64, screen_height, 49)];
        _buttonView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 5, screen_width-20, 39);
        btn.backgroundColor = [UIColor greenColor];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 10.0f;
        [btn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buttonView addSubview:btn];
    }
    return _buttonView;
    
}
@end