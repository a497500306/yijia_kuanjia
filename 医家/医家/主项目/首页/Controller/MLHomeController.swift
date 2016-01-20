//
//  MLHomeController.swift
//  医家
//
//  Created by 洛耳 on 15/12/7.
//  Copyright © 2015年 workorz. All rights reserved.
//
//  侧滑栏UITableView.tag = 1000

import UIKit

class MLHomeController: MLViewController , SDCycleScrollViewDelegate ,UITableViewDelegate , UITableViewDataSource {
    /// 侧滑栏图片数组
    var images : NSArray! = NSArray()
    /// 侧滑栏文字数组
    var texts : NSArray! = NSArray()
    var lunbo : SDCycleScrollView!
    var tableDatas : NSMutableArray! = NSMutableArray()
    var tableView = MLTableView()
    var chTableView = UITableView()
    //轮播图MODE
    var LBMode : NSArray! = NSArray()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController!.title = "首页"
    }
    
    override func viewWillAppear(animated: Bool) {
        //修改字体大小
        super.viewWillAppear(animated)
        if Theme.appD.isHomeXgzt == true {
            Theme.appD.isHomeXgzt = false
            self.tableView.removeFromSuperview()
            self.chTableView.removeFromSuperview()
            //dome初始化
            dome()
            //1.初始化控件
            chushihua()
            //2.取出数据库数据
            cloneData()
            //3.网络请求
            httpData()
            //创建侧滑栏
            创建侧滑栏()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //dome初始化
        dome()
        //1.初始化控件
        chushihua()
        //2.取出数据库数据
        cloneData()
        //3.网络请求
        httpData()
        //创建侧滑栏
        创建侧滑栏()
    }
    //MARK: - 网络请求
    func httpData(){
        //轮播图网络请求
        let params : NSMutableDictionary = ["":""]
        IWHttpTool.postWithURL(MLInterface.轮播图接口, params: params as [NSObject : AnyObject], success: { ( json) -> Void in
            print("\(json)")
            //删除数据库数据
            MLLBModel.truncateTable(nil)
            let model = MLWebModel(keyValues: json)
            //转ID
            MLLBModel.setupReplacedKeyFromPropertyName({ () -> [NSObject : AnyObject]! in
                return ["hostID":"id"]
            })
            let arrays : NSMutableArray = MLLBModel.objectArrayWithKeyValuesArray(model.data)
            self.LBMode = arrays
            //更新轮播数据
            let imgs : NSMutableArray = NSMutableArray()
            let texts : NSMutableArray = NSMutableArray()
            for var i = 0 ; i < arrays.count ; i++ {
                let mm : MLLBModel = arrays[i] as! MLLBModel
                imgs.addObject(mm.imgUrl)
                texts.addObject(mm.title)
            }
            self.lunbo.imageURLStringsGroup = imgs as [AnyObject]
            self.lunbo.titlesGroup = texts as [AnyObject]
            //添加数据到数据库
            MLLBModel.saveModels(arrays as [AnyObject], resBlock: nil)
            }) { ( erre ) -> Void in
        }
    }
    //MARK: - 取数据库
    func cloneData(){
        MLLBModel.selectWhere(nil, groupBy: nil, orderBy: "hostID", limit: nil) { (selectResults) -> Void in
            //主线程刷新UI
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if selectResults == nil {
                    return
                }
                self.LBMode = selectResults
                //更新轮播数据
                let imgs : NSMutableArray = NSMutableArray()
                let texts : NSMutableArray = NSMutableArray()
                for var i = 0 ; i < self.LBMode.count ; i++ {
                    let mm : MLLBModel = self.LBMode[i] as! MLLBModel
                    imgs.addObject(mm.imgUrl)
                    texts.addObject(mm.title)
                }
                self.lunbo.imageURLStringsGroup = imgs as [AnyObject]
                self.lunbo.titlesGroup = texts as [AnyObject]
            })
        }
    }
    //MARK: - dome
    func dome(){
        let model0 : MLHomeCellModel = MLHomeCellModel()
        model0.cellNameStr = "处理急性幻觉状态"
        model0.cellNeirongStr = "在重症病房接新病人的时候，遇到患者处于急性幻觉状态的不少吧，患者主要以听幻觉和视幻觉为主，经常还伴有妄想，患者幻觉的内容多为负性的"
        model0.cellDateStr = "2016/12/28"
        model0.cellPinglunsStr = "180评"
        model0.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model0.url = "http://mp.weixin.qq.com/s?__biz=MzA3MzkwNDkxNA==&mid=401802651&idx=1&sn=0035fdf1b765c1b159e7c1030b958eb0&scene=0#wechat_redirect"
        model0.cellImageViewStr = "http://img2.3lian.com/img2007/10/28/123.jpg"
        
        let model1 : MLHomeCellModel = MLHomeCellModel()
        model1.cellNameStr = "眼睛干涩？可能是新型抗抑郁剂惹的祸"
        model1.cellNeirongStr = "干眼症（DE）通常是由于泪液不足或过度蒸发导致眼球表面受到刺激所致，同时会伴有眼部不适症状。"
        model1.cellDateStr = "2016/12/28"
        model1.cellPinglunsStr = "180评"
        model1.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model1.url = "http://mp.weixin.qq.com/s?__biz=MzA3MzkwNDkxNA==&mid=401788282&idx=1&sn=74566c804ca03d8fc46278b163d31286&scene=0#wechat_redirect"
        model1.cellImageViewStr = "http://image.xinmin.cn/2012/07/04/20120704102330693834.jpg"
        
        
        let model2 : MLHomeCellModel = MLHomeCellModel()
        model2.cellNameStr = "控制不了情绪，何以控制人生？"
        model2.cellNeirongStr = "在这一期，我们将教授大家心理治疗技术（认知行为疗法）中的应对情绪的小技巧，以应对生活中的各种不顺心和消极情绪，实用指数高到爆表。"
        model2.cellDateStr = "2016/12/28"
        model2.cellPinglunsStr = "180评"
        model2.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model2.cellImageViewStr = "http://www.pptbz.com/pptpic/UploadFiles_6909/201206/2012062620093440.jpg"
        model2.url = "http://mp.weixin.qq.com/s?__biz=MzA3MzkwNDkxNA==&mid=401266254&idx=1&sn=38abe06df58a5519b09c54b549252b4b&scene=0#wechat_redirect"
        
        
        let model3 : MLHomeCellModel = MLHomeCellModel()
        model3.cellNameStr = "患者吞食异物该怎么办？"
        model3.cellNeirongStr = "吞食异物在精神病患者中并不罕见，可能是思维障碍导致，也有可能是冲动行为，还有可能是一种自杀行为。"
        model3.cellDateStr = "2016/12/28"
        model3.cellPinglunsStr = "180评"
        model3.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model3.cellImageViewStr = "http://www.wsxz.cn/uploadfile/2010/0510/20100510060847395.jpg"
        model3.url = "http://mp.weixin.qq.com/s?__biz=MzA3MzkwNDkxNA==&mid=400718276&idx=1&sn=6b2a218b5fb29645c9b844edf1d06d56&scene=0#wechat_redirect"
        
        
        let model4 : MLHomeCellModel = MLHomeCellModel()
        model4.cellNameStr = "抑郁症有8大日常症状"
        model4.cellNeirongStr = "社会发展起来了，人们的生活节奏也变快了。许多疾病接踵而至，例如抑郁症。抑郁症患者日常症状有哪些？如何治疗抑郁症？接下来一起看下。"
        model4.cellDateStr = "2016/12/28"
        model4.cellPinglunsStr = "180评"
        model4.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model4.cellImageViewStr = "http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg"
        model4.url = "http://mp.weixin.qq.com/s?__biz=MzA5MTQ0NTgzNQ==&mid=401889276&idx=4&sn=3e022de8b808b070f754f13beb759afb&scene=0#wechat_redirect"
        
        let model5 : MLHomeCellModel = MLHomeCellModel()
        model5.cellNameStr = "家人如何与躁狂症患者相处"
        model5.cellNeirongStr = "躁狂症患者最常见的状态是什么？经常表现出躁动或是十分不安，严重的话甚至会出手打人，这给护理人员造成困扰。家人要如何与躁狂症患者相处呢？"
        model5.cellDateStr = "2016/12/28"
        model5.cellPinglunsStr = "180评"
        model5.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model5.cellImageViewStr = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        model5.url = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        
        let model6 : MLHomeCellModel = MLHomeCellModel()
        model6.cellNameStr = "遇见一些人，然后再与他们告别洛杉矶的卡号科技阿斯顿很好看肯定是金发科技"
        model6.cellNeirongStr = "终于你开始明白，感情和梦想都是冷暖自知的东西，不再去跟别人解释自己。原来旅行的意义，是遇见一些人，再与他们告别。"
        model6.cellDateStr = "2016/12/28"
        model6.cellPinglunsStr = "180评"
        model6.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model6.cellImageViewStr = nil
        model6.url = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        
        let model7 : MLHomeCellModel = MLHomeCellModel()
        model7.cellNameStr = "再见，朋友圈"
        model7.cellNeirongStr = "有温度、有思想的声音陪你入梦。微信号【皇甫】"
        model7.cellDateStr = "2016/12/28"
        model7.cellPinglunsStr = "180评"
        model7.cellBSImageStr = "http://img3.imgtn.bdimg.com/it/u=2989171550,4148743584&fm=21"
        model7.cellImageViewStr = nil
        model7.url = "http://m.ximalaya.com/16960840/sound/9979959"
        
        let modelF0 : MLHomeCellFrame = MLHomeCellFrame()
        modelF0.cellModel = model0
        let modelF1 : MLHomeCellFrame = MLHomeCellFrame()
        modelF1.cellModel = model1
        let modelF2 : MLHomeCellFrame = MLHomeCellFrame()
        modelF2.cellModel = model2
        let modelF3 : MLHomeCellFrame = MLHomeCellFrame()
        modelF3.cellModel = model3
        let modelF4 : MLHomeCellFrame = MLHomeCellFrame()
        modelF4.cellModel = model4
        let modelF5 : MLHomeCellFrame = MLHomeCellFrame()
        modelF5.cellModel = model5
        let modelF6 : MLHomeCellFrame = MLHomeCellFrame()
        modelF6.cellModel = model6
        let modelF7 : MLHomeCellFrame = MLHomeCellFrame()
        modelF7.cellModel = model7
        self.tableDatas = [modelF0,modelF1,modelF2,modelF3,modelF4,modelF5,modelF6,modelF7,modelF0,modelF1,modelF2,modelF3,modelF4,modelF5,modelF6,modelF7]
    }
    //MARK: - 初始化
    func chushihua(){
        //设置左上角的放回按钮
        let righBtn = UIButton(frame: CGRectMake(0, 0, 24, 24))
        righBtn.setBackgroundImage(UIImage(named: "我的"), forState: UIControlState.Normal)
        righBtn.setBackgroundImage(UIImage(named: "我的" ), forState: UIControlState.Highlighted)
        righBtn.addTarget(self, action: "dianjiNavZuoshangjiao", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarItem = UIBarButtonItem(customView: righBtn)
        self.tabBarController!.navigationItem.leftBarButtonItem = rightBarItem
        //IOS8,如果想要追踪,要主动请求隐私权限
        let locManager = CLLocationManager()
        locManager.startUpdatingLocation()
        let mgr = CLLocationManager()
        if #available(iOS 8.0, *) {
            mgr.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        //创建Table
        let tableView = MLTableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, Theme.pingmuF.height - 64 - 48), style: UITableViewStyle.Plain)
        self.tableView = tableView
        //给Cell添加手势
        let shoushi = UIPanGestureRecognizer(target: self, action: "dragCenterView:")
        shoushi.delegate = self
        tableView.addGestureRecognizer(shoushi)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        //设置分割线包含整个宽度
        tableView.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            tableView.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(tableView)
        // 创建头部总控件View
        let zongView = UIView()
        zongView.backgroundColor = UIColor.whiteColor()
        // 网络加载 --- 创建带标题的图片轮播器
        let cycleScrollView : SDCycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 180), delegate: self, placeholderImage: UIImage(named: "placeholder"))
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        //配图文字
        //图片配文字数组
        let titles = [  "上海洛耳医药科技股份有限公司",
                        "上海洛耳医药科技股份有限公司",
                        "上海洛耳医药科技股份有限公司",
                        "上海洛耳医药科技股份有限公司",
                        "上海洛耳医药科技股份有限公司"]
        cycleScrollView.titlesGroup = titles;
        // 自定义分页控件小圆标颜色
        cycleScrollView.currentPageDotColor = UIColor.whiteColor()
        //         --- 轮播时间间隔，默认1.0秒，可自定义
        cycleScrollView.autoScrollTimeInterval = 3.0
        zongView.addSubview(cycleScrollView)
        self.lunbo = cycleScrollView
        
        //创建按钮
        let images = ["每日量表_nor","我的医生_nor","出院小结_nor","我的预约_nor","医院排班_nor","附近医院_nor","通知中心_nor","住院情况_nor"]
        let texts =  ["每日量表","我的医生","出院小结","我要预约","医生排班","附近医院","通知中心","住院情况"]
        let w : CGFloat  = Theme.pingmuF.width / 4
        let h : CGFloat = w
        for var i = 0 ; i < images.count; i++ {
            let ii : CGFloat = CGFloat(i)
            let btn = MLButton()
            let zheng : CGFloat = CGFloat(Int(ii/4))
            var y : CGFloat = CGFloat()
            y = cycleScrollView.frame.height + ( zheng * h )
            let x : CGFloat  = (ii % 4) * w
            btn.frame = CGRectMake(x, y, w, w)
            let image = images[i]
            btn.tag = i
            //关闭image高亮调整图片颜色
            btn.adjustsImageWhenHighlighted = false
            let imageH : UIImage = UIImage(color: UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1))
            btn.setBackgroundImage(imageH, forState: UIControlState.Highlighted)
            btn.setImage(UIImage(named: image) , forState: UIControlState.Normal)
            btn.titleLabel?.font = Theme.小字体
            btn.addTarget(self, action: "dianjianniu:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitle(texts[i], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            zongView.addSubview(btn)
        }
        zongView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, (zongView.subviews.last?.frame.origin.y)! + (zongView.subviews.last?.frame.height)! + 0.5)
        let xian : UIView = UIView()
        xian.frame = CGRectMake(0, zongView.frame.height - 0.5, UIScreen.mainScreen().bounds.width, 0.1)
        xian.backgroundColor = UIColor(red: 186/255.0, green: 186/255.0, blue: 192/255.0, alpha: 1)
        zongView.addSubview(xian)
        tableView.tableHeaderView = zongView
    }
    //MARK: - 点击左上角个人按钮
    func dianjiNavZuoshangjiao(){
        super.show()
    }
    //MARK: - 创建侧滑栏
    func 创建侧滑栏(){
        self.images = ["二维码","手势密码","我的收藏","设置"]
        self.texts = ["我的二维码","手势、指纹解锁","我的收藏","设置"]
        let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 2 / 3  , UIScreen.mainScreen().bounds.height))
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: "我的—背景图")
        let table = UITableView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 2 / 3  , UIScreen.mainScreen().bounds.height))
        self.chTableView = table
        table.backgroundColor = UIColor.clearColor()
        table.tag = 1000
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        //1添加头部控件
        let touView : UIView = UIView()
        //1.1头像
        let btn : MLButton = MLButton()
        let w : CGFloat = 75
        btn.frame = CGRectMake(((UIScreen.mainScreen().bounds.width * 2 / 3)-w)/2, w/2, w, w)
        btn.setImage(UIImage(named: "头像"), forState: UIControlState.Normal)
        touView.addSubview(btn)
        //1.2名字
        let nameText : UILabel = UILabel()
        let WH : CGSize = MLGongju().计算文字宽高("2131231", sizeMake: CGSizeMake(10000, 10000), font: Theme.中字体)
        nameText.frame = CGRectMake(0, btn.frame.height + btn.frame.origin.y+10, table.frame.width, WH.height)
        nameText.font = Theme.中字体
        nameText.textAlignment = NSTextAlignment.Center
        nameText.text = "1231231"
        touView.addSubview(nameText)
        //1.3线
        let xian : UIView = UIView()
        xian.frame = CGRectMake(25, nameText.frame.height + nameText.frame.origin.y + 10, table.frame.width - 50, 0.5)
        xian.backgroundColor = UIColor(red: 149/255.0, green: 149/255.0, blue: 149/255.0, alpha: 1)
        touView.addSubview(xian)
        touView.frame = CGRectMake(0, 0, table.frame.width, xian.frame.origin.y + xian.frame.height + 10)
        table.tableHeaderView = touView
        //设置代理数据源
        table.dataSource = self
        table.delegate = self
        super.sideslipView.contentView.addSubview(imageView)
        super.sideslipView.contentView.addSubview(table)
    }
    //MARK: - 点击中间按钮
    func dianjianniu (btn : UIButton) {
        if btn.tag == 0{//每日量表
            let mrilb = MLMrlbController()
            mrilb.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(mrilb, animated: true)
            mrilb.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 1{//我的医生
            let fjyy = MLWdysController()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 2{//出院小结
            let fjyy = MLCyxjController()
            fjyy.title = "出院小结"
            fjyy.view.backgroundColor = UIColor.whiteColor()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 3{//我的预约
            let fjyy = MLWyyyController()
            fjyy.title = "我要预约"
            fjyy.view.backgroundColor = UIColor.whiteColor()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 4{//医生排班
            let fjyy = MLYspbController()
            fjyy.title = "医生排班"
            fjyy.view.backgroundColor = UIColor.whiteColor()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 5{//点击附近医院
            let fjyy = MLFjyyBaiduDTController()
            fjyy.title = "附近医院"
            fjyy.view.backgroundColor = UIColor.whiteColor()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 6{//通知中心
            let fjyy = MLTzzxController()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        if btn.tag == 7{//住院情况
            let fjyy = MLZyqkController()
            fjyy.title = "住院情况"
            fjyy.view.backgroundColor = UIColor.whiteColor()
            fjyy.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fjyy, animated: true)
            fjyy.hidesBottomBarWhenPushed = false
        }
        print("点击了\(btn.tag)按钮")
    }
    //MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        if index == 0 {//点击第一张图片
            let LBMode : MLLBModel = self.LBMode[index] as! MLLBModel
            let webC = SVWebViewController(URL: NSURL(string: LBMode.hrefUrl as String))
            webC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webC, animated: true)
        }else if index == 1 {
            let LBMode : MLLBModel = self.LBMode[index] as! MLLBModel
            let webC = SVWebViewController(URL: NSURL(string: LBMode.hrefUrl as String))
            webC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webC, animated: true)
        }else if index == 2 {
            let LBMode : MLLBModel = self.LBMode[index] as! MLLBModel
            let webC = SVWebViewController(URL: NSURL(string: LBMode.hrefUrl as String))
            webC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webC, animated: true)
        }else if index == 3 {
            let LBMode : MLLBModel = self.LBMode[index] as! MLLBModel
            let webC = SVWebViewController(URL: NSURL(string: LBMode.hrefUrl as String))
            webC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webC, animated: true)
        }else if index == 4 {
            let LBMode : MLLBModel = self.LBMode[index] as! MLLBModel
            let webC = SVWebViewController(URL: NSURL(string: LBMode.hrefUrl as String))
            webC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webC, animated: true)
        }
    }
    //MARK: - tableView代理和数据源方法
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1000 {
            return self.images.count
        }else{
            return self.tableDatas.count
        }
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.tag == 1000 {
            super.down()
            //取出点击的那一行
            if indexPath.row == 0 {//点击我的二维码
            
            }else if indexPath.row == 1 {//手势解锁
                let fjyy = MLCoreConstController()
                fjyy.title = "手势、指纹解锁"
                fjyy.view.backgroundColor = UIColor.whiteColor()
                fjyy.hidesBottomBarWhenPushed = true
                //判断是否有密码
                //计算字符串长度
                let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
                if str == nil {//没有密码
                    self.navigationController?.pushViewController(fjyy, animated: true)
                }else{//有密码
                    self.navigationController?.pushViewController(fjyy, animated: true)
                }
            }else if indexPath.row == 2 {//我的收藏
            
            }else if indexPath.row == 3 {//设置
                let sz = MLSzController()
                sz.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sz, animated: true)
            }
        }else{
            let modelFrame : MLHomeCellFrame = self.tableDatas[indexPath.row] as! MLHomeCellFrame
            let webC = MLWebViewController(URL: NSURL(string: modelFrame.cellModel.url))
            webC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webC, animated: true)
        }
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.tag == 1000 {//侧滑栏
            let ID  = "cell"
            var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(ID)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ID)
            }
            cell.textLabel?.font = Theme.中字体
            cell.detailTextLabel?.font = Theme.中字体
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel?.text = self.texts[indexPath.row] as? String
            cell.imageView?.image = UIImage(named: (self.images[indexPath.row] as? String)!)
            return cell
        }else{//主TableView
            let ID  = "cell"
            var cell : MLHomeTableViewCell?  = tableView.dequeueReusableCellWithIdentifier(ID) as? MLHomeTableViewCell
            if cell == nil {
                cell = MLHomeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
            }
            let modelFrame : MLHomeCellFrame = self.tableDatas[indexPath.row] as! MLHomeCellFrame
            cell?.cellModelFarme = modelFrame
            return cell!
        }
    }
    //cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 1000{
            return 55
        }else{
            let modelFrame : MLHomeCellFrame = self.tableDatas[indexPath.row] as! MLHomeCellFrame
            return  modelFrame.cellH
        }
    }
    
    //设置分割线包含整个宽度
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
    }
}
