//
//  UITextField+ATKit.m
//  HighwayDoctor
//
//  Created by Mars on 2019/5/7.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "UITextField+ATKit.h"
#import <objc/runtime.h>

@interface _NSNotificationWeakTarget : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, weak) id<NSObject> note;
@end
@implementation _NSNotificationWeakTarget

- (instancetype)initWithTarget:(id)target
                          name:(NSString *)name
                         block:(void(^)(NSNotification * _Nonnull note))block {
    if (self = [super init]) {
        _target = target;
        _note = [[NSNotificationCenter defaultCenter] addObserverForName:name object:target queue:nil usingBlock:block];
    }
    return self;
}

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:_note];
    } @catch (NSException *exception) {
    }
}
@end

NSRange textInputTrimByLength(UIView<UITextInput> *input, NSInteger maxLength) {
    if (maxLength < 0) {
        return NSMakeRange(0, 0);
    }
    NSString *text = [input textInRange:[input textRangeFromPosition:input.beginningOfDocument toPosition:input.endOfDocument]];
    if (maxLength < text.length) {
        NSInteger offset = [input offsetFromPosition:input.beginningOfDocument toPosition:input.selectedTextRange.end];
        NSInteger del = text.length - maxLength;
        NSInteger start = offset > del ? offset - del : 0;
        NSRange range = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(start, del)];
        UITextRange *textRange = [input textRangeFromPosition:[input positionFromPosition:input.beginningOfDocument offset:range.location] toPosition:[input positionFromPosition:input.beginningOfDocument offset:NSMaxRange(range)]];
        [input replaceRange:textRange withText:@""];
        return range;
    }
    return NSMakeRange(0, 0);
}

static const char targetKey = '\0';


static const void *ATTextFieldInputLimitMaxLength = &ATTextFieldInputLimitMaxLength;
//leftView(UIImageView)
static const void *AT_LeftImageViewKey = &AT_LeftImageViewKey;
static const void *AT_LeftViewKey = &AT_LeftViewKey;

//Blocks
typedef BOOL (^ATUITextFieldReturnBlock) (UITextField *textField);
typedef void (^ATUITextFieldVoidBlock) (UITextField *textField);
typedef BOOL (^ATUITextFieldCharacterChangeBlock) (UITextField *textField, NSRange range, NSString *replacementString);

static const void *ATUITextFieldDelegateKey = &ATUITextFieldDelegateKey;
static const void *ATUITextFieldShouldBeginEditingKey = &ATUITextFieldShouldBeginEditingKey;
static const void *ATUITextFieldShouldEndEditingKey = &ATUITextFieldShouldEndEditingKey;
static const void *ATUITextFieldDidBeginEditingKey = &ATUITextFieldDidBeginEditingKey;
static const void *ATUITextFieldDidEndEditingKey = &ATUITextFieldDidEndEditingKey;
static const void *ATUITextFieldShouldChangeCharactersInRangeKey = &ATUITextFieldShouldChangeCharactersInRangeKey;
static const void *ATUITextFieldShouldClearKey = &ATUITextFieldShouldClearKey;
static const void *ATUITextFieldShouldReturnKey = &ATUITextFieldShouldReturnKey;

@implementation UITextField (ATKit)

#pragma mark -  UITextField限制字数
- (NSInteger)at_maxLength {
    return [objc_getAssociatedObject(self, ATTextFieldInputLimitMaxLength) integerValue];
}


- (void)setAt_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, ATTextFieldInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(at_textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)at_textFieldTextDidChange {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.at_maxLength > 0 && toBeString.length > self.at_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.at_maxLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeString substringToIndex:self.at_maxLength];
        }
        else
        {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.at_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.at_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}


#pragma mark - 
- (instancetype)at_createTextFeildWithPlaceholder:(NSString *)placeholder textColor:(UIColor *)textColor font:(UIFont *)font{
    @autoreleasepool {
        UITextField *feild = [[UITextField alloc] init];
        feild.placeholder = placeholder.length > 0 ? placeholder : @"";
        feild.textColor = textColor ? textColor : [UIColor blackColor];
        if (font) {
            feild.font = font;
        }
        return feild;
    }
}


- (void)notifyChange:(NSInteger (^)(UITextField *, NSString *))block {
    _NSNotificationWeakTarget *target;
    if (block) {
        __weak typeof(self)weakSelf = self;
        target = [[_NSNotificationWeakTarget alloc] initWithTarget:weakSelf name:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull note) {
            if (!weakSelf.markedTextRange) {
                NSInteger maxLength = block(weakSelf, weakSelf.text);
                textInputTrimByLength(weakSelf, maxLength);
            }
        }];
    }
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - leftView(UIImageView)

