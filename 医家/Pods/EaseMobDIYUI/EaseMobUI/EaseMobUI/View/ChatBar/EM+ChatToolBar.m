//
//  EM+MessageToolBar.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/2.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatToolBar.h"

#import "EM+Common.h"
#import "EM+ChatInputTool.h"
#import "EM+ChatMoreTool.h"
#import "EM+ChatTableView.h"
#import "EM+ChatUIConfig.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface EM_ChatToolBar()<EM_ChatInputToolDelegate,EM_ChatMoreToolDelegate,EM_ChatTableViewTapDelegate>

@property (nonatomic,strong) EM_ChatUIConfig *config;
@property (nonatomic, strong) UIView *cover;

@end

@implementation EM_ChatToolBar

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config{
    self = [super init];
    if (self) {
        
        _shouldReceiveKeyboardNotification = YES;
        _config = config;
        
        _inputToolView = [[EM_ChatInputTool alloc]initWithConfig:_config];
        _inputToolView.delegate = self;
        [self addSubview:_inputToolView];
        
        if (!_config.hiddenOfRecord || !_config.hiddenOfEmoji || _config.actionDictionary.count > 0) {
            _moreToolView = [[EM_ChatMoreTool alloc]initWithConfig:_config];
            _moreToolView.delegate = self;
            [self addSubview:_moreToolView];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setChatTableView:(EM_ChatTableView *)chatTableView{
    _chatTableView = chatTableView;
    if (_chatTableView) {
        _chatTableView.tapDelegate = self;
        UIEdgeInsets contentInset = _chatTableView.contentInset;
        contentInset.bottom = HEIGHT_INPUT_OF_DEFAULT;
        _chatTableView.contentInset = contentInset;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    _inputToolView.frame = CGRectMake(0, 0, size.width, size.height - HEIGHT_MORE_TOOL_OF_DEFAULT);
    if (_moreToolView) {
        _moreToolView.frame = CGRectMake(0, size.height - HEIGHT_MORE_TOOL_OF_DEFAULT, size.width, HEIGHT_MORE_TOOL_OF_DEFAULT);
    }
}

- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]init];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0;
        _cover.userInteractionEnabled = YES;
    }
    return _cover;
}

- (BOOL)inputEditing{
    return _inputToolView.inputEditing;
}

- (void)pullUpShow{
    if (_inputToolView.stateRecord) {
        [self showMoreTool];
        _inputToolView.stateMore = NO;
    }else{
        [_inputToolView showKeyboard];
    }
}

#pragma mark - keyboard action
#pragma mark -
- (void)keyboardWillShow:(NSNotification*)notification{
    if (!_shouldReceiveKeyboardNotification) {
        return;
    }
    [_moreToolView dismissTool:YES];
    
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect bounds = self.bounds;
    if (_inputToolView.stateRecord) {
        bounds.size.height = HEIGHT_INPUT_OF_DEFAULT + HEIGHT_MORE_TOOL_OF_DEFAULT;
    }else{
        bounds.size.height = _inputToolView.contentSize.height + HEIGHT_MORE_TOOL_OF_DEFAULT;
    }
    
    UIEdgeInsets contentInset = _chatTableView.contentInset;
    contentInset.bottom = _keyboardRect.size.height + (bounds.size.height - HEIGHT_MORE_TOOL_OF_DEFAULT);
    
    CGPoint center = self.center;
    center.y = _chatTableView.superview.frame.size.height - contentInset.bottom + bounds.size.height / 2;
    
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger options = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        _chatTableView.contentInset = contentInset;
        self.bounds = bounds;
        self.center = center;
    } completion:^(BOOL finished){
        _keyboardVisible = YES;
        _moreToolVisble = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didShowToolOrKeyboard:)]) {
            [_delegate messageToolBar:self didShowToolOrKeyboard:_moreToolVisble || _keyboardVisible];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification{
    if (!_shouldReceiveKeyboardNotification) {
        return;
    }
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    
    if(!_inputToolView.stateAction && !_inputToolView.stateEmoji && !_inputToolView.stateRecord){
        
        CGRect bounds = self.bounds;
        
        UIEdgeInsets contentInset = _chatTableView.contentInset;
        contentInset.bottom = bounds.size.height - HEIGHT_MORE_TOOL_OF_DEFAULT;
        
        CGPoint center = self.center;
        center.y = _chatTableView.superview.frame.size.height - contentInset.bottom + bounds.size.height / 2;
        
        CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        NSUInteger options = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            _chatTableView.contentInset = contentInset;
            self.bounds = bounds;
            self.center = center;
        } completion:^(BOOL finished){
            _keyboardVisible = NO;
            _moreToolVisble = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didShowToolOrKeyboard:)]) {
                [_delegate messageToolBar:self didShowToolOrKeyboard:_moreToolVisble || _keyboardVisible];
            }
        }];
    }
}

