//
//  MLFjyyGDController.swift
//  医家
//
//  Created by 洛耳 on 15/12/22.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLFjyyGDController: UIViewController , MAMapViewDelegate{
    var mgr = CLLocationManager()
    //第一次打开时显示当前位置
    var panduan = Bool()
    //高德地图
    var mapView = MAMapView()
    override func viewDidLoad() {
        //初始化
        初始化()
    }
    func 初始化() {
        self.view.backgroundColor = UIColor.whiteColor()
        //IOS8,如果想要追踪,要主动请求隐私权限
        self.mgr = CLLocationManager()
        if #available(iOS 8.0, *) {
            self.mgr.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        let mapView = MAMapView(frame: CGRectMake(0, 0, self.view.frame.width,300))
        mapView.delegate = self
        self.mapView = mapView
        self.view.addSubview(mapView)
        //开启定位
        mapView.showsUserLocation = true
    }
    //MARK: - 当位置更新时，会进定位回调，通过回调函数
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            if self.panduan == false {
                //设置显示区域半径
                let span = MACoordinateSpanMake(0.25, 0.25)
                let region = MACoordinateRegionMake((userLocation.location?.coordinate)!, span)
                    self.mapView.setRegion(region, animated: true)
                self.panduan = true
                //查找医院
//                var search = 
            }
        }
    }
}
