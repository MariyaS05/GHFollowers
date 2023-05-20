//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Мария  on 30.12.22.
//

import UIKit
class GFFollowerItemVC : GFItemInfoVC {
override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
    
}
private func configureItems(){
    itemViewOne.set(itemInfoType: .followers, with: user.followers)
    itemViewTwo.set(itemInfoType: .following, with: user.following)
    actionButton.set(backgroundcolor: .systemGreen, title: "Get Followers")
}
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
