//
//  HomeViewController.swift
//  DYZB
//
//  Created by Kitty on 2017/4/20.
//  Copyright © 2017年 RM. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK: - 标题
    fileprivate lazy var pageTitleView: PageTitleView = { [weak self] in
        let titleFram = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFram, titles: titles)
        titleView.delegate = self
        return titleView
    
    }()
    // MARK: - 内容
    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabbarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parsentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupUI()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension HomeViewController {
    
    fileprivate func setupUI() {
        
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        //添加TitleView
        view.addSubview(pageTitleView)
        // MARK: - 内容View
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.red
    }
    
    private func setupNavigationBar() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "logo")
        
        let size = CGSize.init(width: 40, height: 40)
        let historyItem = UIBarButtonItem.init(imageName: "image_my_history", highImage: "image_my_history_click", size: size)
        let searchItem = UIBarButtonItem.init(imageName: "btn_search", highImage: "btn_search_clicked", size: size)
        let qarcodeItem = UIBarButtonItem.init(imageName: "Image_scan", highImage: "Image_scan_click", size: size)
        
    
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qarcodeItem]
    }
}

// MARK: - PageTitleViewDelegate
extension HomeViewController: PageTitleViewDelegate {
    
    func pagetTitleView(titleView: PageTitleView, selectedIndex: Int) {
        pageContentView.setCurrentIndex(currentIndex: selectedIndex)
    }
}

// MARK: - PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        pageTitleView.setTitleViewProgess(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
