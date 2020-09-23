//
//  UIImageView+FaceAwareFill.m
//  ProjectManager
//
//  Created by Mars on 2019/4/16.
//  Copyright © 2019 qingpugonglusuo. All rights reserved.
//

#import "UIImageView+FaceAwareFill.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>
#define BETTER_LAYER_NAME @"BETTER_LAYER_NAME"
#define GOLDEN_RATIO (0.618)

#ifdef BF_DEBUG
#define BFLog(format...) NSLog(format)
#else
#define BFLog(format...)
#endif

static CIDetector *detector;


static CIDetector* _faceDetector;

@implementation UIImageView (FaceAwareFill)
#pragma mark -

void hack_uiimageview_bf(){
    Method oriSetImgMethod = class_getInstanceMethod([UIImageView class], @selector(setImage:));
    Method newSetImgMethod = class_getInstanceMethod([UIImageView class], @selector(_setBetterFaceImage:));
    method_exchangeImplementations(newSetImgMethod, oriSetImgMethod);
}

- (void)setBetterFaceImage:(UIImage *)image{
    [self setImage:image];
    if (![self needsBetterFace]) {
        return;
    }
    
    [self faceDetect:image];
}

- (void)_setBetterFaceImage:(UIImage *)image{
    [self _setBetterFaceImage:image];
    if (![self needsBetterFace]) {
        return;
    }
    
    [self faceDetect:image];
}

char nbfKey;
- (void)setNeedsBetterFace:(BOOL)needsBetterFace{
    objc_setAssociatedObject(self,
                             &nbfKey,
                             [NSNumber numberWithBool:needsBetterFace],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)needsBetterFace{
    NSNumber *associatedObject = objc_getAssociatedObject(self, &nbfKey);
    return [associatedObject boolValue];
}

char fastSpeedKey;
- (void)setFast:(BOOL)fast{
    objc_setAssociatedObject(self,
                             &fastSpeedKey,
                             [NSNumber numberWithBool:fast],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

char detectorKey;
- (void)setDetector:(CIDetector *)detector{
    objc_setAssociatedObject(self,
                             &detectorKey,
                             detector,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CIDetector *)detector{
    return objc_getAssociatedObject(self, &detectorKey);
}

- (BOOL)fast{
    NSNumber *associatedObject = objc_getAssociatedObject(self, &fastSpeedKey);
    return [associatedObject boolValue];
}

- (void)faceDetect:(UIImage *)aImage
{
    dispatch_queue_t queue = dispatch_queue_create("com.croath.betterface.queue", NULL);
    dispatch_async(queue, ^{
        CIImage* image = aImage.CIImage;
        if (image == nil) { // just in case the UIImage was created using a CGImage revert to the previous, slower implementation
            image = [CIImage imageWithCGImage:aImage.CGImage];
        }
        if (detector == nil) {
            NSDictionary  *opts = [NSDictionary dictionaryWithObject:[self fast] ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh
                                                              forKey:CIDetectorAccuracy];
            detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                          context:nil
                                          options:opts];
        }
        
        NSArray* features = [detector featuresInImage:image];
        
        if ([features count] == 0) {
            BFLog(@"no faces");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self imageLayer] removeFromSuperlayer];
            });
        } else {
            BFLog(@"succeed %lu faces", (unsigned long)[features count]);
            [self markAfterFaceDetect:features
                                 size:CGSizeMake(CGImageGetWidth(aImage.CGImage),
                                                 CGImageGetHeight(aImage.CGImage))];
        }
    });
}

-(void)markAfterFaceDetect:(NSArray *)features size:(CGSize)size{
    CGRect fixedRect = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    CGFloat rightBorder = 0, bottomBorder = 0;
    for (CIFaceFeature *f in features){
        CGRect oneRect = f.bounds;
        oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height;
        
        fixedRect.origin.x = MIN(oneRect.origin.x, fixedRect.origin.x);
        fixedRect.origin.y = MIN(oneRect.origin.y, fixedRect.origin.y);
        
        rightBorder = MAX(oneRect.origin.x + oneRect.size.width, rightBorder);
        bottomBorder = MAX(oneRect.origin.y + oneRect.size.height, bottomBorder);
    }
    
    fixedRect.size.width = rightBorder - fixedRect.origin.x;
    fixedRect.size.height = bottomBorder - fixedRect.origin.y;
    
    CGPoint fixedCenter = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0,
                                      fixedRect.origin.y + fixedRect.size.height / 2.0);
    CGPoint offset = CGPointZero;
    CGSize finalSize = size;
    if (size.width / size.height > self.bounds.size.width / self.bounds.size.height) {
        //move horizonal
        finalSize.height = self.bounds.size.height;
        finalSize.width = size.width/size.height * finalSize.height;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.x = fixedCenter.x - self.bounds.size.width * 0.5;
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x + self.bounds.size.width > finalSize.width) {
            offset.x = finalSize.width - self.bounds.size.width;
        }
        offset.x = - offset.x;
    } else {
        //move vertical
        finalSize.width = self.bounds.size.width;
        finalSize.height = size.height/size.width * finalSize.width;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.y = fixedCenter.y - self.bounds.size.height * (1-GOLDEN_RATIO);
        if (offset.y < 0) {
            offset.y = 0;
        } else if (offset.y + self.bounds.size.height > finalSize.height){
            offset.y = finalSize.height - self.bounds.size.height;
        }
        offset.y = - offset.y;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *layer = [self imageLayer];
        layer.frame = CGRectMake(offset.x,
                                 offset.y,
                                 finalSize.width,
                                 finalSize.height);
        layer.contents = (id)self.image.CGImage;
    });
}

