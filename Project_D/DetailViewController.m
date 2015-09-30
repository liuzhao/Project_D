//
//  DetailViewController.m
//  Project_D
//
//  Created by Liu Zhao on 15/9/28.
//  Copyright © 2015年 Liu Zhao. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIWebViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"详情页";
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetupUI

- (void)setupUI
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
    webView.delegate = self;
    [self.view addSubview:webView];
}

#pragma mark - WebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
