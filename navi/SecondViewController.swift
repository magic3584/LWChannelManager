//
//  SecondViewController.swift
//  navi
//
//  Created by wang on 9/13/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let channelView = LWChannelView.init(frame: self.view.frame,
                                             selectedChannels: [ "不动", "生活", "头条", "科技", "娱乐", "人文", "健康", "美食", "国内", "语文", "数学", "理化生" ],
                                             unselectedChannels: ["11", "12", "13", "14", "15", "16", "17", "18", "19" ])
        self.view.addSubview(channelView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
