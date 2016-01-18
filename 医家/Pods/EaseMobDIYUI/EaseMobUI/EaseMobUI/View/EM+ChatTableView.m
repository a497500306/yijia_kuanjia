//
//  EM+ChatTableView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatTableView.h"

@interface EM_ChatTableView()

@end

@implementation EM_ChatTableView

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(chatTableView:didTapEnded:withEvent:)]) {
        [_tapDelegate chatTableView:self didTapEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

@end