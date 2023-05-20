//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Мария  on 30.12.22.
//

import UIKit

class GFRepoItemVC : GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    private func configureItems(){
        itemViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundcolor: .systemPurple, title: "GitHub Profile")
    }
    override func actionButtonTapped() {
        delegate.didTapGuthubProfile(for: user)
    }
}
