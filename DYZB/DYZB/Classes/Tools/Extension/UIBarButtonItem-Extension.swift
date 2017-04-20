//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by Kitty on 2017/4/20.
//  Copyright © 2017年 RM. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /*
    class func creatItem(imageName:String, highImage:String, size:CGSize) -> UIBarButtonItem {
     
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)

        button.setImage(UIImage(named: highImage), for: .highlighted)
        button.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem.init(customView: button)
    }
    */
    convenience public init(imageName: String, highImage: String = "", size: CGSize = CGSize.zero) {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        if highImage != "" {
            button.setImage(UIImage(named: highImage), for: .highlighted)
        }
        if size == CGSize.zero {
            button.sizeToFit()
        } else {
            button.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView: button)
    }
}
