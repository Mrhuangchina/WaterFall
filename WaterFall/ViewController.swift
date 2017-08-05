//
//  ViewController.swift
//  HJ瀑布流布局
//
//  Created by MrHuang on 17/7/9.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

fileprivate let kCellID = "kCellID"

class ViewController: UIViewController {
    
    
    fileprivate var cellCount : Int = 30
    
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = HJwaterFallCollection()
        
        layout.sectionInset = UIEdgeInsets(top:10,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
       
        layout.dataSource = self
       
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout:layout)
        
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        
    }



}


//MARK: -CollectionViewdataSource

extension ViewController : UICollectionViewDataSource{

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        
        if indexPath.item == cellCount - 1 {
            
            cellCount += 30
            
            collectionView.reloadData()
        }
        
        return cell
    }


}

//MARK: -实现HJwaterFallDataSource

extension ViewController : HJwaterFallCollectionDataSource {

    func numberOfClos(_ HJwaterFallLayout: HJwaterFallCollection) -> Int{
    
        return 3
        
    }
    func itemHeight(_ HJwaterFallLayout: HJwaterFallCollection,item:CGFloat) -> CGFloat{
    
        return CGFloat(arc4random_uniform(100) + 150)
    }
    

}
