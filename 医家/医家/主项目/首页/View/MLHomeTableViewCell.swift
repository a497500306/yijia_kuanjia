//
//  MLHomeTableViewCell.swift
//  医家
//
//  Created by 洛耳 on 15/12/29.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLHomeTableViewCell: UITableViewCell {
    /// 图片
    var cellImageView : UIImageView!
    /// 标题文字
    var cellName : UILabel!
    /// 内容文字
    var cellNeirong : UILabel!
    /// 时间
    var cellDate : UILabel!
    /// 评论数
    var cellPingluns : UILabel!
    /// 标示图片,标示广告,调频,视频,文章,等
    var cellBSImage : UIImageView!
    /// cellFarme模型
    var cellModelFarme : MLHomeCellFrame! = MLHomeCellFrame() {
        //属性发生改变后调用
        didSet {
            //0.取出cellModel
            let model : MLHomeCellModel = self.cellModelFarme.cellModel
            //1.设置图片frame
            if model.cellImageViewStr != nil {
                self.cellImageView.frame = self.cellModelFarme.cellImageViewFrame
                self.cellImageView.sd_setImageWithURL(NSURL(string: model.cellImageViewStr) , placeholderImage:UIImage(named: "accident_h"))
            }else{
                self.cellImageView.frame = self.cellModelFarme.cellImageViewFrame
            }
            //2.设置标题frame
            self.cellName.frame = self.cellModelFarme.cellNameFrame
            self.cellName.text = model.cellNameStr as String
            //3.设置内容frame
            self.cellNeirong.frame = self.cellModelFarme.cellNeirongFrame
            self.cellNeirong.text = model.cellNeirongStr as String
            //4.设置时间frame
            self.cellDate.frame = self.cellModelFarme.cellDateFamer
            self.cellDate.text = model.cellDateStr as String
            //5.设置评论数frame
            self.cellPingluns.frame = self.cellModelFarme.cellPinglunsFrame
            self.cellPingluns.text = model.cellPinglunsStr as String
            //6.设置标识frame
            self.cellBSImage.frame = self.cellModelFarme.cellBSImageFrame
            self.cellBSImage.sd_setImageWithURL(NSURL(string: model.cellBSImageStr), placeholderImage: UIImage(named: "专题"))
        }
    }
    
    //重写cell.init方法,这里做初始化设置
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //1.创建图片
        self.cellImageView = UIImageView()
        //1.1设置图片居中排列
        self.cellImageView.clipsToBounds = true
        self.cellImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.cellImageView)
        
        
        //2.创建标题文字
        self.cellName = UILabel()
        //        cellName.font = UIFont.systemFontOfSize(CGFloat(大字体))
        //2.2字体加粗并设置大小
        self.cellName.font = Theme.大字体
        self.cellName.textColor = UIColor.blackColor()
        self.contentView.addSubview(self.cellName)
        
        
        //3.创建内容文字
        self.cellNeirong = UILabel()
        self.cellNeirong.font = Theme.中字体
        self.cellNeirong.numberOfLines = 2
        self.cellNeirong.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        self.contentView.addSubview(self.cellNeirong)
        
        
        //4.创建时间
        self.cellDate = UILabel()
        self.cellDate.font = Theme.中字体
        self.cellDate.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        self.contentView.addSubview(self.cellDate)
        
        
        //5.创建评论数
        self.cellPingluns = UILabel()
        self.cellPingluns.font = Theme.中字体
        self.cellPingluns.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        self.contentView.addSubview(self.cellPingluns)
        
        //6.创建标识图片
        self.cellBSImage = UIImageView()
        self.contentView.addSubview(self.cellBSImage)

        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
