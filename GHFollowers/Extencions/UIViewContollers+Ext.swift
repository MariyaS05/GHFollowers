//
//  UIViewContollers+Ext.swift
//  GHFollowers
//
//  Created by Мария  on 21.12.22.
//


import UIKit
import SafariServices



extension UIViewController {
    
    func pressentGFAlertOnMainThread(title : String,message : String, buttonTitle : String){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    func presentSafariVC(with url : URL){
        let safariVC =  SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
}
