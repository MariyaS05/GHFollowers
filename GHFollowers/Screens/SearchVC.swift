//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Мария  on 20.12.22.
//

import UIKit

class SearchVC: UIViewController {
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUsernameEntered : Bool { return !usernameTextField.text!.isEmpty}
    var logoImageViewTopConstrait : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDissmissKeyboardTapGesture()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text =  ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func createDissmissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: view, action:#selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    @objc func pushFollowersListVC(){
        guard isUsernameEntered else {
            pressentGFAlertOnMainThread(title: "Empty Username", message: "Please, enter a username.We need to know who to look for 😄.", buttonTitle: "Ok")
            return
    }
        usernameTextField.resignFirstResponder()
        guard let textFieldtext =  usernameTextField.text else {return}
        let followerListVc = FollowerListVc(username: textFieldtext)
        self.navigationController?.pushViewController(followerListVc, animated: true)
    }
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image =  Images.ghLogo
        
        let topConstraitConstant : CGFloat = DevicesType.isiPhoneSE || DevicesType.isiPhone8Zoomed ? 20 : 80
        logoImageViewTopConstrait =  logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraitConstant)
        logoImageViewTopConstrait.isActive =  true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField(){
        view.addSubview(usernameTextField)
        usernameTextField.delegate =  self
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    func configureCallToActionButton(){
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
extension SearchVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListVC()
        return true
    }
}