- (CALayer *)imageLayer {
    for (CALayer *layer in [self.layer sublayers]) {
        if ([[layer name] isEqualToString:BETTER_LAYER_NAME]) {
            return layer;
        }
    }
    
    CALayer *layer = [CALayer layer];
    [layer setName:BETTER_LAYER_NAME];
    layer.actions = @{@"contents": [NSNull null],
                      @"bounds": [NSNull null],
                      @"position": [NSNull null]};
    [self.layer addSublayer:layer];
    return layer;
}


+ (void)initialize{
    _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                       context:nil
                                       options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    
}

// based on this: http://maniacdev.com/2011/11/tutorial-easy-face-detection-with-core-image-in-ios-5/
- (void)at_faceAwareFill {
    // Safe check!
    if (self.image == nil) {
        return;
    }
    
    CGRect facesRect = [self rectWithFaces];
    if (facesRect.size.height + facesRect.size.width == 0)
        return;
    self.contentMode = UIViewContentModeTopLeft;
    [self scaleImageFocusingOnRect:facesRect];
}

- (CGRect)rectWithFaces {
    // Get a CIIImage
    CIImage* image = self.image.CIImage;
    
    // If now available we create one using the CGImage
    if (!image) {
        image = [CIImage imageWithCGImage:self.image.CGImage];
    }
    
    // Use the static CIDetector
    CIDetector* detector = _faceDetector;
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.
    CGRect totalFaceRects = CGRectMake(self.image.size.width/2.0, self.image.size.height/2.0, 0, 0);
    
    if (features.count > 0) {
        //We get the CGRect of the first detected face
        totalFaceRects = ((CIFaceFeature*)[features objectAtIndex:0]).bounds;
        
        // Now we find the minimum CGRect that holds all the faces
        for (CIFaceFeature* faceFeature in features) {
            totalFaceRects = CGRectUnion(totalFaceRects, faceFeature.bounds);
        }
    }
    
    //So now we have either a CGRect holding the center of the image or all the faces.
    return totalFaceRects;
}

- (void)scaleImageFocusingOnRect:(CGRect) facesRect {
    CGFloat multi1 = self.frame.size.width / self.image.size.width;
    CGFloat multi2 = self.frame.size.height / self.image.size.height;
    CGFloat multi = MAX(multi1, multi2);
    
    //We need to 'flip' the Y coordinate to make it match the iOS coordinate system one
    facesRect.origin.y = self.image.size.height - facesRect.origin.y - facesRect.size.height;
    
    facesRect = CGRectMake(facesRect.origin.x*multi, facesRect.origin.y*multi, facesRect.size.width*multi, facesRect.size.height*multi);
    
    CGRect imageRect = CGRectZero;
    imageRect.size.width = self.image.size.width * multi;
    imageRect.size.height = self.image.size.height * multi;
    imageRect.origin.x = MIN(0.0, MAX(-facesRect.origin.x + self.frame.size.width/2.0 - facesRect.size.width/2.0, -imageRect.size.width + self.frame.size.width));
    imageRect.origin.y = MIN(0.0, MAX(-facesRect.origin.y + self.frame.size.height/2.0 -facesRect.size.height/2.0, -imageRect.size.height + self.frame.size.height));
    
    imageRect = CGRectIntegral(imageRect);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, 2.0);
    [self.image drawInRect:imageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newImage;
    
    //This is to show the red rectangle over the faces
#ifdef DEBUGGING_FACE_AWARE_FILL
    NSInteger theRedRectangleTag = -3312;
    UIView* facesRectLine = [self viewWithTag:theRedRectangleTag];
    if (!facesRectLine) {
        facesRectLine = [[UIView alloc] initWithFrame:facesRect];
        facesRectLine.tag = theRedRectangleTag;
    }else {
        facesRectLine.frame = facesRect;
    }
    
    facesRectLine.backgroundColor = [UIColor clearColor];
    facesRectLine.layer.borderColor = [UIColor redColor].CGColor;
    facesRectLine.layer.borderWidth = 4.0;
    
    CGRect frame = facesRectLine.frame;
    frame.origin.x = imageRect.origin.x + frame.origin.x;
    frame.origin.y = imageRect.origin.y + frame.origin.y;
    facesRectLine.frame = frame;
    
    [self addSubview:facesRectLine];
#endif
}

@end

