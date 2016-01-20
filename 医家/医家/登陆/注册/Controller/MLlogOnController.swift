//
//  MLlogOnController.swift
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLlogOnController: UIViewController {
    @IBOutlet weak var shouji: UITextField!

    @IBOutlet weak var yanzhenma: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
    }

    @IBAction func huoquyanzhenma(sender: UIButton) {
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: self.shouji.text, zone: "86", customIdentifier: nil) { (error) -> Void in
            if (error == nil) {
               print("成功")
            }else{
              print("失败")
            }
        }
    }
    @IBAction func denglu(sender: AnyObject) {
        SMSSDK.commitVerificationCode(self.yanzhenma.text, phoneNumber: self.shouji.text, zone: "86") { (error) -> Void in
            if (error == nil) {
                print("验证成功")
            }else {
                print("验证失败")
            }
        }
    }
}
