//
//  ATCustomButton.h
//  ATCustomButtonDemo
//
//  Created by brucewang on 2018/11/19.
//  Copyright © 2018 brucewang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ATCustomButtonStyle){
    ATCustomButtonStyleTop,       // 图片在上，文字在下
    ATCustomButtonStyleLeft,      // 图片在左，文字在右
    ATCustomButtonStyleRight,     // 图片在右，文字在左
    ATCustomButtonStyleBottom,    // 图片在下，文字在上
};

@interface ATCustomButton : UIButton

/**
 ATCustomButton的样式(Top、Left、Right、Bottom)
 */
@property (nonatomic, assign) ATCustomButtonStyle style;

/**
 图片和文字的间距
 */
@property (nonatomic, assign) CGFloat space;

/**
 整个ATCustomButton(包含ImageV and titleV)的内边距
 */
@property (nonatomic, assign) CGFloat delta;

@end

NS_ASSUME_NONNULL_END
