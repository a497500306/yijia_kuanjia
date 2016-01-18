//
//  EM_ChatEmoji.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <CoreData/CoreData.h>

#define FIELD_NAME_EMOJI            @"emoji"
#define FIELD_NAME_CALCULATE        @"calculate"
#define FIELD_NAME_MODIFY           @"modify"


@interface EM_ChatEmoji : NSManagedObject

@property (nonatomic, retain) NSString * emoji;
@property (nonatomic, retain) NSDecimalNumber * calculate;
@property (nonatomic, retain) NSDate * modify;

@end