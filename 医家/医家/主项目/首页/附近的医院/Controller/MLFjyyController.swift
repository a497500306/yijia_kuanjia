//
//  MLFjyyController.swift
//  医家
//
//  Created by 洛耳 on 15/12/22.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit
import MapKit

class MLFjyyController: UIViewController , MKMapViewDelegate , UITableViewDelegate , UITableViewDataSource{
    //地图
    var mapView            = MKMapView()
    //地理编码对象
    var geocoder           = CLGeocoder()
    var mgr                = CLLocationManager()
    //第一次打开时显示当前位置
    var panduan            = Bool()
    //附近搜索
    var localSearchRequest = MKLocalSearchRequest()
    var span               = MKCoordinateSpan()
    //医院地理信息数组
    var yiyuans            = NSMutableArray()
    //精神医院地理信息数组
    var jinshens           = NSMutableArray()
    //tableve
    var tableView          = UITableView()
    var tableDatas         = NSMutableArray()
    var userLocation       = MKUserLocation()
    //btn
    var btn                = UIButton()
    //先
    var xian               = UIView()
    //保存选中cell
    var indexPath          = NSIndexPath()
    override func viewDidLoad() {
        //初始化
        初始化()
    }
    func 初始化(){
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "附近医院"
        //创建搜索栏
//        let searchBar = UISearchBar()
//        searchBar.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44)
//        self.view.addSubview(searchBar)
        let mapView      = MKMapView()
        self.mapView     = mapView
        mapView.frame    = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200)
        mapView.delegate = self
        self.view.addSubview(mapView)
        //IOS8,如果想要追踪,要主动请求隐私权限
        self.mgr         = CLLocationManager()
        if #available(iOS 8.0, *) {
           self.mgr.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        //定位到当前位置
        mapView.showsUserLocation = true
        //创建两个按钮
        let btn1                  = UIButton()
        btn1.frame                = CGRectMake(0, self.mapView.frame.height , self.view.frame.width / 2, 44)
        btn1.setTitle("医院", forState: UIControlState.Normal)
        btn1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn1.addTarget(self, action: "dianjibtn1:", forControlEvents: UIControlEvents.TouchUpInside)
        btn1.setTitleColor(UIColor(red: 0, green: 64/255.0, blue: 156/255.0, alpha: 1), forState: UIControlState.Selected)
        btn1.selected             = true
        self.btn                  = btn1
        self.view.addSubview(btn1)

