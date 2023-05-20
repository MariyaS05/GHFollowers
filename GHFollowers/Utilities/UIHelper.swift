//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Мария  on 24.12.22.
//

import UIKit
enum UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView)->UICollectionViewFlowLayout{
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpasing : CGFloat = 10
        let availableWidth =  width - (padding*2 ) - (minimumItemSpasing * 2 )
        let itemWidth = availableWidth/3
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        return flowLayout
    }
}
