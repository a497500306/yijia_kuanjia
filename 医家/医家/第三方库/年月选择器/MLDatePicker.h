//
//  MLDatePicker.h
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLDatePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong, readonly) NSDate *date;
-(void)selectToday;
@end