- (UIImageView *)at_leftImageView{
    return objc_getAssociatedObject(self, AT_LeftImageViewKey);
}

- (void)setAt_leftImageView:(UIImageView *)at_leftImageView{
    objc_setAssociatedObject(self, AT_LeftImageViewKey, at_leftImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**
 设置 左边视图
 
 @param imageName 图片名称
 @param margin 到左边和右边的间距（上下默认间距为5）
 */
- (void)at_leftView:(NSString *)imageName leftAndRightMargin:(CGFloat)margin{
    [self removeLeftImageView];
    self.at_leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 5, self.frame.size.height-10, self.frame.size.height-10)];
    self.at_leftImageView.image = [UIImage imageNamed:imageName];
    self.at_leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.at_leftImageView];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] init];
    self.leftView.frame = CGRectMake(0, 0, self.frame.size.height-10+margin*2, self.frame.size.height);
    self.leftView.frame = CGRectMake(0, 0, self.frame.size.height-10+margin, self.frame.size.height);
}
/**
 添加 UITextField 左边视图
 
 @param imageName 图片名称
 @param margin 到左边和右边的间距】
 @param bottom 到上边和下边的间距
 */
- (void)at_leftView:(NSString *)imageName leftAndRightMargin:(CGFloat)margin topAndBottom:(CGFloat)bottom{
    [self removeLeftImageView];
    
    CGFloat height = self.frame.size.height-bottom*2;
    
    self.at_leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, bottom, height, height)];
    self.at_leftImageView.image = [UIImage imageNamed:imageName];
    self.at_leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.at_leftImageView];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] init];
    self.leftView.frame = CGRectMake(0, 0, height+margin*1, self.frame.size.height);
    
//    CGFloat height = self.frame.size.height-bottom*2;
//
//    self.at_leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, bottom, height, height)];
//    self.at_leftImageView.image = [UIImage imageNamed:imageName];
//    self.at_leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:self.at_leftImageView];
//
//    self.leftViewMode = UITextFieldViewModeAlways;
//    self.leftView = [[UIView alloc] init];
//    self.leftView.frame = CGRectMake(0, 0, height+margin*2, self.frame.size.height);
}
/**
 移除 UITextField 左边视图
 */
- (void)removeLeftImageView{
    self.leftViewMode = UITextFieldViewModeNever;
    [self.at_leftImageView removeFromSuperview];
    self.leftView.frame = CGRectMake(0, 0, 0, 0);
    
}



#pragma mark - Shake
- (void)at_shake {
    [self at_shake:10 withDelta:5 completion:nil];
}

- (void)at_shake:(int)times withDelta:(CGFloat)delta {
    [self at_shake:times withDelta:delta completion:nil];
}

- (void)at_shake:(int)times withDelta:(CGFloat)delta completion:(void(^)(void))handler {
    [self _at_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:ATShakedDirectionHorizontal completion:handler];
}

- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self at_shake:times withDelta:delta speed:interval completion:nil];
}

- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^)(void))handler {
    [self _at_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:ATShakedDirectionHorizontal completion:handler];
}

- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ATShakedDirection)shakeDirection {
    [self at_shake:times withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ATShakedDirection)shakeDirection completion:(void(^)(void))handler {
    [self _at_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:handler];
}

- (void)_at_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ATShakedDirection)shakeDirection completion:(void(^)(void))handler {
    [UIView animateWithDuration:interval animations:^{
        self.transform = (shakeDirection == ATShakedDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (handler) {
                    handler();
                }
            }];
            return;
        }
        [self _at_shake:(times - 1)
              direction:direction * -1
           currentTimes:current + 1
              withDelta:delta
                  speed:interval
         shakeDirection:shakeDirection
             completion:handler];
    }];
}



