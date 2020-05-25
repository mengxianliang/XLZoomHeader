//
//  XLZoomHeader.h
//  XLZoomHeaderDemo
//
//  Created by MengXianLiang on 2018/8/3.
//  Copyright © 2018年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLZoomHeader : UIView

///background image insets
@property (nonatomic, assign) UIEdgeInsets backgroundImageInsets;

///background image
@property (nonatomic, strong) UIImage *backgroundImage;

@end


@interface UIScrollView (XLHeaderExtension)

//scrollview's extension
@property (nonatomic, strong) XLZoomHeader *xl_zoomHeader;

@end
