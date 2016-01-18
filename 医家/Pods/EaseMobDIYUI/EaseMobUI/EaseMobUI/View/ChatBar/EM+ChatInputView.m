//
//  EM+ChatInputView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EM+ChatInputView.h"
#import "UIColor+Hex.h"

@implementation EM_ChatInputView

@synthesize overrideNextResponder;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.scrollEnabled = YES;
        self.scrollsToTop = NO;
        self.dataDetectorTypes = UIDataDetectorTypeAll;
        self.enablesReturnKeyAutomatically = YES;
        self.userInteractionEnabled = YES;
        self.font = [UIFont systemFontOfSize:16.0f];
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
        self.returnKeyType = UIReturnKeySend;
        self.textAlignment = NSTextAlignmentLeft;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithHexRGB:0xe5e5e5].CGColor;
    }
    return self;
}

- (UIResponder *)nextResponder {
    if (overrideNextResponder != nil)
        return overrideNextResponder;
    else
        return [super nextResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (overrideNextResponder != nil){
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

@end