//
//  ViewController.swift
//  navi
//
//  Created by wang on 9/12/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = LWScrollNaviView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 40),
                                               titles: [ "不动", "生活", "头条", "科技", "娱乐", "人文", "健康", "美食", "国内", "语文", "数学", "理化生" ],
                                               showAddButton: true )
        scrollView.selectIndex(1)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}





















