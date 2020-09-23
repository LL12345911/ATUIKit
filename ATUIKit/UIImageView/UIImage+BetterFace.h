//
//  UIImage+BetterFace.h
//  HighwayDoctor
//
//  Created by Mars on 2019/5/21.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, BFAccuracy) {
    kBFAccuracyLow = 0,
    kBFAccuracyHigh,
};

@interface UIImage (BetterFace)

- (UIImage *)betterFaceImageForSize:(CGSize)size
                           accuracy:(BFAccuracy)accurary;

@end


