//  MLFjyyBaiduDTController.swift
//  医家
//
//  Created by 洛耳 on 15/12/24.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLFjyyBaiduDTController: UIViewController , BMKMapViewDelegate ,BMKPoiSearchDelegate ,BMKLocationServiceDelegate , UITableViewDelegate , UITableViewDataSource , HZActionSheetDelegate {
    var mgr = CLLocationManager()
    //第一次打开时显示当前位置
    var panduan = Bool()
    //百度地图
    var mapView = BMKMapView()
    //百度地图
    var locService = BMKLocationService()
    //检索对象
    var poiseatch = BMKPoiSearch()
    //用户所在位置
    var userLocation = BMKUserLocation()
    //tableve
    var tableView = UITableView()
    var tableDatas = NSMutableArray()
    //记录选择按钮
    var indexPath : NSIndexPath = NSIndexPath(forRow: 1000, inSection: 1000)
    //btn
    var btn = UIButton()
    //先
    var xian = UIView()
    //判断CELL时候选中
    var xuanzhongs = NSMutableArray()
    //储存点击的cell的model模型
    var model = MLDTCellModel()
    override func viewDidLoad() {
        //初始化
        初始化()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    func 初始化() {
        self.title = "附近医院"
        self.view.backgroundColor = UIColor.whiteColor()
        //IOS8,如果想要追踪,要主动请求隐私权限
        self.mgr = CLLocationManager()
        if #available(iOS 8.0, *) {
            self.mgr.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        let mapView = BMKMapView(frame: CGRectMake(0, 0, self.view.frame.width,200))
        mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView = mapView;
        //初始化BMKLocationService
        //启动LocationService
        self.locService = BMKLocationService()
        self.locService.delegate = self
        self.locService.startUserLocationService()
        //显示定位图层
        mapView.showsUserLocation = true
        //设置定位的状态
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        //创建两个按钮
        let btn1 = UIButton()
        btn1.frame = CGRectMake(0, self.mapView.frame.height , self.view.frame.width / 2, 44)
        btn1.setTitle("医院", forState: UIControlState.Normal)
        btn1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn1.addTarget(self, action: "dianjibtn1:", forControlEvents: UIControlEvents.TouchUpInside)
        btn1.setTitleColor(UIColor(red: 0, green: 64/255.0, blue: 156/255.0, alpha: 1), forState: UIControlState.Selected)
        btn1.selected = true
        self.btn = btn1
        self.view.addSubview(btn1)
        
        let btn2 = UIButton()
        btn2.frame = CGRectMake(self.view.frame.width / 2, self.mapView.frame.height , self.view.frame.width / 2, 44)
        btn2.setTitle("精神科医院", forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor(red: 0, green: 64/255.0, blue: 156/255.0, alpha: 1), forState: UIControlState.Selected)
        btn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn2.addTarget(self, action: "dianjibtn2:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn2)
        //创建按钮下面的线
        let xian = UIView()
        xian.frame = CGRectMake(0, btn1.frame.origin.y + btn1.frame.height, self.view.frame.width/2, 2)
        xian.backgroundColor = UIColor(red: 0, green: 64/255.0, blue: 156/255.0, alpha: 1)
        self.xian = xian
        self.view.addSubview(xian)
        //创建UITableView
        let tableView = UITableView()
        tableView.frame = CGRectMake(0, xian.frame.height + xian.frame.origin.y,self.view.frame.width , self.view.frame.height - btn1.frame.height - self.mapView.frame.height - 64)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        self.tableView = tableView
        self.view.addSubview(tableView)

    }
    //MARK: - 百度地图代理方法,当位置更新时,会进定位回调
    //判断是否定位成功
    func didFailToLocateUserWithError(error: NSError!) {
        print("定位失败\(error)")
    }
    /**
    *用户位置更新后，会调用此函数
    *@param userLocation 新的用户位置
    */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        self.mapView.updateLocationData(userLocation)
        self.userLocation = userLocation
        if self.panduan == false {//这里只运行一次
            //设置显示区域半径
            let span = BMKCoordinateSpanMake(0.1, 0.1)
            let region = BMKCoordinateRegionMake(userLocation.location.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            self.panduan = true
            //搜索附近的医院
            //用户中心点
            let option = BMKNearbySearchOption()
            option.location = userLocation.location.coordinate
            option.radius = 20000
            option.pageIndex = 0
            option.pageCapacity = 20
            option.keyword = "医院"
            self.poiseatch = BMKPoiSearch()
            self.poiseatch.delegate = self
            let flag : Bool = self.poiseatch.poiSearchNearBy(option)
            if flag == true {
                print("成功")
            }else{
                print("失败")
            }
        }
    }
    //MARK: - 点击大头针
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        for var i = 0 ; i < self.tableDatas.count ; i++ {
            let model : MLDTCellModel = self.tableDatas[i] as! MLDTCellModel
            if view.annotation.title!() == model.name {
                //设置选中状态
                model.isXuanzhong = true
                let indexPath : NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                //刷新一行
                if self.indexPath.row != 1000  {
                    let model1 : MLDTCellModel = self.tableDatas[self.indexPath.row] as! MLDTCellModel
                    model1.isXuanzhong = false
                    self.tableView.reloadRowsAtIndexPaths([indexPath,self.indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }else{
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                self.indexPath = indexPath
            }
        }
    }
    //BMKSearchDelegate
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        //清空mapView所有大头针
        mapView.removeAnnotations(mapView.annotations)
        self.tableDatas.removeAllObjects()
        if errorCode == BMK_SEARCH_NO_ERROR {
            for var i = 0 ; i < poiResult.poiInfoList.count ; i++ {
                let poi : BMKPoiInfo = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                self.mapView.addAnnotation(item)
                //添加model
                let model = MLDTCellModel()
                model.poiInfo = poi
                model.name = poi.name
                model.phone = poi.phone
                model.isXuanzhong = false
                self.tableDatas.addObject(model)
            }
        }
        self.tableView.reloadData()
    }
    /**
    *在地图View将要启动定位时，会调用此函数
    *@param mapView 地图View
    */
    func willStartLocatingUser() {
        print("开始定位")
    }
    /**
    *在地图View停止定位后，会调用此函数
    *@param mapView 地图View
    */
    func didStopLocatingUser() {
        print("定位失败")
    }
    override func viewWillAppear(animated: Bool) {
        //关闭手势退出
        self.fd_interactivePopDisabled = true
        self.mapView.viewWillAppear()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        //打开手势退出
        self.mapView.viewWillDisappear()
        self.mapView.delegate = nil
        self.locService.delegate = nil
        self.poiseatch.delegate  = nil
    }
    //MARK: - tablView代理和数据源方法
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDatas.count
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //取出模型
        self.model = self.tableDatas[indexPath.row] as! MLDTCellModel
        let action =  HZActionSheet(title: "您可以选择:", delegate: self, cancelButtonTitle: "取消", destructiveButtonIndexSet: nil, otherButtonTitles: ["百度地图导航","苹果自带导航","拨打电话"])
        action.showInView(self.view)

    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let ID  = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID)
        if cell == nil {
           cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
        }
        cell!.textLabel?.font = Theme.中字体
        cell!.detailTextLabel?.font = Theme.中字体
        //显示箭头
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.detailTextLabel?.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1)
        cell!.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        let model : MLDTCellModel = self.tableDatas[indexPath.row] as! MLDTCellModel
        if model.isXuanzhong == true {
            cell?.backgroundColor = UIColor(red: 208/255.0, green: 208/255.0, blue: 208/255.0, alpha: 1)
        }else{
            cell!.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        }
        cell!.textLabel?.text = model.name! as String
        if model.phone != nil {
            cell!.detailTextLabel?.text = model.phone! as String
        }
        return cell!
    }
    //MARK: - HZActionSheet代理方法
    func actionSheet(actionSheet: HZActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        //创建起点和终点
        let startPlacemark = MKPlacemark(coordinate: self.userLocation.location.coordinate, addressDictionary: nil)
        let startItem = MKMapItem(placemark: startPlacemark)
        
        let poiInfo :BMKPoiInfo = self.model.poiInfo
        let endPlacemark = MKPlacemark(coordinate: poiInfo.pt, addressDictionary: nil)
        let endItem = MKMapItem(placemark: endPlacemark)
        
        if buttonIndex == 0 {//点击百度导航
//            //发起路径规划
//            BNCoreServices.RoutePlanService().startNaviRoutePlan(BNRoutePlanMode_Recommend, naviNodes:nodesArray as [AnyObject], time: nil, delegete: self, userInfo: nil)
            let urlSet = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:" + String(poiInfo.pt.latitude) + "," + String(poiInfo.pt.longitude) + "|name=目的地&mode=driving&coord_type=gcj02"
            let url :NSURL = MLUserInfo.UTF8(urlSet)
            UIApplication.sharedApplication().openURL(url)
            
        }else if buttonIndex == 1{//点击苹果自带导航
            // 2.设置启动附加参数
            let md : NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
            // 导航模式(驾车/走路
            MKMapItem.openMapsWithItems([startItem, endItem], launchOptions:md as? [String : AnyObject])
        }else if buttonIndex == 2{//点击拨打电话
            if self.model.phone != nil {
                let callWebView = UIWebView()
                let str  = NSString(string: "tel:")
                let phone = NSString(string: self.model.phone)
                let sss = (str as String) + (phone as String)
                let url = NSURL(string: sss)
                callWebView.loadRequest(NSURLRequest(URL: url!))
                self.view.addSubview(callWebView)
            }else{
                MBProgressHUD.showError("没有该医院号码", toView: self.view)
            }
        }
    }
    //MARK: - 点击医院按钮
    func dianjibtn1(btn : UIButton){
        //设置显示区域半径
        let span = BMKCoordinateSpanMake(0.1, 0.1)
        let region = BMKCoordinateRegionMake(self.userLocation.location.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        self.panduan = true
        //搜索附近的医院
        //用户中心点
        let option = BMKNearbySearchOption()
        option.location = self.userLocation.location.coordinate
        option.radius = 20000
        option.pageIndex = 0
        option.pageCapacity = 20
        option.sortType = BMK_POI_SORT_BY_DISTANCE
        option.keyword = "医院"
        self.poiseatch = BMKPoiSearch()
        self.poiseatch.delegate = self
        let flag : Bool = self.poiseatch.poiSearchNearBy(option)
        if flag == true {
            print("成功")
        }else{
            print("失败")
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
    func dianjibtn2(btn : UIButton){//设置显示区域半径
        let span = BMKCoordinateSpanMake(0.1, 0.1)
        let region = BMKCoordinateRegionMake(self.userLocation.location.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        self.panduan = true
        //搜索附近的医院
        //用户中心点
        let option = BMKNearbySearchOption()
        option.location = self.userLocation.location.coordinate
        option.radius = 20000
        option.pageIndex = 0
        option.pageCapacity = 20
        option.keyword = "精神医院"
        self.poiseatch = BMKPoiSearch()
        self.poiseatch.delegate = self
        let flag : Bool = self.poiseatch.poiSearchNearBy(option)
        if flag == true {
            print("成功")
        }else{
            print("失败")
        }
        //动画
        UIView.animateWithDuration(0.3) { () -> Void in
            self.btn.selected = false
            self.btn = btn
            self.btn.selected = true
            self.xian.frame = CGRectMake(self.view.frame.width/2, self.btn.frame.origin.y + self.btn.frame.height, self.view.frame.width/2, 2)
        }
    }

}
