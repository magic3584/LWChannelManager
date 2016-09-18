//
//  LWChannelView.swift
//  navi
//
//  Created by wang on 9/13/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

public class LWChannelView: UIView {

    private var collectionView: UICollectionView?
    
    var selectedChannelArray: [String]?
    private var unselectedChannelArray: [String]?
    
    //距屏幕的间隔，并且两个cell之间为padding＊2
    private let padding:CGFloat = 10.0
    
    //手势开始时的差
    private var deltaSize: CGSize!
    
    private var snapCellImageView: UIImageView!
    private var selectedIndexPath: NSIndexPath!
    private var selectedCell: LWChannelCollectionViewCell!

    public init(frame: CGRect, selectedChannels: [String], unselectedChannels: [String]) {
        super.init(frame: frame)
        self.selectedChannelArray = selectedChannels
        self.unselectedChannelArray = unselectedChannels
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.collectionView = {
            self.userInteractionEnabled = true
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .Vertical
            
            let width = (self.bounds.size.width - padding * 8) / 4.0
            let height: CGFloat = 30.0
            
            layout.itemSize = CGSizeMake(width, height)
            layout.minimumLineSpacing = 10.0
            layout.minimumInteritemSpacing = padding * 2
            layout.sectionInset = UIEdgeInsetsMake(10.0, padding, 10.0, padding)
            
            let collectionView = UICollectionView.init(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.registerClass(LWChannelSectionView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "section")
            collectionView.registerClass(LWChannelCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            collectionView.dataSource = self
            let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressAction(_:)))
            collectionView.addGestureRecognizer(longPress)
            self.addSubview(collectionView)
            
            return collectionView
        }()
    }
    
    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.locationInView(self.collectionView!)
        let possibleIndexPath = self.collectionView!.indexPathForItemAtPoint(location)

        switch(gesture.state) {
            
            case .Began:
                //保证有效的cell
                if possibleIndexPath != nil {
                    
                    //上面第一个不动
                    if possibleIndexPath! == NSIndexPath.init(forRow: 0, inSection: 0) { break }
                    
                    selectedIndexPath = possibleIndexPath
                    
                    let cell = self.collectionView!.cellForItemAtIndexPath(selectedIndexPath)! as!LWChannelCollectionViewCell
                    selectedCell = cell
                    
                    deltaSize = CGSizeMake(location.x - cell.frame.origin.x, location.y - cell.frame.origin.y)
                    
                    snapCellImageView = self.snapForCell(cell)
                    cell.setDashLayer(true)
                    cell.alpha = 0.7
                    
                    snapCellImageView.center = cell.center
                    self.collectionView!.addSubview(snapCellImageView)
                }
            
            case .Changed:
                
                if snapCellImageView == nil {
                    return
                }
                
                snapCellImageView.frame.origin = CGPointMake(location.x - deltaSize.width, location.y - deltaSize.height)
                selectedCell.alpha = 0.7

                if possibleIndexPath != nil && selectedIndexPath != nil {
                    
                    if possibleIndexPath == NSIndexPath.init(forRow: 0, inSection: 0) ||
                    selectedIndexPath == NSIndexPath.init(forRow: 0, inSection: 0) { return }

                    if possibleIndexPath!.section == selectedIndexPath.section {//同一块区域
                        
                        if possibleIndexPath!.section == 0 {//上面的
                            
                            if possibleIndexPath!.row > selectedIndexPath.row {
                                for index in selectedIndexPath.row..<possibleIndexPath!.row {
                                    selectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index + 1)
                                }
                            }
                            
                            if possibleIndexPath!.row < selectedIndexPath.row {
                                var index = selectedIndexPath.row
                                for _ in possibleIndexPath!.row..<selectedIndexPath.row {
                                    selectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index - 1)
                                    index -= 1
                                }
                            }
                        } else {//下面的
                            
                            if possibleIndexPath!.row > selectedIndexPath.row {
                                for index in selectedIndexPath.row..<possibleIndexPath!.row {
                                    unselectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index + 1)
                                }
                            }
                            
                            if possibleIndexPath!.row < selectedIndexPath.row {
                                var index = selectedIndexPath.row
                                for _ in possibleIndexPath!.row..<selectedIndexPath.row {
                                    unselectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index - 1)
                                    index -= 1
                                }
                            }
                        }
                    } else if possibleIndexPath!.section > selectedIndexPath.section {//往下移动
                        let channel = selectedChannelArray!.removeAtIndex(selectedIndexPath.row)
                        unselectedChannelArray!.insert(channel, atIndex: possibleIndexPath!.row)
                    } else if possibleIndexPath!.section < selectedIndexPath.section {//往下移动
                        let channel = unselectedChannelArray!.removeAtIndex(selectedIndexPath.row)
                        selectedChannelArray!.insert(channel, atIndex: possibleIndexPath!.row)
                    }
                    
                    self.collectionView!.moveItemAtIndexPath(selectedIndexPath, toIndexPath: possibleIndexPath!)
                    selectedIndexPath = possibleIndexPath
                }
                
            case .Ended:
                
                if selectedCell != nil {
                    selectedCell.setDashLayer(false)
                    selectedCell.alpha = 1.0
                }
                
                if snapCellImageView != nil {
                    snapCellImageView.removeFromSuperview()
                    snapCellImageView = nil
                }
                
                self.changedChannels(self.selectedChannelArray!)

                print(selectedChannelArray)
                print(unselectedChannelArray)
            default: break
        }
    }
    
    private func snapForCell(cell: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snap = UIImageView(image: image)
        return snap
    }
    
    private func changedChannels(channels: [String]) {
        NSNotificationCenter.defaultCenter().postNotificationName("LWChangeChannelNotification", object: self)
    }
}

extension LWChannelView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedChannelArray!.count
        } else {
            return unselectedChannelArray!.count
        }
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! LWChannelCollectionViewCell
        cell.backgroundColor = nil
        
        let text: String?
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
            }
            text = selectedChannelArray![indexPath.row]
        } else {
            text = unselectedChannelArray![indexPath.row]
        }
        cell.label!.text = text
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section", forIndexPath: indexPath) as! LWChannelSectionView
        if indexPath.section == 0 {
            view.label?.text = "  我的频道（点击删除频道）"
        } else {
            view.label?.text = "  点击添加以下频道"
        }
        return view
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.size.width, height: 30)
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {//点击取消
            if indexPath.row == 0 {
                return
            }
            let channel = self.selectedChannelArray?.removeAtIndex(indexPath.row)
            self.unselectedChannelArray?.append(channel!)
        } else {//点击选中
            let channel = self.unselectedChannelArray?.removeAtIndex(indexPath.row)
            self.selectedChannelArray?.append(channel!)
        }
        collectionView.reloadData()
        self.changedChannels(self.selectedChannelArray!)
    }
    
}

class LWChannelSectionView: UICollectionReusableView {
    private var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        self.label = {
            let label = UILabel.init(frame: self.bounds)
            label.font = UIFont.systemFontOfSize(14)
            self.addSubview(label)
            return label
        }()
    }
}

extension Array {
    mutating func exchangeChannelArray(betweenIndex index: Int,andIndex anotherIndex: Int) {
        let temp = self[index]
        self[index] = self[anotherIndex]
        self[anotherIndex] = temp
    }
}















