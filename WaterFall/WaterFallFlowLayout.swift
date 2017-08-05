//
//  WaterFallFlowLayout.swift
//  WaterFall
//
//  Created by MrHuang on 17/8/5.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//


import UIKit


protocol HJwaterFallCollectionDataSource : class {
    
    func numberOfClos(_ HJwaterFallLayout: HJwaterFallCollection) -> Int
    func itemHeight(_ HJwaterFallLayout: HJwaterFallCollection,item:CGFloat) -> CGFloat
    
}



class HJwaterFallCollection: UICollectionViewFlowLayout {
    
    weak var dataSource : HJwaterFallCollectionDataSource?
    
    fileprivate lazy var clos : Int = {
        
        //如果不传入数据则默认为2
        return self.dataSource?.numberOfClos(self) ?? 2
        
    }()
    
    //用数组来装下所有的item的高度值Array(repeating: , count: ) 第一个参数重复的位置，第二个参数重复的个数
    
    fileprivate lazy var totalHeights:[CGFloat] = Array(repeating: self.sectionInset.top, count: self.clos)
    
    fileprivate lazy var cellAttrs:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    // 上次计算的个数
    //    fileprivate  var preCount : Int = 0
    
}


//MARK: -准备布局
extension HJwaterFallCollection {
    
    //重写prepare()
    override func prepare() {
        super.prepare()
        
        // 1.获取cell的个数
        let itemcount = collectionView!.numberOfItems(inSection: 0)
        print(itemcount)
        // 2.给每个cell 创建 UICollectionViewLayoutAttributes 每个cell都对应一个
        //每个cell 的宽度 collectionView的宽度- 左边距 - 右边距 -（列数-1）* 间距值，假设有三列item 则有2个minimumInteritemSpacing
        
        let cellWidth : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(clos - 1) * minimumInteritemSpacing ) / CGFloat(clos)
        
        //直接从这个数组个数开始遍历时则可避免重复计算
        for i in cellAttrs.count..<itemcount {
            // 1.根据i 来创建index记录
            let index = IndexPath(item: i, section: 0)
            // 2.根据index来创建相应的UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: index)
            
            // 3.设置attr的Frame
            
            guard let cellHeight : CGFloat = dataSource?.itemHeight(self, item: CGFloat(i)) else {
                fatalError("请实现对应的数据源方法,并且返回Cell高度")
            }
            //            var cellHeight:CGFloat = CGFloat(arc4random_uniform(150) + 100)
            
            //所有item里的最小的高度
            let minHeight = totalHeights.min()!
            //最小高度的标记
            let minIndex = totalHeights.index(of: minHeight)!
            
            let cellX : CGFloat = sectionInset.left + (minimumInteritemSpacing + cellWidth) * CGFloat(minIndex)
            
            let cellY : CGFloat = minimumLineSpacing + minHeight
            
            attr.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
            
            // 4.保存attr
            cellAttrs.append(attr)
            
            // 5.添加到当前的高度
            totalHeights[minIndex] = minHeight + minimumLineSpacing + cellHeight
            
        }
        
        // 6.记录上次计算的个数
        //        preCount = cellAttrs.count
    }
    
}

//MARK: -准备好返回所有的布局

extension HJwaterFallCollection{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return cellAttrs
        
    }
    
}


//MARK: -设置collectionView的contenSize
extension HJwaterFallCollection{
    
    override var collectionViewContentSize: CGSize{
        
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom - minimumLineSpacing)
    }
    
}
