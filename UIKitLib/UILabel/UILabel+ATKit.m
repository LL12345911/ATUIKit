//
//  UILabel+ATAdaptContent.m
//  HighwayDoctor
//
//  Created by Mars on 2019/5/10.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "UILabel+ATKit.h"
#import <CoreText/CoreText.h>

@implementation UILabel (ATKit)

/// 两端对齐  label
- (void)textAlignmentLeftAndRight{
    [self textAlignmentLeftAndRightWith:CGRectGetWidth(self.frame)];
    
}


/// 指定Label以最后的冒号对齐的width两端对齐
/// @param labelWidth 指定宽度
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth{
    if(self.text==nil||self.text.length==0) {
        return;
    }
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    NSInteger length = (self.text.length-1);
    NSString* lastStr = [self.text substringWithRange:NSMakeRange(self.text.length-1,1)];
    
    // 中文字符长度1，英文字符及数字长度0.5
    if([lastStr isEqualToString:@":"] || [lastStr isEqualToString:@"："]) {
        length = (self.text.length-2);
    }
    
    CGFloat margin = (labelWidth - size.width)/length;
    NSNumber*number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];
    
    self.attributedText= attribute;
}

//
//- (void)setColumnSpace:(CGFloat)columnSpace
//{
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    //调整间距
//    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
//    self.attributedText = attributedString;
//}
//
//- (void)setRowSpace:(CGFloat)rowSpace
//{
//    self.numberOfLines = 0;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    //调整行距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = rowSpace;
//    //    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
//    self.attributedText = attributedString;
//}
//
//- (void)setTextDirection:(ATTextDirection)direction
//{
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    //调整行距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    if (direction == ATTextDirectionNatural) {
//        paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
//    }else if (direction == ATTextDirectionRight){
//        paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
//    }else{
//        paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
//    }
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
//    self.attributedText = attributedString;
//}
//
//
//+ (instancetype) at_createLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor{
//    @autoreleasepool {
//        UILabel *label = [[UILabel alloc] init];
//        label.text = text.length > 0 ? text : @"";
//        label.font = font ? font : [UIFont systemFontOfSize:17];
//        label.textColor = textColor ? textColor : [UIColor blackColor];
//        return label;
//    }
//}

#pragma mark - 
#pragma mark - ATAutoSize
- (void)setContentHuggingWithLabelContent{
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (NSInteger)calculateLabelNumberOfRowsWithText:(NSString *)text
                                       withFont:(UIFont *)font
                                   withMaxWidth:(CGFloat)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return ceil(rect.size.height / font.lineHeight);
}

//获取文字所需行数
+ (NSInteger)needLinesWithWidth:(CGFloat)width currentLabel:(UILabel *)currentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = currentLabel.font;
    NSString *text = currentLabel.text;
    NSInteger sum = 0;
    //加上换行符
    NSArray *rowType = [text componentsSeparatedByString:@"\n"];
    for (NSString *currentText in rowType) {
        label.text = currentText;
        //获取需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceil(textSize.width/width);
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}


-(UILabel *)at_resizeLabelHorizontal{
    return [self at_resizeLabelHorizontal:0];
}

- (UILabel *)at_resizeLabelVertical{
    return [self at_resizeLabelVertical:0];
}

- (UILabel *)at_resizeLabelVertical:(CGFloat)minimumHeigh{
    CGRect newFrame = self.frame;
    CGSize constrainedSize = CGSizeMake(newFrame.size.width, CGFLOAT_MAX);
    NSString *text = self.text;
    UIFont *font = self.font;
    CGSize size = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        size = [text boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED <= 60000)
        size = [text sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    newFrame.size.height = ceilf(size.height);
    if(minimumHeigh > 0){
        newFrame.size.height = (newFrame.size.height < minimumHeigh ? minimumHeigh : newFrame.size.height);
    }
    self.frame = newFrame;
    return self;
}

- (UILabel *)at_resizeLabelHorizontal:(CGFloat)minimumWidth{
    CGRect newFrame = self.frame;
    CGSize constrainedSize = CGSizeMake(CGFLOAT_MAX, newFrame.size.height);
    NSString *text = self.text;
    UIFont *font = self.font;
    CGSize size = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        size = [text boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED <= 60000)
        size = [text sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    newFrame.size.width = ceilf(size.width);
    if(minimumWidth > 0){
        newFrame.size.width = (newFrame.size.width < minimumWidth ? minimumWidth: newFrame.size.width);
    }
    self.frame = newFrame;
    return self;
}




//
//- (CGSize)contentSize {
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = self.lineBreakMode;
//    paragraphStyle.alignment = self.textAlignment;
//    
//    NSDictionary * attributes = @{NSFontAttributeName : self.font,
//                                  NSParagraphStyleAttributeName : paragraphStyle};
//    
//    CGSize contentSize = [self.text boundingRectWithSize:self.frame.size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
//    return contentSize;
//}

//UILabel text两边对齐的实现代码
+(NSAttributedString *)setTextString:(NSString *)text
{  NSMutableAttributedString *mAbStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentJustified;
    npgStyle.paragraphSpacing = 11.0;
    npgStyle.paragraphSpacingBefore = 10.0;
    npgStyle.firstLineHeadIndent = 0.0;
    npgStyle.headIndent = 0.0;
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSFontAttributeName      :[UIFont systemFontOfSize:15.0],
                          NSParagraphStyleAttributeName :npgStyle,
                          NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleNone]
                          };
    [mAbStr setAttributes:dic range:NSMakeRange(0, mAbStr.length)];
    NSAttributedString *attrString = [mAbStr copy];
    return attrString;
}


#pragma mark -- 配置 label 的属性【行间距】【要显示的最大宽度】
+ (void)configPropertyWithLabel:(UILabel *)label font:(CGFloat)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = size.height+1>font*2 ? lineSpace:0;
    NSRange range = NSMakeRange(0, [label.text length]);
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:NSBaselineOffsetAttributeName range:range];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:range];
    
    label.attributedText = attributedString;
}

#pragma mark -- 计算带有行间距的 label 的高度
+ (CGFloat)getHeightWithLabel:(UILabel *)label font:(CGFloat)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth
{
    CGFloat labelHeight = 0.0f;
    CGSize originSize = [label.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = originSize.height+1>font*2 ? lineSpace:0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font],
                          NSParagraphStyleAttributeName:paraStyle
                          ,NSBaselineOffsetAttributeName:NSBaselineOffsetAttributeName};
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(maxWidth,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    labelHeight = size.height+1;
    return labelHeight;
}

#pragma mark -- 计算文字单行显示的宽度
+ (CGFloat)getWidthWithLabel:(UILabel *)label font:(CGFloat)font
{
    // 当文字单行显示的时候 label 的高度
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width+1;
}

@end


