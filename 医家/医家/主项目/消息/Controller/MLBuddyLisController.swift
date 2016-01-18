//
//  MLBuddyLisController.swift
//  医家
//
//  Created by 洛耳 on 16/1/18.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLBuddyLisController: EM_BuddyListController , EM_ChatBuddyListControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        // Do any additional setup after loading the view.
    }

    //好友，群或者讨论组被点击
    func didSelectedWithOpposite(opposite: EM_ChatOpposite!) {
        
//        UChatController *chatController = [[UChatController alloc]initWithOpposite:opposite];
        let mrilb : MLChatViewController = MLChatViewController(opposite: opposite)
//        mrilb.opposite = opposite
        self.navigationController?.pushViewController(mrilb, animated: true)
    }

}
