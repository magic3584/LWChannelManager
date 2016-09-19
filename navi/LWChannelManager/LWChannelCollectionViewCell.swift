//
//  LWChannelCollectionViewCell.swift
//  navi
//
//  Created by wang on 9/13/16.
//  Copyright © 2016 wang. All rights reserved.
//

import UIKit

class LWChannelCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel?
    
    fileprivate lazy var dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.blue.cgColor
        layer.fillColor = nil
        layer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 5.0).cgPath
        layer.lineWidth = 1.0
        layer.lineDashPattern = [ 4, 2 ]
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.label = {
            let label = UILabel.init(frame: self.bounds)
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            self.addSubview(label)
            return label
        }()
    }
    
    func setDashLayer(_ showDash: Bool) {
        self.layer.addSublayer(self.dashLayer)
        self.dashLayer.isHidden = !showDash
    }
}














