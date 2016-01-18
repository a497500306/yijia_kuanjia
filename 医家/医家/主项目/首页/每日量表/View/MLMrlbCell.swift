//
//  MLMrlbCell.swift
//  医家
//
//  Created by 洛耳 on 16/1/15.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLMrlbCell: UITableViewCell {
    var textView : UILabel!
    var nameView : UIButton!
    var btn : UIButton!
    var modelFrame : MLMrlbCellFrame!{
        //属性发生改变后调用
        didSet {
            self.textView.frame = self.modelFrame.textFrame
            self.textView.text = self.modelFrame.cellModel.text as String
            
            self.nameView.frame = self.modelFrame.nameFrame
            if self.modelFrame.cellModel.name == "是"{
                self.nameView.setImage(UIImage(named: "正确"), forState: UIControlState.Normal)
                self.nameView.setTitle("    是", forState: UIControlState.Normal)
            }else if self.modelFrame.cellModel.name == "否"{
                self.nameView.setImage(UIImage(named: "错误"), forState: UIControlState.Normal)
                self.nameView.setTitle("    否", forState: UIControlState.Normal)
            }else{
                self.nameView.setImage(UIImage(), forState: UIControlState.Normal)
                self.nameView.setTitle(self.modelFrame.cellModel.name, forState: UIControlState.Normal)
            }
            self.btn.frame = self.modelFrame.btnFrame
        }
    }
    //重写cell.init方法,这里做初始化设置
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //内容
        self.textView = UILabel()
        self.textView.backgroundColor = UIColor.whiteColor()
        self.textView.font = Theme.中字体
        self.textView.numberOfLines = 0
        self.contentView.addSubview(self.textView)
        
        //选项
        self.nameView = UIButton()
        self.nameView.userInteractionEnabled = false
        self.nameView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.nameView.titleLabel?.font = Theme.大字体
        self.nameView.titleLabel?.numberOfLines = 0
        self.contentView.addSubview(self.nameView)
        
        //播放按钮
        self.btn = UIButton()
        self.btn.setImage(UIImage(named: "音乐播放器4"), forState: UIControlState.Normal)
        self.btn.addTarget(self, action: "点击喇叭", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.btn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func 点击喇叭(){
        //播放录音
        let utterance : AVSpeechUtterance = AVSpeechUtterance(string: self.modelFrame.cellModel.text as String)
        utterance.rate = 0.5
        //当前系统语音
        let preferredLand = "zh-CN"
        let synth : AVSpeechSynthesizer = AVSpeechSynthesizer()
        let voice : AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(language: preferredLand)!
        utterance.voice = voice
        synth.speakUtterance(utterance)
    }
}
