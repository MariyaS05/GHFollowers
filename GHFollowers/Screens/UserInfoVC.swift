//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Мария  on 27.12.22.
//

import UIKit
import SafariServices
protocol UserInfoVCDelegate: AnyObject {
    func didTapGuthubProfile( for user : User)
    func didTapGetFollowers(for user : User)
}
class UserInfoVC: UIViewController {
    var username : String!
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews : [UIView] = []
    let dateLabel = GFBodyLabel(textAlignment: .center)
    weak var delegate : FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        getUserInfo()
        layoutUI()
        print(username!)
    }
    
    func getUserInfo(){
        NetworkManager.shared.getUserInfo(for: username) {[weak self] result in
            guard let self =  self else {return}
            switch result {
            case.success(let user) :
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case.failure(let error) :
                self.pressentGFAlertOnMainThread(title: "Something goes wrong", message:error.rawValue , buttonTitle: "Ok")
                return
            }
        }
    }
    func configureUIElements(with user : User) {
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate =  self
        let followerItemVC =  GFFollowerItemVC(user: user)
        followerItemVC.delegate =  self
        
        self.addChildVC(childVC: repoItemVC, to: self.itemViewOne)
        self.addChildVC(childVC: followerItemVC, to: self.itemViewTwo)
        self.addChildVC(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub Since \( user.createdAt.convertToDisplayFormat())"
    }
    func layoutUI(){
        let  itemHeight : CGFloat =  140
        let padding : CGFloat =  20
        itemViews = [headerView,itemViewOne,itemViewTwo, dateLabel]
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
    
    
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
            
        ])
    }
    func addChildVC(childVC : UIViewController, to containerView : UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    func configureVC(){
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    @objc func dissmissVC(){
        dismiss(animated: true)
    }
}
extension UserInfoVC : UserInfoVCDelegate {
    func didTapGuthubProfile(for user: User) {
        guard let url  = URL(string: user.htmlUrl) else {
            pressentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid ", buttonTitle: "Ok")
            return
        }
       presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            pressentGFAlertOnMainThread(title: "NO  followers", message: "This user has no followers!What a shame 😔", buttonTitle: "So sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dissmissVC()
    }
}
