//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by Мария  on 14.03.23.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    fileprivate var containerView : UIView!

    func showLoadingView (){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {self.containerView.alpha = 0.8}
        let activitiIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activitiIndicator)
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activitiIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activitiIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        activitiIndicator.startAnimating()
    }
    func dissmissLoadingView(){
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    func showEmptyStateView(show message : String, in view : UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    

}
