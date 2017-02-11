//
//  CurtainSlideController.m
//  CurtainSlideDemo
//
//  Created by iOSDeveloper003 on 17/2/9.
//  Copyright © 2017年 iOSDeveloper003. All rights reserved.
//

#import "CurtainSlideController.h"
#import "WebViewController.h"

@interface CurtainSlideController ()
<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableDictionary *loadedRecords;

@property (strong, nonatomic) NSMutableArray<UIViewController *> *controllers;

@end

@implementation CurtainSlideController {
    CGFloat _lastContentOffsetX;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupContent];
    [self handleWithCurrentIndex:0];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
}

- (void)setupContent {
    NSArray<NSString *> *urls = @[@"http://news.ifeng.com/a/20170210/50674081_0.shtml",
                      @"http://news.ifeng.com/a/20170209/50668323_0.shtml",
                      @"http://news.ifeng.com/a/20170209/50669526_0.shtml",
                      @"http://news.ifeng.com/a/20170209/50669255_0.shtml"];
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.urlString = obj;
        [self.controllers addObject:webViewController];
    }];
    self.scrollView.contentSize = CGSizeMake(self.controllers.count * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
}

- (void)loadControllerWithIndex:(NSInteger)index {
    UIViewController *controller = self.loadedRecords[@(index)];
    if (!controller && index < self.controllers.count) {
        controller = self.controllers[index];
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        controller.view.frame = self.scrollView.bounds;
        [controller didMoveToParentViewController:self];
        self.loadedRecords[@(index)] = controller;
    }
}

- (void)updateContentPositionWithIndex:(NSInteger)index {
    //右边控制器容器中心点在最左边
    WebViewController *nextController = [self nextControllerWithCurrentIndex:index];
    nextController.containerView.center = ({
        CGPoint center = nextController.containerView.center;
        center.x = 0;
        center;
    });
    //左边控制器容器中心点在最右边
    WebViewController *lastController = [self lastControllerWithCurrentIndex:index];
    lastController.containerView.center = ({
        CGPoint center = lastController.containerView.center;
        center.x = CGRectGetWidth(lastController.containerView.frame);
        center;
    });
    //当前控制器容器中心点和父容器相同
    WebViewController *currentController = [self currentControllerWithCurrentIndex:index];
    currentController.containerView.frame = currentController.containerView.bounds;
}

- (void)handleWithCurrentIndex:(NSInteger)index {
    [self loadControllerWithIndex:index];
    [self updateContentPositionWithIndex:index];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"begin dragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self currentIndex];
    CGFloat delta = scrollView.contentOffset.x - _lastContentOffsetX;
    
    WebViewController *currentController = [self currentControllerWithCurrentIndex:currentIndex];
    currentController.containerView.center = ({
        CGPoint center = currentController.containerView.center;
        center.x += delta/2.0;
        center;
    });
    WebViewController *nextController = [self nextControllerWithCurrentIndex:currentIndex];
    nextController.containerView.center = ({
        CGPoint center = nextController.containerView.center;
        center.x += delta/2.0;
        center;
    });
    _lastContentOffsetX = scrollView.contentOffset.x;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    NSInteger index = [self currentIndex];
    NSLog(@"index: %ld,scrollView.contentOffset.x:%lf",index,scrollView.contentOffset.x);
    NSLog(@"isDragging:%@,isDecelerating:%@",scrollView.isDragging? @"YES":@"NO",scrollView.isDecelerating? @"YES" :@"NO");
    //当拖拽超出边缘 手指松开回弹的时候 再次拖拽会触发此方法
    //手指再次松开 回弹结束的时候会再次触发此方法 所以需要判断 contentOffset.x是否在正常范围内 防止多次处理 导致回弹效果不流畅
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))) {
        [self loadControllerWithIndex:index];
        [self updateContentPositionWithIndex:index];
    }
}

#pragma mark - Helper
- (NSInteger)currentIndex {
    return  (NSInteger)floor(self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame));
}

- (WebViewController *)currentControllerWithCurrentIndex:(NSInteger)index {
    if (index >= 0 && index < self.controllers.count) {
        return (id)self.controllers[index];
    }
    return nil;
}

- (WebViewController *)lastControllerWithCurrentIndex:(NSInteger)index {
    if (index - 1 >= 0) {
        return (id)self.controllers[index - 1];
    }
    return nil;
}

- (WebViewController *)nextControllerWithCurrentIndex:(NSInteger)index {
    if (index + 1 < self.controllers.count) {
        return (id)self.controllers[index + 1];
    }
    return nil;
}

#pragma mark - Accessors

- (UIScrollView *)scrollView {
	if(_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
	}
	return _scrollView;
}

- (NSMutableDictionary *)loadedRecords {
	if(_loadedRecords == nil) {
		_loadedRecords = [[NSMutableDictionary alloc] init];
	}
	return _loadedRecords;
}

- (NSMutableArray *)controllers {
	if(_controllers == nil) {
		_controllers = [[NSMutableArray alloc] init];
	}
	return _controllers;
}



@end
