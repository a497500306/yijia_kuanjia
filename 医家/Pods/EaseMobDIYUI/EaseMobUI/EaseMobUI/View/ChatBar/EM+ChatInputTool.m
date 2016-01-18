//
//  EM+MessageInputTool.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatInputTool.h"
#import "EM+ChatInputView.h"

#import "EM+ChatUIConfig.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

#define PADDING (5)

@interface EM_ChatInputTool()<UITextViewDelegate>

@property (nonatomic,strong) EM_ChatUIConfig *config;

@end

@implementation EM_ChatInputTool{
    EM_ChatInputView *inputView;
    UIButton *recordButton;
    UIButton *emojiButton;
    UIButton *actionButton;
    UIButton *moreStateButton;
    CGSize oldContentSize;
    UIEdgeInsets contentInsets;
}

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config{
    self = [super init];
    if (self) {
        
        _config = config;
        _avtive = YES;
        oldContentSize = CGSizeZero;
        
        //录音按钮
        recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recordButton.layer.masksToBounds = YES;
        recordButton.hidden = _config.hiddenOfRecord;
        recordButton.contentEdgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        [recordButton addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordButton];
        
        NSDictionary *recordDictionary = _config.toolDictionary[kButtonNameRecord];
        [self setButton:recordButton attribute:recordDictionary];
        
        //表情按钮
        emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emojiButton.layer.masksToBounds = YES;
        emojiButton.hidden = _config.hiddenOfEmoji;
        emojiButton.contentEdgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        [emojiButton addTarget:self action:@selector(emojiClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emojiButton];
        
        NSDictionary *emojiDictionary = _config.toolDictionary[kButtonNameEmoji];
        [self setButton:emojiButton attribute:emojiDictionary];
        
        //动作按钮
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.layer.masksToBounds = YES;
        actionButton.hidden = _config.actionDictionary.count == 0;
        actionButton.contentEdgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        [actionButton addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionButton];
        
        NSDictionary *actionDictionary = _config.toolDictionary[kButtonNameAction];
        [self setButton:actionButton attribute:actionDictionary];
        
        inputView = [[EM_ChatInputView alloc]init];
        inputView.delegate = self;
        [self addSubview:inputView];
        
        contentInsets = inputView.contentInset;
        
        moreStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreStateButton.hidden = YES;
        moreStateButton.backgroundColor = [UIColor colorWithHexRGB:0xF8F8F8];
        moreStateButton.layer.cornerRadius = 6;
        moreStateButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:50];
        [moreStateButton setTitle:kEMChatIconToolDown forState:UIControlStateNormal];
        [moreStateButton setTitle:kEMChatIconToolUp forState:UIControlStateSelected];
        [moreStateButton setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [moreStateButton setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateHighlighted];
        [moreStateButton addTarget:self action:@selector(stateClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreStateButton];
    }
    return self;
}

- (void)setButton:(UIButton *)button attribute:(NSDictionary *)attribute{
    if (!attribute || attribute.count == 0) {
        return;
    }
    UIFont *font = attribute[kAttributeFont];
    if (font) {
        button.titleLabel.font = font;
        NSString *text = attribute[kAttributeText];
        [button setTitle:text forState:UIControlStateNormal];
        
        UIColor *normalColor = attribute[kAttributeNormalColor];
        if (normalColor) {
            [button setTitleColor:normalColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        }
        
        UIColor *highlightColor = attribute[kAttributeHighlightColor];
        if (highlightColor) {
            [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
        }else{
            [button setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateHighlighted];
        }
    }else{
        UIImage *normalImage = attribute[kAttributeNormalImage];
        if (normalImage) {
            [button setImage:normalImage forState:UIControlStateNormal];
        }
        
        UIImage *highlightImage = attribute[kAttributeHighlightImage];
        if (highlightImage) {
            [button setImage:highlightImage forState:UIControlStateHighlighted];
        }
    }
}

- (void)setAvtive:(BOOL)avtive{
    _avtive = avtive;
    recordButton.enabled = _avtive;
    emojiButton.enabled = _avtive;
    actionButton.enabled = _avtive;
    moreStateButton.enabled = _avtive;
    inputView.editable = _avtive;
}

- (void)setOverrideNextResponder:(UIResponder *)overrideNextResponder{
    inputView.overrideNextResponder = overrideNextResponder;
}

- (NSString *)editor{
    return inputView.text;
}

- (void)setEditor:(NSString *)editor{
    inputView.text = editor;
}

- (BOOL)inputEditing{
    return inputView.isFirstResponder;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;

    CGFloat buttonSize = HEIGHT_INPUT_OF_DEFAULT - PADDING * 2;
    
    recordButton.frame = CGRectMake(0, size.height - buttonSize - PADDING, buttonSize, buttonSize);
    actionButton.frame = CGRectMake(size.width - buttonSize, size.height - buttonSize - PADDING, buttonSize, buttonSize);
    emojiButton.frame = CGRectMake(size.width - buttonSize * 2, size.height - buttonSize - PADDING, buttonSize, buttonSize);
    
    CGPoint inputOrigin = CGPointMake(0, PADDING);
    CGSize inputSize = CGSizeMake(size.width, size.height - PADDING * 2);
    
    if (recordButton.hidden) {
        inputOrigin.x = PADDING;
        inputSize.width -= PADDING;
    }else{
        inputOrigin.x = recordButton.frame.size.width;
        inputSize.width -= recordButton.frame.size.width;
    }
    
    if (actionButton.hidden) {
        inputSize.width -= PADDING;
    }else{
        inputSize.width -= actionButton.frame.size.width;
    }
    
    if (!emojiButton.hidden) {
        inputSize.width -= emojiButton.frame.size.width;
    }
    
    inputView.frame = CGRectMake(inputOrigin.x, inputOrigin.y, inputSize.width, inputSize.height);
    [inputView scrollRangeToVisible:NSMakeRange(inputView.text.length, 1)];
    
    moreStateButton.frame = inputView.frame;
    moreStateButton.contentEdgeInsets = UIEdgeInsetsMake(0, buttonSize, 0, 0);
}

- (CGSize)contentSize{
    CGRect contentRect = [inputView.text boundingRectWithSize:CGSizeMake(inputView.contentSize.width, HEIGHT_INPUT_OF_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:inputView.font,NSFontAttributeName, nil] context:nil];
    CGSize contentSize = contentRect.size;
    contentSize.width = self.bounds.size.width;
    contentSize.height += (inputView.textContainerInset.top + inputView.textContainerInset.bottom + PADDING * 2);
    return contentSize;
}

- (void)addMessage:(NSString *)message{
    NSString *content = inputView.text;
    inputView.text = [NSString stringWithFormat:@"%@%@",content ? content : @"",message];
    [self textViewDidChange:inputView];
}

- (void)deleteMessage{
    NSString *message = inputView.text;
    if (message && message.length > 0) {
        [message enumerateSubstringsInRange:NSMakeRange(0, message.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (message.length - substring.length == substringRange.location) {
                inputView.text = [message substringToIndex:substringRange.location];
                [self textViewDidChange:inputView];
            }
        }];
    }
}

- (void)sendMessage{
    
    BOOL shouldSend = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(shouldMessageSend:)]) {
        shouldSend = [_delegate shouldMessageSend:inputView.text];
    }
    
    if (shouldSend) {
        if (_delegate && [_delegate respondsToSelector:@selector(didMessageSend:)]) {
            NSString *message = [inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (message && message.length > 0) {
                [self.delegate didMessageSend:message];
            }
        }
        inputView.text = nil;
        [self textViewDidChange:inputView];
    }
}

- (void)dismissKeyboard{
    if (inputView.isFirstResponder) {
        [inputView resignFirstResponder];
    }
}

- (void)showKeyboard{
    [inputView becomeFirstResponder];
}

- (void)setStateRecord:(BOOL)stateRecord{
    _stateRecord = stateRecord;
    
    moreStateButton.hidden = !self.stateRecord;
    self.stateMore = !_stateRecord;
    
    if (_stateRecord) {
        NSDictionary *keyboardDictionary = _config.toolDictionary[kButtonNameKeyboard];
        [self setButton:recordButton attribute:keyboardDictionary];
    }else{
        NSDictionary *recordDictionary = _config.toolDictionary[kButtonNameRecord];
        [self setButton:recordButton attribute:recordDictionary];
    }
}

- (void)setStateEmoji:(BOOL)stateEmoji{
    _stateEmoji = stateEmoji;
    
    if (_stateEmoji) {
        NSDictionary *keyboardDictionary = _config.toolDictionary[kButtonNameKeyboard];
        [self setButton:emojiButton attribute:keyboardDictionary];
    }else{
        NSDictionary *emojiDictionary = _config.toolDictionary[kButtonNameEmoji];
        [self setButton:emojiButton attribute:emojiDictionary];
    }
}

- (void)setStateAction:(BOOL)stateAction{
    _stateAction = stateAction;
    
    if (_stateAction) {
        NSDictionary *keyboardDictionary = _config.toolDictionary[kButtonNameKeyboard];
        [self setButton:actionButton attribute:keyboardDictionary];
    }else{
        NSDictionary *actionDictionary = _config.toolDictionary[kButtonNameAction];
        [self setButton:actionButton attribute:actionDictionary];
    }
}

- (void)setStateMore:(BOOL)stateMore{
    moreStateButton.selected = stateMore;
}

- (BOOL)stateMore{
    return moreStateButton.selected;
}

//录音按钮
- (void)recordClicked:(UIButton *)sender{
    self.stateRecord = !_stateRecord;
    self.stateEmoji = NO;
    self.stateAction = NO;
    
    if (_delegate) {
        [_delegate didRecordStateChanged:_stateRecord];
    }
}

//表情按钮
- (void)emojiClicked:(UIButton *)sender{
    self.stateEmoji = !_stateEmoji;
    self.stateRecord = NO;
    self.stateAction = NO;
    
    if (_delegate) {
        [_delegate didEmojiStateChanged:_stateEmoji];
    }
}

//动作按钮
- (void)actionClicked:(UIButton *)sender{
    self.stateAction = !_stateAction;
    self.stateRecord = NO;
    self.stateEmoji = NO;
    
    if (_delegate) {
        [_delegate didActionStateChanged:_stateAction];
    }
}

- (void)stateClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate) {
        [_delegate didMoreStateChanged:sender.selected];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.stateAction = NO;
    self.stateEmoji = NO;
    self.stateRecord = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView && textView.text && textView.text.length > 0){
        
        CGSize contentSize = self.contentSize;
        
        if (CGSizeEqualToSize(CGSizeZero,oldContentSize)) {
            oldContentSize = contentSize;
        }
        
        if (contentSize.height != inputView.bounds.size.height
            && ((contentSize.height < HEIGHT_INPUT_OF_MAX && contentSize.height > HEIGHT_INPUT_OF_DEFAULT)
                || (contentSize.height > HEIGHT_INPUT_OF_MAX && inputView.bounds.size.height < HEIGHT_INPUT_OF_MAX))) {
            if (_delegate && [_delegate respondsToSelector:@selector(didMessageChanged:oldContentSize:newContentSize:)]) {
                [_delegate didMessageChanged:textView.text oldContentSize:oldContentSize newContentSize:contentSize];
            }
            oldContentSize = contentSize;
        }else{
            [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(didMessageChanged:oldContentSize:newContentSize:)]) {
            [_delegate didMessageChanged:nil oldContentSize:CGSizeZero newContentSize:oldContentSize];
        }
        oldContentSize = CGSizeZero;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return YES;
}

@end