//
//  HMAnnotationView.h
//  10-自定义大头针(最基本)
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface HMAnnotationView : MKAnnotationView
/**
 *  快速创建方法
 *
 *  @param mapView 地图
 *
 *  @return 大头针
 */
+ (instancetype)annotationViewWithMap:(MKMapView *)mapView;
@end