#pragma mark - Blocks
//#pragma mark UITextField Delegate methods
+ (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ATUITextFieldReturnBlock block = textField.at_shouldBegindEditingBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [delegate textFieldShouldBeginEditing:textField];
    }
    // return default value just in case
    return YES;
}
+ (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    ATUITextFieldReturnBlock block = textField.at_shouldEndEditingBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [delegate textFieldShouldEndEditing:textField];
    }
    // return default value just in case
    return YES;
}
+ (void)textFieldDidBeginEditing:(UITextField *)textField{
    ATUITextFieldVoidBlock block = textField.at_didBeginEditingBlock;
    if (block) {
        block(textField);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [delegate textFieldDidBeginEditing:textField];
    }
}
+ (void)textFieldDidEndEditing:(UITextField *)textField{
    ATUITextFieldVoidBlock block = textField.at_didEndEditingBlock;
    if (block) {
        block(textField);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [delegate textFieldDidBeginEditing:textField];
    }
}
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    ATUITextFieldCharacterChangeBlock block = textField.at_shouldChangeCharactersInRangeBlock;
    if (block) {
        return block(textField,range,string);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
+ (BOOL)textFieldShouldClear:(UITextField *)textField{
    ATUITextFieldReturnBlock block = textField.at_shouldClearBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [delegate textFieldShouldClear:textField];
    }
    return YES;
}
+ (BOOL)textFieldShouldReturn:(UITextField *)textField{
    ATUITextFieldReturnBlock block = textField.at_shouldReturnBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, ATUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [delegate textFieldShouldReturn:textField];
    }
    return YES;
}
#pragma mark Block setting/getting methods
- (BOOL (^)(UITextField *))at_shouldBegindEditingBlock{
    return objc_getAssociatedObject(self, ATUITextFieldShouldBeginEditingKey);
}
- (void)setAt_shouldBegindEditingBlock:(BOOL (^)(UITextField *))shouldBegindEditingBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldShouldBeginEditingKey, shouldBegindEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *))at_shouldEndEditingBlock{
    return objc_getAssociatedObject(self, ATUITextFieldShouldEndEditingKey);
}
- (void)setAt_shouldEndEditingBlock:(BOOL (^)(UITextField *))shouldEndEditingBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldShouldEndEditingKey, shouldEndEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(UITextField *))at_didBeginEditingBlock{
    return objc_getAssociatedObject(self, ATUITextFieldDidBeginEditingKey);
}
- (void)setAt_didBeginEditingBlock:(void (^)(UITextField *))didBeginEditingBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldDidBeginEditingKey, didBeginEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(UITextField *))at_didEndEditingBlock{
    return objc_getAssociatedObject(self, ATUITextFieldDidEndEditingKey);
}
- (void)setAt_didEndEditingBlock:(void (^)(UITextField *))didEndEditingBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldDidEndEditingKey, didEndEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *, NSRange, NSString *))at_shouldChangeCharactersInRangeBlock{
    return objc_getAssociatedObject(self, ATUITextFieldShouldChangeCharactersInRangeKey);
}
- (void)setAt_shouldChangeCharactersInRangeBlock:(BOOL (^)(UITextField *, NSRange, NSString *))shouldChangeCharactersInRangeBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldShouldChangeCharactersInRangeKey, shouldChangeCharactersInRangeBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *))at_shouldReturnBlock{
    return objc_getAssociatedObject(self, ATUITextFieldShouldReturnKey);
}
- (void)setAt_shouldReturnBlock:(BOOL (^)(UITextField *))shouldReturnBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldShouldReturnKey, shouldReturnBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *))at_shouldClearBlock{
    return objc_getAssociatedObject(self, ATUITextFieldShouldClearKey);
}
- (void)setAt_shouldClearBlock:(BOOL (^)(UITextField *textField))shouldClearBlock{
    [self at_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, ATUITextFieldShouldClearKey, shouldClearBlock, OBJC_ASSOCIATION_COPY);
}
#pragma mark control method
/*
 Setting itself as delegate if no other delegate has been set. This ensures the UITextField will use blocks if no delegate is set.
 */
- (void)at_setDelegateIfNoDelegateSet{
    if (self.delegate != (id<UITextFieldDelegate>)[self class]) {
        objc_setAssociatedObject(self, ATUITextFieldDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UITextFieldDelegate>)[self class];
    }
}





@end

@implementation UITextView (ATKit2)
- (void)notifyChange:(NSInteger (^)(UITextView *, NSString *))block {
    _NSNotificationWeakTarget *target;
    if (block) {
        __weak typeof(self)weakSelf = self;
        target = [[_NSNotificationWeakTarget alloc] initWithTarget:weakSelf name:UITextViewTextDidChangeNotification block:^(NSNotification * _Nonnull note) {
            if (!weakSelf.markedTextRange) {
                NSInteger maxLength = block(weakSelf, weakSelf.text);
                textInputTrimByLength(weakSelf, maxLength);
            }
        }];
    }
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_RETAIN);
}
@end


