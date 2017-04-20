//
//  UIColor-Extension.swift
//  DYZB
//
//  Created by Kitty on 2017/4/20.
//  Copyright © 2017年 RM. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        
        self.init(red: r / 256.0, green: g / 256.0 , blue: b / 256.0, alpha: a)
    }
}
