//
//  UIImageView+FaceAwareFill.h
//  ProjectManager
//
//  Created by Mars on 2019/4/16.
//  Copyright © 2019 qingpugonglusuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (FaceAwareFill)

#pragma mark -
@property (nonatomic) BOOL needsBetterFace;
@property (nonatomic) BOOL fast;

void hack_uiimageview_bf(void);
- (void)setBetterFaceImage:(UIImage *)image;



//#pragma mark -
//- (void)at_setImageWithURL:(NSString *)imageURL;
//
//- (void)at_setImageWithURL:(NSString *)imageURL placeholder:(NSString *)placeholder;
//
//+ (void)at_clearMemory;

//Ask the image to perform an "Aspect Fill" but centering the image to the detected faces
//Not the simple center of the image

/**
 UIImageView_FaceAwareFill使用了Aspect Fill内容模式，可以自动根据图像内容进行调整，当检测到人脸时，它会以脸部中心替代掉以图片的几何中心。
 */
- (void)at_faceAwareFill;




@end



NS_ASSUME_NONNULL_END
