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
    func didTapNaviButton(naviView: LWScrollNaviView)
    //点击添加
    func didTapAddButton(naviView: LWScrollNaviView)
}

public class LWScrollNaviView: UIView {

    private var scrollView: UIScrollView!
    private var indicatorView: UIView!
    private var addButton: UIButton?
    
    public weak var delegate: LWScrollNaviViewDelegate?
    
    private var titleArray: [String]!
    private var labelArray: [UILabel] = []
    private var showAddButton: Bool?
    //缓存每个label的宽度
    private var labelWidthArray: [CGFloat] = []
    
    ///按钮的间隔
    private let padding:CGFloat = 10.0
    
    private let normalColor = UIColor.blackColor()
    private let selectedColor = UIColor.redColor()
    
    public var lastSelectedIndex = 0
    
    public init(frame: CGRect, titles: [String], showAddButton: Bool) {
        super.init(frame: frame)
        self.titleArray = titles
        self.showAddButton = showAddButton
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changedChannel(_:)), name: "LWChangeChannelNotification", object: nil)
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - private func
    
    private func configUI() {
        self.scrollView = {
            self.userInteractionEnabled = true
            
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            if (self.showAddButton == true) {
                //位置最右，宽高相等
                self.addButton = UIButton.init(frame: CGRectMake(width - height, 0, height, height))
                self.addButton?.setTitle("添加", forState: .Normal)
                self.addButton?.backgroundColor = UIColor.redColor()
                self.addButton?.addTarget(self, action: #selector(self.tapAddButton(_:)), forControlEvents: .TouchUpInside)
                self.addSubview(self.addButton!)
            }
            
            let buttonWidth = self.addButton?.frame.size.width ?? 0.0
            
            let scrollView = UIScrollView.init(frame: CGRectMake(0, 0, width - buttonWidth, self.frame.size.height))
            scrollView.showsHorizontalScrollIndicator = false
            self.addSubview(scrollView)
            
            var totalWidth:CGFloat = 0.0
            
            for (index, title) in self.titleArray.enumerate() {
                
                let label = UILabel()
    
                label.tag = index
                label.text = title
                label.textColor = normalColor
                label.font = UIFont.systemFontOfSize(14)
                label.textAlignment = .Center
                
                label.sizeToFit()
                
                label.frame = CGRectMake(totalWidth + padding, 0, label.frame.size.width, label.frame.size.height)
                label.center.y = scrollView.frame.size.height * 0.5
                
                totalWidth += label.frame.size.width + padding
                
                label.userInteractionEnabled = true
                let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction))
                label.addGestureRecognizer(tapGR)
                
                self.labelWidthArray.append(label.frame.size.width)
                labelArray.append(label)
                scrollView.addSubview(label)
            }
            scrollView.contentSize = CGSizeMake(totalWidth + padding, 0)

            self.indicatorView = {
                let view = UIView.init(frame: CGRectMake(0, height - 1, 0, 1))
                view.backgroundColor = selectedColor
                scrollView.addSubview(view)
                return view
            }()
            
            //默认第一个选中
            let label = labelArray[lastSelectedIndex]
            label.textColor = selectedColor
            label.transform = CGAffineTransformMakeScale(1.2, 1.2)

            self.indicatorView.frame.size.width = label.frame.size.width
            self.indicatorView.center.x = label.center.x
            
            return scrollView
        }()
        
    }
    
    @objc private func tapAction(tapGR: UITapGestureRecognizer) {
        selectIndex(tapGR.view!.tag)
        self.delegate?.didTapNaviButton(self)
    }
    
    @objc private func tapAddButton(button: UIButton) {
        self.delegate?.didTapAddButton(self)
    }
    
    ///重新布局
    @objc private func changedChannel(noti: NSNotification) {
        //先清除旧的
        for (_, label) in self.labelArray.enumerate() {
            label.removeFromSuperview()
        }
        self.titleArray.removeAll()
        self.labelArray.removeAll()
        self.labelWidthArray.removeAll()
        
        //添加新的
        lastSelectedIndex = 0
        self.titleArray = (noti.object as! LWChannelView).selectedChannelArray!
        var totalWidth:CGFloat = 0.0
        
        for (index, title) in self.titleArray.enumerate() {
            
            let label = UILabel()
            
            label.tag = index
            label.text = title
            label.textColor = normalColor
            label.font = UIFont.systemFontOfSize(14)
            label.textAlignment = .Center
            
            label.sizeToFit()
            
            label.frame = CGRectMake(totalWidth + padding, 0, label.frame.size.width, label.frame.size.height)
            label.center.y = scrollView.frame.size.height * 0.5
            
            totalWidth += label.frame.size.width + padding
            
            label.userInteractionEnabled = true
            let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction))
            label.addGestureRecognizer(tapGR)
            
            self.labelWidthArray.append(label.frame.size.width)
            labelArray.append(label)
            scrollView.addSubview(label)
        }
        scrollView.contentSize = CGSizeMake(totalWidth + padding, 0)
        scrollView.setContentOffset(CGPointZero, animated: false)
        
        //默认第一个选中
        let label = labelArray[lastSelectedIndex]
        label.textColor = selectedColor
        label.transform = CGAffineTransformMakeScale(1.2, 1.2)
        
        self.indicatorView.frame.size.width = label.frame.size.width
        self.indicatorView.center.x = label.center.x
    }
    
    //MARK: - public func
    ///设置选中的index
    public func selectIndex(index: Int) {
        
        guard index != lastSelectedIndex else { return }
        
        
        let label = labelArray[index]
        label.textColor = selectedColor
        label.transform = CGAffineTransformMakeScale(1.1, 1.1)
        
        let lastLabel = labelArray[lastSelectedIndex]
        lastLabel.textColor = normalColor
        lastLabel.transform = CGAffineTransformIdentity
        
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
        scrollView.setContentOffset(CGPointMake(offSetX, 0), animated: true)
        UIView.animateWithDuration(0.3) { 
            self.indicatorView.frame.size.width = label.frame.size.width
            self.indicatorView.center.x = label.center.x
        }
    }
}
