- (void)dismissKeyboard{
    if (self.keyboardVisible) {
        [_inputToolView dismissKeyboard];
    }
}

#pragma mark - MoreTool action
#pragma mark -
- (void)showMoreTool{
    
    CGRect bounds = self.bounds;
    if (_inputToolView.stateRecord) {
        bounds.size.height = HEIGHT_INPUT_OF_DEFAULT + HEIGHT_MORE_TOOL_OF_DEFAULT;
    }else{
        bounds.size.height = _inputToolView.contentSize.height + HEIGHT_MORE_TOOL_OF_DEFAULT;
    }
    
    UIEdgeInsets contentInset = _chatTableView.contentInset;
    contentInset.bottom = bounds.size.height;
    
    CGPoint center = self.center;
    center.y = _chatTableView.superview.frame.size.height - contentInset.bottom / 2;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _chatTableView.contentInset = contentInset;
        self.bounds = bounds;
        self.center = center;
    } completion:^(BOOL finished){
        _moreToolVisble = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didShowToolOrKeyboard:)]) {
            [_delegate messageToolBar:self didShowToolOrKeyboard:_moreToolVisble || _keyboardVisible];
        }
    }];
}

- (void)dismissMoreTool{
    if (!self.moreToolVisble) {
        return;
    }
    UIEdgeInsets contentInset = _chatTableView.contentInset;
    contentInset.bottom = self.bounds.size.height - HEIGHT_MORE_TOOL_OF_DEFAULT;
    
    CGPoint center = self.center;
    center.y = _chatTableView.superview.frame.size.height + HEIGHT_MORE_TOOL_OF_DEFAULT - self.bounds.size.height / 2;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _chatTableView.contentInset = contentInset;
        self.center = center;
    } completion:^(BOOL finished){
        _moreToolVisble = NO;
        
    }];
    
}

