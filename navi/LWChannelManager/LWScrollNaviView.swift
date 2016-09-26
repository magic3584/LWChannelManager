//
//  LWScrollNaviView.swift
//  navi
//
//  Created by wang on 9/12/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

public protocol LWScrollNaviViewDelegate: class {
    //点击navi
    func didTapNaviButton(_ naviView: LWScrollNaviView)
    //点击添加
    func didTapAddButton(_ naviView: LWScrollNaviView)
}

open class LWScrollNaviView: UIView {

    fileprivate var scrollView: UIScrollView!
    fileprivate var indicatorView: UIView!
    fileprivate var addButton: UIButton?
    
    open weak var delegate: LWScrollNaviViewDelegate?
    
    open var selectedChannels: [String]!
    open var unselectedChannels: [String] = []
    fileprivate var labelArray: [UILabel] = []
    fileprivate var showAddButton: Bool?
    //缓存每个label的宽度
    fileprivate var labelWidthArray: [CGFloat] = []
    
    ///按钮的间隔
    fileprivate let padding:CGFloat = 10.0
    
    fileprivate let normalColor = UIColor.black
    fileprivate let selectedColor = UIColor.red
    
    open var lastSelectedIndex = 0
    
    public init(frame: CGRect, selectedChannels: [String], unselectedChannels: [String],showAddButton: Bool) {
        super.init(frame: frame)
        self.selectedChannels = selectedChannels
        self.unselectedChannels = unselectedChannels
        self.showAddButton = showAddButton
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedChannel(_:)), name: NSNotification.Name(rawValue: "LWChangeChannelNotification"), object: nil)
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - private func
    
    fileprivate func configUI() {
        self.scrollView = {
            self.isUserInteractionEnabled = true
            
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            if (self.showAddButton == true) {
                //位置最右，宽高相等
                self.addButton = UIButton.init(frame: CGRect(x: width - height, y: 0, width: height, height: height))
                self.addButton?.setTitle("添加", for: UIControlState())
                self.addButton?.backgroundColor = UIColor.red
                self.addButton?.addTarget(self, action: #selector(self.tapAddButton(_:)), for: .touchUpInside)
                self.addSubview(self.addButton!)
            }
            
            let buttonWidth = self.addButton?.frame.size.width ?? 0.0
            
            let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: width - buttonWidth, height: self.frame.size.height))
            scrollView.showsHorizontalScrollIndicator = false
            self.addSubview(scrollView)
            
            var totalWidth:CGFloat = 0.0
            
            for (index, title) in self.selectedChannels.enumerated() {
                
                let label = UILabel()
    
                label.tag = index
                label.text = title
                label.textColor = normalColor
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                
                label.sizeToFit()
                
                label.frame = CGRect(x: totalWidth + padding, y: 0, width: label.frame.size.width, height: label.frame.size.height)
                label.center.y = scrollView.frame.size.height * 0.5
                
                totalWidth += label.frame.size.width + padding
                
                label.isUserInteractionEnabled = true
                let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction))
                label.addGestureRecognizer(tapGR)
                
                self.labelWidthArray.append(label.frame.size.width)
                labelArray.append(label)
                scrollView.addSubview(label)
            }
            scrollView.contentSize = CGSize(width: totalWidth + padding, height: 0)

            self.indicatorView = {
                let view = UIView.init(frame: CGRect(x: 0, y: height - 1, width: 0, height: 1))
                view.backgroundColor = selectedColor
                scrollView.addSubview(view)
                return view
            }()
            
            //默认第一个选中
            let label = labelArray[lastSelectedIndex]
            label.textColor = selectedColor
            label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

            self.indicatorView.frame.size.width = label.frame.size.width
            self.indicatorView.center.x = label.center.x
            
            return scrollView
        }()
        
    }
    
    @objc fileprivate func tapAction(_ tapGR: UITapGestureRecognizer) {
        selectIndex(tapGR.view!.tag)
        self.delegate?.didTapNaviButton(self)
    }
    
    @objc fileprivate func tapAddButton(_ button: UIButton) {
        self.delegate?.didTapAddButton(self)
    }
    
    ///重新布局
    @objc fileprivate func changedChannel(_ noti: Notification) {
        //先清除旧的
        for (_, label) in self.labelArray.enumerated() {
            label.removeFromSuperview()
        }
        self.selectedChannels.removeAll()
        self.unselectedChannels.removeAll()
        self.labelArray.removeAll()
        self.labelWidthArray.removeAll()
        
        let selectedChannels = noti.userInfo!["selectedChannels"]! as! [String]
        let unselectedChannels = noti.userInfo!["unselectedChannels"]! as! [String]
        self.selectedChannels = selectedChannels
        self.unselectedChannels = unselectedChannels
        
        //添加新的
        var totalWidth:CGFloat = 0.0
        
        for (index, title) in self.selectedChannels.enumerated() {
            
            let label = UILabel()
            
            label.tag = index
            label.text = title
            label.textColor = normalColor
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            
            label.sizeToFit()
            
            label.frame = CGRect(x: totalWidth + padding, y: 0, width: label.frame.size.width, height: label.frame.size.height)
            label.center.y = scrollView.frame.size.height * 0.5
            
            totalWidth += label.frame.size.width + padding
            
            label.isUserInteractionEnabled = true
            let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction))
            label.addGestureRecognizer(tapGR)
            
            self.labelWidthArray.append(label.frame.size.width)
            labelArray.append(label)
            scrollView.addSubview(label)
        }
        scrollView.contentSize = CGSize(width: totalWidth + padding, height: 0)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        
        //默认第一个选中
        lastSelectedIndex = 0
        let label = labelArray[lastSelectedIndex]
        label.textColor = selectedColor
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        self.indicatorView.frame.size.width = label.frame.size.width
        self.indicatorView.center.x = label.center.x
    }
    
    //MARK: - public func
    ///设置选中的index
    open func selectIndex(_ index: Int) {
        
        guard index != lastSelectedIndex else { return }
        
        
        let label = labelArray[index]
        label.textColor = selectedColor
        label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        let lastLabel = labelArray[lastSelectedIndex]
        lastLabel.textColor = normalColor
        lastLabel.transform = CGAffineTransform.identity
        
        lastSelectedIndex = index
        
        var offSetX = label.center.x - self.bounds.size.width / 2
        if offSetX < 0 {
            offSetX = 0
        }
        
        let buttonWidth = self.addButton?.frame.size.width ?? 0.0
        var maxOffSetX = scrollView.contentSize.width - self.bounds.size.width + buttonWidth
        if maxOffSetX < 0 {
            maxOffSetX = 0
        }
        
        if offSetX > maxOffSetX {
            offSetX = maxOffSetX
        }
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        UIView.animate(withDuration: 0.3, animations: { 
            self.indicatorView.frame.size.width = label.frame.size.width
            self.indicatorView.center.x = label.center.x
        }) 
    }
}
















