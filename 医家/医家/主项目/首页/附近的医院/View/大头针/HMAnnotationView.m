//
//  HMAnnotationView.m
//  10-自定义大头针(最基本)
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMAnnotationView.h"
#import "HMAnnotation.h"

@implementation HMAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        // 初始化
        // 设置大头针标题是否显示
        self.canShowCallout = YES;
        
        // 设置大头针左边的辅助视图
        self.leftCalloutAccessoryView = [[UISwitch alloc] init];
        
        // 设置大头针右边的辅助视图
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return self;
}

+ (instancetype)annotationViewWithMap:(MKMapView *)mapView
{
    static NSString *identifier = @"anno";
    
    // 1.从缓存池中取
    HMAnnotationView *annoView = (HMAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    // 2.如果缓存池中没有, 创建一个新的
    if (annoView == nil) {
        
        annoView = [[HMAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
    }

    return annoView;
}

//- (void)setAnnotation:(id<MKAnnotation>)annotation
- (void)setAnnotation:(HMAnnotation *)annotation
{
    [super setAnnotation:annotation];
    
//     处理自己特有的操作
    self.image = [UIImage imageNamed:annotation.icon];
    
}
@end
