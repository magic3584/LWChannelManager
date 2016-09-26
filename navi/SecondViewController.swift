//
//  SecondViewController.swift
//  navi
//
//  Created by wang on 9/13/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    public var selectedChannels: [String]!
    public var unselectedChannels: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let channelView = LWChannelView.init(frame: self.view.frame,
                                             selectedChannels: self.selectedChannels,
                                             unselectedChannels: self.unselectedChannels)
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
