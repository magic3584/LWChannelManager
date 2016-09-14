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
    
    private lazy var dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.blueColor().CGColor
        layer.fillColor = nil
        layer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 5.0).CGPath
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
    
    private func configUI() {
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.label = {
            let label = UILabel.init(frame: self.bounds)
            label.font = UIFont.systemFontOfSize(15)
            label.textAlignment = .Center
            self.addSubview(label)
            return label
        }()
    }
    
    func setDashLayer(showDash: Bool) {
        self.layer.addSublayer(self.dashLayer)
        self.dashLayer.hidden = !showDash
    }
}














