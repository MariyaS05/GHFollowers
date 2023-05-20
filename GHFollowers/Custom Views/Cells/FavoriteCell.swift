//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by Мария  on 10.03.23.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let reuseId = " FavoriteCell"
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(){
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        
        accessoryType = .disclosureIndicator
        let padding : CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)

        ])
    }
    func set(favorite: Follower) {
        usernameLabel.text = favorite.login
        NetworkManager.shared.downloadImage(from: favorite.avatarUrl) {[weak self] image in
            guard let self  = self else {return}
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
}