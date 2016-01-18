//
//  EM+Common.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#ifndef EaseMobUI_EM_Common_h
#define EaseMobUI_EM_Common_h

#define EM_Window [UIApplication sharedApplication].keyWindow

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define COMMON_PADDING (IS_PAD ? 8 : 5)
#define TOP_PADDING (2)
#define BUTTOM_PADDING (2)
#define LEFT_PADDING (IS_PAD ? 20 : 15)
#define RIGHT_PADDING (LEFT_PADDING)

#define HEIGHT_INDICATOR_OF_DEFAULT (IS_PAD ? 10 : 6)

#define HEIGHT_INPUT_OF_DEFAULT (50)
#define HEIGHT_INPUT_OF_MAX (IS_PAD ? 320 : 200)
#define HEIGHT_MORE_TOOL_OF_DEFAULT ((SCREEN_WIDTH - LEFT_PADDING - RIGHT_PADDING) / 2 + HEIGHT_INDICATOR_OF_DEFAULT * 2)
#define LINE_HEIGHT     (.5)
#define LINE_WIDTH      (.5)

#define LINE_COLOR (@"#CCCCCC")
#define TEXT_NORMAL_COLOR (0x686868)
#define TEXT_SELECT_COLOR (0x2d88ef)

#define STATUS_BAR_FRAME ([UIApplication sharedApplication].statusBarFrame)
#define NAVIGATION_BAR_FRAME (self.navigationController.navigationBar.frame)
#define ShareWindow ([[UIApplication sharedApplication] keyWindow])

#endif