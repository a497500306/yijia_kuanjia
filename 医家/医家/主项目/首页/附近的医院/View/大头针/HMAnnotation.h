//
//  HMAnnotation.h
//  10-自定义大头针(最基本)
//
//  Created by apple on 14/11/1.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HMAnnotation : NSObject<MKAnnotation>
 /**
 *  大头针的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  大头针标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  大头针的子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
@end
