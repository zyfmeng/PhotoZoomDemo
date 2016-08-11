//
//  ViewController.h
//  PhotoZoom
//
//  Created by md on 16/8/11.
//  Copyright © 2016年 HKQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController : UIViewController

#pragma mark - 变量-------------------------------------------------------------
// 图片url地址的数组
@property (nonatomic,strong) NSArray *imageUrlArrays ;

#pragma mark - 视图-------------------------------------------------------------
// 第几张图片的文本
@property (nonatomic,strong) UILabel *label ;
@end

