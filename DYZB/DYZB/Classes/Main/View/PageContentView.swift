//
//  PageContentView.swift
//  DYZB
//
//  Created by Kitty on 2017/4/20.
//  Copyright © 2017年 RM. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}
private let ContentCellID = "ContentCellID"
// MARK: -
class PageContentView: UIView {

    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parsenViewContoller : UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    weak var delegate: PageContentViewDelegate?
    fileprivate var isForbidScrollDelegate: Bool = false
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
    
     init(frame: CGRect, childVcs: [UIViewController], parsentViewController: UIViewController?) {
        
        self.childVcs = childVcs
        self.parsenViewContoller = parsentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
// MARK: - UI
extension PageContentView {
    fileprivate func setupUI() {
        
        for childVc in childVcs {
            
            parsenViewContoller?.addChildViewController(childVc)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
}
// MARK: - UICollectionViewDatasource
extension PageContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let  childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        
        cell.contentView.addSubview(childVc.view)
        return cell
        
    }
}

// MARK: - UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {
            return
        }
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if startOffsetX < currentOffsetX { //左滑
            
            progress =  currentOffsetX / scrollViewW  - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {// 右滑
            progress =  1 - (currentOffsetX / scrollViewW  - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            if startOffsetX - currentOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }
        
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
// MARK: - 对外
extension PageContentView {
    func setCurrentIndex(currentIndex: Int)  {
        
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}
