//
//  LWChannelView.swift
//  navi
//
//  Created by wang on 9/13/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

open class LWChannelView: UIView {

    fileprivate var collectionView: UICollectionView?
    
    var selectedChannelArray: [String]?
    fileprivate var unselectedChannelArray: [String]?
    
    //距屏幕的间隔，并且两个cell之间为padding＊2
    fileprivate let padding:CGFloat = 10.0
    
    //手势开始时的差
    fileprivate var deltaSize: CGSize!
    
    fileprivate var snapCellImageView: UIImageView!
    fileprivate var selectedIndexPath: IndexPath!
    fileprivate var selectedCell: LWChannelCollectionViewCell!

    public init(frame: CGRect, selectedChannels: [String], unselectedChannels: [String]) {
        super.init(frame: frame)
        self.selectedChannelArray = selectedChannels
        self.unselectedChannelArray = unselectedChannels
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        self.collectionView = {
            self.isUserInteractionEnabled = true
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
            let width = (self.bounds.size.width - padding * 8) / 4.0
            let height: CGFloat = 30.0
            
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumLineSpacing = 10.0
            layout.minimumInteritemSpacing = padding * 2
            layout.sectionInset = UIEdgeInsetsMake(10.0, padding, 10.0, padding)
            
            let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
            collectionView.register(LWChannelSectionView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "section")
            collectionView.register(LWChannelCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            collectionView.dataSource = self
            let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressAction(_:)))
            collectionView.addGestureRecognizer(longPress)
            self.addSubview(collectionView)
            
            return collectionView
        }()
    }
    
    @objc fileprivate func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: self.collectionView!)
        let possibleIndexPath = self.collectionView!.indexPathForItem(at: location)

        switch(gesture.state) {
            
            case .began:
                //保证有效的cell
                if possibleIndexPath != nil {
                    
                    //上面第一个不动
                    if possibleIndexPath! == IndexPath.init(row: 0, section: 0) { break }
                    
                    selectedIndexPath = possibleIndexPath
                    
                    let cell = self.collectionView!.cellForItem(at: selectedIndexPath)! as!LWChannelCollectionViewCell
                    selectedCell = cell
                    
                    deltaSize = CGSize(width: location.x - cell.frame.origin.x, height: location.y - cell.frame.origin.y)
                    
                    snapCellImageView = self.snapForCell(cell)
                    cell.setDashLayer(true)
                    cell.alpha = 0.7
                    
                    snapCellImageView.center = cell.center
                    self.collectionView!.addSubview(snapCellImageView)
                }
            
            case .changed:
                
                if snapCellImageView == nil {
                    return
                }
                
                snapCellImageView.frame.origin = CGPoint(x: location.x - deltaSize.width, y: location.y - deltaSize.height)
                selectedCell.alpha = 0.7

                if possibleIndexPath != nil && selectedIndexPath != nil {
                    
                    if possibleIndexPath == IndexPath.init(row: 0, section: 0) ||
                    selectedIndexPath == IndexPath.init(row: 0, section: 0) { return }

                    if (possibleIndexPath! as NSIndexPath).section == selectedIndexPath.section {//同一块区域
                        
                        if (possibleIndexPath! as NSIndexPath).section == 0 {//上面的
                            
                            if (possibleIndexPath! as NSIndexPath).row > selectedIndexPath.row {
                                for index in selectedIndexPath.row..<(possibleIndexPath! as NSIndexPath).row {
                                    selectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index + 1)
                                }
                            }
                            
                            if (possibleIndexPath! as NSIndexPath).row < selectedIndexPath.row {
                                var index = selectedIndexPath.row
                                for _ in (possibleIndexPath! as NSIndexPath).row..<selectedIndexPath.row {
                                    selectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index - 1)
                                    index -= 1
                                }
                            }
                        } else {//下面的
                            
                            if (possibleIndexPath! as NSIndexPath).row > selectedIndexPath.row {
                                for index in selectedIndexPath.row..<(possibleIndexPath! as NSIndexPath).row {
                                    unselectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index + 1)
                                }
                            }
                            
                            if (possibleIndexPath! as NSIndexPath).row < selectedIndexPath.row {
                                var index = selectedIndexPath.row
                                for _ in (possibleIndexPath! as NSIndexPath).row..<selectedIndexPath.row {
                                    unselectedChannelArray!.exchangeChannelArray(betweenIndex: index, andIndex: index - 1)
                                    index -= 1
                                }
                            }
                        }
                    } else if (possibleIndexPath! as NSIndexPath).section > selectedIndexPath.section {//往下移动
                        let channel = selectedChannelArray!.remove(at: selectedIndexPath.row)
                        unselectedChannelArray!.insert(channel, at: (possibleIndexPath! as NSIndexPath).row)
                    } else if (possibleIndexPath! as NSIndexPath).section < selectedIndexPath.section {//往下移动
                        let channel = unselectedChannelArray!.remove(at: selectedIndexPath.row)
                        selectedChannelArray!.insert(channel, at: (possibleIndexPath! as NSIndexPath).row)
                    }
                    
                    self.collectionView!.moveItem(at: selectedIndexPath, to: possibleIndexPath!)
                    selectedIndexPath = possibleIndexPath
                }
                
            case .ended:
                
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
    
    fileprivate func snapForCell(_ cell: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snap = UIImageView(image: image)
        return snap
    }
    
    fileprivate func changedChannels(_ channels: [String]) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LWChangeChannelNotification"), object: self)
    }
}

extension LWChannelView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedChannelArray!.count
        } else {
            return unselectedChannelArray!.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LWChannelCollectionViewCell
        cell.backgroundColor = nil
        
        let text: String?
        
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                cell.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
            }
            text = selectedChannelArray![(indexPath as NSIndexPath).row]
        } else {
            text = unselectedChannelArray![(indexPath as NSIndexPath).row]
        }
        cell.label!.text = text
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "section", for: indexPath) as! LWChannelSectionView
        if (indexPath as NSIndexPath).section == 0 {
            view.label?.text = "  我的频道（点击删除频道）"
        } else {
            view.label?.text = "  点击添加以下频道"
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.size.width, height: 30)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {//点击取消
            if (indexPath as NSIndexPath).row == 0 {
                return
            }
            let channel = self.selectedChannelArray?.remove(at: (indexPath as NSIndexPath).row)
            self.unselectedChannelArray?.append(channel!)
        } else {//点击选中
            let channel = self.unselectedChannelArray?.remove(at: (indexPath as NSIndexPath).row)
            self.selectedChannelArray?.append(channel!)
        }
        collectionView.reloadData()
        self.changedChannels(self.selectedChannelArray!)
    }
    
}

class LWChannelSectionView: UICollectionReusableView {
    fileprivate var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        self.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        self.label = {
            let label = UILabel.init(frame: self.bounds)
            label.font = UIFont.systemFont(ofSize: 14)
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















