//
//  PageTitleView.swift
//  DYZB
//
//  Created by Kitty on 2017/4/20.
//  Copyright © 2017年 RM. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {
    
    func pagetTitleView(titleView: PageTitleView, selectedIndex: Int)
}
private let kTitleFont : CGFloat = 16.0
private let kScrollLineH : CGFloat = 2

private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {

   // MARK: - 属性
    fileprivate var currentIndex: Int = 0
    fileprivate var titles: [String]
    weak var delegate: PageTitleViewDelegate?
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false // GO
        scrollView.bounces = false
        return scrollView
    }()
    // 滑块
    fileprivate lazy var scrollLine : UIView = {
        
        let line = UIView()
        line.backgroundColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        return line
    }()
    
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
extension PageTitleView {
    
    fileprivate func setupUI() {
        
            // 1.添加ScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        //
        setupTitleLables()
        // 设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLables() {
        
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: kTitleFont)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            let labelX = labelW * CGFloat(index)
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.titleLableClick(tapGes:)))
            label.addGestureRecognizer(tapGesture)
            
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let  lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        guard let  firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.size.width, height: kScrollLineH)
    }
}
// MARK: - 点击事件
extension PageTitleView {
    
    @objc fileprivate func titleLableClick(tapGes: UITapGestureRecognizer) {
        
        guard let currentLable = tapGes.view as? UILabel else { return }
        //
        let oldLabel = titleLabels[currentIndex]
        
        
        currentLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        oldLabel.textColor = UIColor.darkGray
        
        currentIndex = currentLable.tag
        
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.2) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.pagetTitleView(titleView: self, selectedIndex: currentIndex)
        
    }
}

// MARK: - 对外
extension PageTitleView {
    
    func setTitleViewProgess(progress: CGFloat, sourceIndex: Int, targetIndex: Int)  {
        
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        currentIndex = targetIndex
    }
}








