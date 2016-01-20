//
//  MLWebViewController.swift
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLWebViewController: SVWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar :SSCCommentToolbar = Comment.commentToolbarWithContentId("1", title: "标题", frame: CGRectMake(0 , Theme.pingmuF.height - 50, Theme.pingmuF.width, 44))
        Theme.win.addSubview(toolbar)
    }

}
