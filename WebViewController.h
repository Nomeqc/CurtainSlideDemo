//
//  WebViewController.h
//  CurtainSlideDemo
//
//  Created by iOSDeveloper003 on 17/2/9.
//  Copyright © 2017年 iOSDeveloper003. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic, readonly) UIView *containerView;

@property (copy, nonatomic) NSString *urlString;

@end
