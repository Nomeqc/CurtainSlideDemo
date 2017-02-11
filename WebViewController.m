//
//  WebViewController.m
//  CurtainSlideDemo
//
//  Created by iOSDeveloper003 on 17/2/9.
//  Copyright © 2017年 iOSDeveloper003. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
<UIWebViewDelegate>

@property (strong, nonatomic, readwrite) UIView *containerView;

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UIView *navigationBar;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    [self setupUI];
    if (self.urlString.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    [self updateTitle:@"正在加载.."];
}

- (void)setupUI {
    [self.view addSubview:self.containerView];
    self.containerView.frame = self.view.bounds;
    
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor whiteColor];
    
    [self.containerView addSubview:navigationView];
    [self.containerView addSubview:self.webView];
    navigationView.frame = ({
        CGRect frame = navigationView.frame;
        frame.origin = CGPointMake(0, 0);
        frame.size = CGSizeMake(CGRectGetWidth(self.view.frame), 64);
        frame;
    });
    self.webView.frame = ({
        CGRect frame = self.webView.frame;
        frame.origin = CGPointMake(0, CGRectGetMaxY(navigationView.frame));
        frame.size = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(navigationView.frame));
        frame;
    });
    
    [navigationView addSubview:({
        UIView *bar = [[UIView alloc] init];
        bar.frame = CGRectMake(0, 20, CGRectGetWidth(navigationView.frame), 44);
        [bar addSubview:({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            self.titleLabel = label;
            label;
        })];
        bar;
    })];
    [navigationView addSubview:({
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        CGFloat onePxPoint = 1/[UIScreen mainScreen].scale;
        separator.frame = CGRectMake(0, CGRectGetHeight(navigationView.frame) - onePxPoint, CGRectGetWidth(navigationView.frame), onePxPoint);
        separator;
    })];
    
    self.navigationView = navigationView;
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    if (CGRectGetWidth(self.titleLabel.frame) > CGRectGetWidth(self.titleLabel.superview.frame) - 20) {
        self.titleLabel.frame = ({
            CGRect frame = self.titleLabel.frame;
            frame.size.width = CGRectGetWidth(self.titleLabel.superview.frame) - 20;
            frame;
        });
    }
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.titleLabel.superview.bounds), CGRectGetMidY(self.titleLabel.superview.bounds));
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateTitle:title];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.titleLabel.text = @"加载失败";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (UIView *)containerView {
    if(_containerView == nil) {
        _containerView = [[UIView alloc] init];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

- (UIWebView *)webView {
	if(_webView == nil) {
		_webView = [[UIWebView alloc] init];
        _webView.delegate = self;
	}
	return _webView;
}



@end
