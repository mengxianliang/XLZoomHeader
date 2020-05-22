//
//  XLZoomHeader.h
//  XLZoomHeaderDemo
//
//  Created by MengXianLiang on 2018/8/3.
//  Copyright © 2018年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLZoomHeader : UIView

///图片缩进
@property (nonatomic, assign) UIEdgeInsets backgroundImageInsets;

///背景图片
@property (nonatomic, strong) UIImage *backgroundImage;

@end


@interface UIScrollView (XLHeaderExtension)

//
@property (nonatomic, strong) XLZoomHeader *xl_zoomHeader;

@end
