//
//  ViewController.swift
//  navi
//
//  Created by wang on 9/12/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedChannels: [String] = [ "不动", "生活", "头条", "科技", "娱乐", "人文", "健康", "美食", "国内", "语文", "数学", "理化生" ]
    var unselectedChannels: [String] = ["11", "12", "13", "14", "15", "16", "17", "18", "19" ]
    var navi: LWScrollNaviView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navi = {
            let navi = LWScrollNaviView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 40),
                                                   selectedChannels: self.selectedChannels,
                                                   unselectedChannels: self.unselectedChannels,
                                                   showAddButton: true )
            navi.selectIndex(1)
            navi.delegate = self
            self.view.addSubview(navi)
            
            return navi
        }()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: LWScrollNaviViewDelegate {
    func didTapNaviButton(_ naviView: LWScrollNaviView) {
        print(naviView.lastSelectedIndex)
    }
    func didTapAddButton(_ naviView: LWScrollNaviView) {
        let vc = SecondViewController()
        vc.selectedChannels = self.navi.selectedChannels
        vc.unselectedChannels = self.navi.unselectedChannels
        self.navigationController?.pushViewController(vc, animated: true)
    }
}





