#pragma mark - EM_ChatTableViewTapDelegate
#pragma mark -
- (void)chatTableView:(EM_ChatTableView *)table didTapEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _inputToolView.stateAction = NO;
    _inputToolView.stateEmoji = NO;
    _inputToolView.stateMore = YES;
    [self dismissMoreTool];
    [self dismissKeyboard];
    if ([UIMenuController sharedMenuController].menuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

#pragma mark - EM_ChatInputToolDelegate
#pragma mark -
- (void)didRecordStateChanged:(BOOL)changed{
    if (_moreToolView) {
        if (changed) {
            [_inputToolView dismissKeyboard];
            [self showMoreTool];
            [_moreToolView showTool:_moreToolView.recordView animation:YES];
        }else{
            [_inputToolView showKeyboard];
            [_moreToolView dismissTool:NO];
        }
    }
}
- (void)didEmojiStateChanged:(BOOL)changed{
    if (_moreToolView) {
        if (changed) {
            [_inputToolView dismissKeyboard];
            [self showMoreTool];
            [_moreToolView showTool:_moreToolView.emojiView animation:YES];
        }else{
            [_inputToolView showKeyboard];
            [_moreToolView dismissTool:NO];
        }
    }
}
- (void)didActionStateChanged:(BOOL)changed{
    if (_moreToolView) {
        if (changed) {
            [_inputToolView dismissKeyboard];
            [self showMoreTool];
            [_moreToolView showTool:_moreToolView.actionView animation:YES];
        }else{
            [_inputToolView showKeyboard];
            [_moreToolView dismissTool:NO];
        }
    }
}

- (void)didMoreStateChanged:(BOOL)changed{
    if (changed) {
        [self dismissMoreTool];
    }else{
        [self showMoreTool];
    }
}

- (void)didMessageChanged:(NSString *)message oldContentSize:(CGSize)oldContentSize newContentSize:(CGSize)newContentSize{
    
    CGRect bounds = self.bounds;
    CGPoint center = self.center;
    UIEdgeInsets contentInset = _chatTableView.contentInset;
    
    if (message) {
        bounds.size.height = newContentSize.height +  + HEIGHT_MORE_TOOL_OF_DEFAULT;
    }else{
        bounds.size.height = HEIGHT_INPUT_OF_DEFAULT + HEIGHT_MORE_TOOL_OF_DEFAULT;
    }
    
    if (_keyboardVisible) {
        contentInset.bottom = _keyboardRect.size.height + (bounds.size.height - HEIGHT_MORE_TOOL_OF_DEFAULT);
    }else{
        if (_moreToolView.currentTool) {
            contentInset.bottom = bounds.size.height;
        }else{
            contentInset.bottom = HEIGHT_INPUT_OF_DEFAULT;
        }
    }
    
    center.y = _chatTableView.superview.frame.size.height - contentInset.bottom + bounds.size.height / 2;
    
    _chatTableView.contentInset = contentInset;
    self.bounds = bounds;
    self.center = center;
}

- (BOOL)shouldMessageSend:(NSString *)message{
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:shouldSendMessage:)]) {
        return [_delegate messageToolBar:self shouldSendMessage:message];
    }
    return YES;
}

- (void)didMessageSend:(NSString *)message{
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didSendMessagee:)]) {
        [_delegate messageToolBar:self didSendMessagee:message];
    }
}

#pragma mark - EM_ChatMoreToolDelegate
#pragma mark -

#pragma mark - Action
- (void)didActionClicked:(NSString *)actionName{
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didSelectedActionWithName:)]) {
        [_delegate messageToolBar:self didSelectedActionWithName:actionName];
    }
}

#pragma mark - Emoji
- (void)didEmojiClicked:(NSString *)emoji{
    [_inputToolView addMessage:emoji];
}
- (void)didEmojiDeleteClicked{
    [_inputToolView deleteMessage];
}
- (void)didEmojiSendClicked{
    [_inputToolView sendMessage];
}

#pragma mark - Record
- (BOOL)shouldRecord{
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:shouldRecord:)]) {
        return [_delegate messageToolBar:self shouldRecord:_moreToolView.recordView];
    }
    return YES;
}

- (void)didRecordStart{
    self.cover.frame = CGRectMake(0, 0, SCREEN_WIDTH, _chatTableView.superview.frame.size.height - self.bounds.size.height);
    [EM_Window addSubview:self.cover];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cover.alpha = 0.3;
    } completion:nil];
    _inputToolView.avtive = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didStartRecord:)]) {
        [_delegate messageToolBar:self didStartRecord:_moreToolView.recordView];
    }
}

- (void)didRecording:(NSInteger)duration{
    
}

- (void)didRecordEnd:(NSString *)recordName path:(NSString *)recordPath duration:(NSInteger)duration{
    [self.cover removeFromSuperview];
    _inputToolView.avtive = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didEndRecord:record:duration:)]) {
        [_delegate messageToolBar:self didEndRecord:recordName record:recordPath duration:duration];
    }
}

- (void)didRecordCancel{
    [self.cover removeFromSuperview];
    _inputToolView.avtive = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didCancelRecord:)]) {
        [_delegate messageToolBar:self didCancelRecord:_moreToolView.recordView];
    }
}

- (void)didRecordError:error{
    [self.cover removeFromSuperview];
    _inputToolView.avtive = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didRecordError:)]) {
        [_delegate messageToolBar:self didRecordError:error];
    }
}

- (void)didRecordPlay{
    
}
- (void)didRecordPlaying:(NSInteger)duration{
    
}
- (void)didRecordPlayStop{
    
}

@end
