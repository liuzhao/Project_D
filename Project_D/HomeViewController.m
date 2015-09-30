//
//  HomeViewController.m
//  Project_D
//
//  Created by Liu Zhao on 15/9/28.
//  Copyright © 2015年 Liu Zhao. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter2.h"
#import "ZPService.h"
#import "HomeTableViewCell.h"
#import "DetailViewController.h"
#import "TOWebViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_listArray;
    
    NSInteger _page;
}

@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation HomeViewController

#pragma mark- Life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupListTableView];
    
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- SetupUI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"主页";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:_listTableView.header
                                                                                           action:@selector(beginRefreshing)];
}

- (void)setupListTableView
{
    self.listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.rowHeight = 77;
    [self.view addSubview:_listTableView];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _listTableView.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstPage)];
    
    _listTableView.footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    // 马上进入刷新状态
    [_listTableView.header beginRefreshing];
}

#pragma mark- Method

- (void)requestService
{
    ZPService *service = [ZPService new];
    NSMutableURLRequest *request = [service getNewsListChannelId:@"5572a109b3cdc86cf39001db" channelName:@"国内最新" page:_page];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送的URL：%@",operation.response.URL);
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
        if (!_listArray) {
            _listArray = [NSMutableArray new];
        }
        [_listArray addObjectsFromArray:[[[dict objectForKey:@"showapi_res_body"] objectForKey:@"pagebean"] objectForKey:@"contentlist"]];

        [_listTableView.header endRefreshing];
        [_listTableView.footer endRefreshing];
        [_listTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@，错误的URL：%@",error, operation.response.URL);
        [_listTableView.header endRefreshing];
        [_listTableView.footer endRefreshing];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)loadFirstPage
{
    _page = 1;
    [_listArray removeAllObjects];
    [self requestService];
}

- (void)loadMore
{
    _page ++;
    [self requestService];
}

#pragma mark- TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.titleLabel.text = [_listArray[indexPath.row] objectForKey:@"title"];
    cell.detailLabel.text = [_listArray[indexPath.row] objectForKey:@"desc"];
    
    NSArray *images = [_listArray[indexPath.row] objectForKey:@"imageurls"];
    NSString *imageUrl = nil;
    if (images.count) {
        imageUrl = [[images objectAtIndex:0] objectForKey:@"url"];
        [cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                   placeholderImage:[UIImage imageNamed:@"暂无图片"]
                                            options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    }
    else {
        cell.titleLabel.frame = CGRectMake(15, 10, self.view.bounds.size.width - 45, 20);
        cell.detailLabel.frame = CGRectMake(15, 30, self.view.bounds.size.width - 45, 40);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.url = [_listArray[indexPath.row] objectForKey:@"link"];
    [self.navigationController pushViewController:detailVC animated:YES];
     */
    
    NSURL *url = [NSURL URLWithString:[_listArray[indexPath.row] objectForKey:@"link"]];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
