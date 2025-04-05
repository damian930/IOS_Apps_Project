//
//  BookmarkView.swift
//  hm_2
//
//  Created by  Damian  on 05.04.2025.
//

import UIKit

class BookmarkView: UIView {
    
    private static let bookmarkWidth  = 30.0
    private static let bookmarkHeight = 45.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        let midX = self.bounds.width  / 2
        let midY = self.bounds.height / 2
        
        let shapeLayer         = CAShapeLayer()
        shapeLayer.path        = createBazierPath().cgPath
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor   = UIColor.yellow.cgColor
        shapeLayer.lineWidth   = 1.0
        shapeLayer.position    = CGPoint(x: midX - BookmarkView.bookmarkWidth / 2,
                                         y: midY - BookmarkView.bookmarkHeight / 2)
        
        self.layer.addSublayer(shapeLayer)
    }
    
    private func createBazierPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(   to: CGPoint(x: 0,  y: 0))
        path.addLine(to: CGPoint(x: 0,  y: 45))
        path.addLine(to: CGPoint(x: 15, y: 30))
        path.addLine(to: CGPoint(x: 30, y: 45))
        path.addLine(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 0,  y: 0))
        
        return path
    }
    
    
    
    
    
    
}
