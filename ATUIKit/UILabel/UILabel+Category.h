//
//  UILabel+Category.h
//  QuickLabel
//
//  Created by jack on 16/10/17.
//  Copyright © 2016年 jack. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef struct {
    __unsafe_unretained UIColor * color;
    BOOL isBg;
}ColorTypeStruct ;

@class ColorTypeModel;
NSString * MakeText(NSString *text);
UIFont   * MakeTextFont(UIFont *font);
NSNumber * MakeTextAlignment(NSTextAlignment ali);
NSValue  * MakeRect(CGFloat x,CGFloat y,CGFloat width,CGFloat height);
UIView   * MakeSuperView(UIView *superView);

ColorTypeModel * MakeTextColor(UIColor *tColor);
ColorTypeModel * MakeBackgroundColor(UIColor *bgColor);

UIView * AddToSuperView(UIView *superView);

@interface UILabel (Category)
#pragma mark Reactive Programming
- (UILabel * (^)(NSTextAlignment))CTextAlignment;
- (UILabel * (^)(UIColor *))CBackgroundColor;
- (UILabel * (^)(UIColor *))CTextColor;
- (UILabel * (^)(NSString *))CText;
- (UILabel * (^)(float))CFontSize;
- (UILabel * (^)(CGRect))CRect;

- (UILabel * (^)(UIView *))AddToSuperView;

#pragma mark Attributes & va_list
@property (nonatomic,strong)NSMutableArray *attributes;
- (NSArray *)makeAttributes:(id)attribute, ...;
- (void)addAttributes:(NSMutableArray *)attributes;
@end



////..case 1
//
//    [label makeAttributes:@"qwe",
//           MakeTextAlignment(NSTextAlignmentCenter),
//           MakeBackgroundColor([UIColor redColor]),
//           MakeRect(10,10,100,100),
//           MakeTextColor([UIColor blueColor]),
//           MakeTextFont([UIFont systemFontOfSize:20.f]),
//           AddToSuperView(self.view),
//           nil];
//    
////..case 2
//
//    label.CBackgroundColor([UIColor redColor])
//         .CText(@"asdad")
//         .CTextColor([UIColor whiteColor])
//         .CTextAlignment(1)
//         .CFontSize(18.f)
//         .CRect(CGRectMake(0, 0, 100, 100))
//         .AddToSuperView(self.view);
////..end
//
//    [label2 addAttributes:label.attributes];
