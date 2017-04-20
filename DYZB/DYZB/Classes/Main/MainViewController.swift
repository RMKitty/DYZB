//
//  MainViewController.swift
//  DYZB
//
//  Created by Kitty on 2017/4/20.
//  Copyright © 2017年 RM. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if #available(iOS 8.0, *) {
            addChildViewControllerByName(storyName: "Home")
            addChildViewControllerByName(storyName: "Live")
            addChildViewControllerByName(storyName: "Follow")
            addChildViewControllerByName(storyName: "Profile")
//        }
    }

    private func addChildViewControllerByName(storyName:String) {
        let vc = UIStoryboard.init(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