        let btn2                  = UIButton()
        btn2.frame                = CGRectMake(self.view.frame.width / 2, self.mapView.frame.height , self.view.frame.width / 2, 44)
        btn2.setTitle("精神科医院", forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor(red: 0, green: 64/255.0, blue: 156/255.0, alpha: 1), forState: UIControlState.Selected)
        btn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn2.addTarget(self, action: "dianjibtn2:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn2)
        //创建按钮下面的线
        let xian                  = UIView()
        xian.frame                = CGRectMake(0, btn1.frame.origin.y + btn1.frame.height, self.view.frame.width/2, 2)
        xian.backgroundColor      = UIColor(red: 0, green: 64/255.0, blue: 156/255.0, alpha: 1)
        self.xian                 = xian
        self.view.addSubview(xian)
        //创建UITableView
        let tableView             = UITableView()
        tableView.frame           = CGRectMake(0, xian.frame.height + xian.frame.origin.y,self.view.frame.width , self.view.frame.height - btn1.frame.height - self.mapView.frame.height - 64 - 44)
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.rowHeight       = 60
        tableView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        self.tableView            = tableView
        self.view.addSubview(tableView)
    }
    //MARK: - 点击医院按钮
    func dianjibtn1(btn : UIButton){
        self.tableDatas = self.yiyuans
        self.tableView.reloadData()
        //移除大头针
        self.mapView.removeAnnotations(self.mapView.annotations)
        //设置显示区域半径
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake((self.userLocation.location?.coordinate)!, span)
        self.mapView.setRegion(region, animated: true)
        //添加大头针
        for var i = 0 ;i < self.tableDatas.count; i++ {
            let mapItem:MKMapItem = self.tableDatas[i] as! MKMapItem
            //搜索完成,显示大头针
            let anno = HMAnnotation()
            anno.title = mapItem.name
            anno.coordinate = mapItem.placemark.coordinate
            // 添加大头针
            self.mapView.addAnnotation(anno)
        }
        //动画
        UIView.animateWithDuration(0.3) { () -> Void in
            self.btn.selected = false
            self.btn = btn
            self.btn.selected = true
            self.xian.frame = CGRectMake(0, self.btn.frame.origin.y + self.btn.frame.height, self.view.frame.width/2,2)
        }
    }
    //MARK: - 点击精神科医院按钮
    func dianjibtn2(btn : UIButton){
        self.tableDatas = self.jinshens
        self.tableView.reloadData()
        //移除大头针
        self.mapView.removeAnnotations(self.mapView.annotations)
        //设置显示区域半径
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region = MKCoordinateRegionMake((self.userLocation.location?.coordinate)!, span)
        self.mapView.setRegion(region, animated: true)
        //添加大头针
        for var i = 0 ;i < self.tableDatas.count; i++ {
            let mapItem:MKMapItem = self.tableDatas[i] as! MKMapItem
            //搜索完成,显示大头针
            let anno = HMAnnotation()
            anno.title = mapItem.name
            anno.coordinate = mapItem.placemark.coordinate
            // 添加大头针
            self.mapView.addAnnotation(anno)
        }
        //动画
        UIView.animateWithDuration(0.3) { () -> Void in
            self.btn.selected = false
            self.btn = btn
            self.btn.selected = true
            self.xian.frame = CGRectMake(self.view.frame.width/2, self.btn.frame.origin.y + self.btn.frame.height, self.view.frame.width/2, 2)
        }
    }
    //MARK: - tablView代理和数据源方法
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDatas.count
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let ID = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
        }
        //显示箭头
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let mapItem : MKMapItem = self.tableDatas[indexPath.row] as! MKMapItem
        cell!.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        cell!.textLabel?.text = mapItem.name
        cell!.detailTextLabel?.text = mapItem.phoneNumber
        cell!.detailTextLabel?.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1)
        print("tableview\(mapItem.name)")
        return cell!
    }
    //xrMARK: - 监听大头针点击
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        if self.indexPath == 0 {
//            self.tableView.cellForRowAtIndexPath(self.indexPath)?.selected = false
//        }
        for var i = 0 ; i < self.tableDatas.count ; i++ {
            let str = view.annotation! as! HMAnnotation
            let mapItem : MKMapItem = self.tableDatas[i] as! MKMapItem
            if str.title == mapItem.name {
                let indexPath : NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
//                self.tableView.cellForRowAtIndexPath(indexPath)?.selected = true
//                self.indexPath = indexPath
            }
        }
    }
    //MARK: - 每次更新到用户的位置就会调用,调用不频繁,只有位置改变才对调用
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        //利用反地理编码获取用户信息
        self.userLocation = userLocation
        self.geocoder = CLGeocoder()
        self.geocoder.reverseGeocodeLocation(userLocation.location!) { (let placemarks , let error) -> Void in
            if placemarks?.count != 0 {
                let placemark = placemarks![0]
                //显示当前位置
                userLocation.subtitle = placemark.subLocality! + placemark.thoroughfare! + placemark.subThoroughfare!
            }
        }
        //设置大头针,大头针显示什么内容,由大头针模型确定(userLocation)
        userLocation.title = "当前位置"
        //ios7自动跳转到地区,获取当前用户所在位置的经纬度userLocation.location?.coordinate)!
        //延时执行
        // 创建目标队列
        let workingQueue = dispatch_queue_create("my_queue", nil)
        // 派发到刚创建的队列中，GCD 会负责进行线程调度
        dispatch_async(workingQueue) {
            NSThread.sleepForTimeInterval(2)// 模拟两秒的执行时间
            if self.panduan == false {//这里只运行一次
                //并且获取用户的中心点
                self.mapView.setCenterCoordinate((userLocation.location?.coordinate)!, animated: false)
                //设置显示区域半径
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegionMake((userLocation.location?.coordinate)!, span)
                self.mapView.setRegion(region, animated: true)
                self.panduan = true
            
                //搜索区域内的医院
                self.localSearchRequest = MKLocalSearchRequest()
                self.localSearchRequest.region = region;
                //搜索医院
                self.localSearchRequest.naturalLanguageQuery = "医院"
                let localSearch = MKLocalSearch(request: self.localSearchRequest)
                localSearch.startWithCompletionHandler({ (let response, let error) -> Void in
                    let itemArray = response!.mapItems
                    if (error != nil) {
                        
                    }else{
                        for var mapItem in itemArray {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = mapItem.placemark.location!.coordinate;
                            annotation.title = mapItem.name
                            self.yiyuans.addObject(mapItem)
                            print("医院\(mapItem.placemark) + \(mapItem.phoneNumber)")
                            //搜索完成,显示大头针
                            let anno = HMAnnotation()
                            anno.title = mapItem.name
                            anno.coordinate = mapItem.placemark.coordinate
                            // 添加大头针
                            self.mapView.addAnnotation(anno)
                        }
                        self.tableDatas = self.yiyuans
                        self.tableView.reloadData()
                    }
                })
                //搜索精神医院
                self.localSearchRequest.naturalLanguageQuery = "精神医院"
                let localSearch2 = MKLocalSearch(request: self.localSearchRequest)
                localSearch2.startWithCompletionHandler({ (let response, let error) -> Void in
                    let itemArray = response!.mapItems
                    if (error != nil) {
                        
                    }else{
                        for var mapItem in itemArray {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = mapItem.placemark.location!.coordinate;
                            annotation.title = mapItem.name
                            self.jinshens.addObject(mapItem)
                            print("精神病医院\(mapItem.name)")
                        }
                    }
                })
            }
        }
    }
}
