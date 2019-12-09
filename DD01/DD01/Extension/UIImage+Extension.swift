//
//  UIImage+Extension.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    
    func cutRoundCorner(size: CGSize, radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        context.clip()
        self.draw(in: rect)
        context.drawPath(using: .fillStroke)
        let outputImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return outputImg
    }
    
    func cutCircleImage(size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            context.addEllipse(in: rect)
            context.clip()
        
            self.draw(in: rect)
            let outputImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return outputImg
    }
}
