//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Мария  on 20.12.22.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    
    
    let tableView  =  UITableView()
    var favorites :[Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame =  view.bounds
        tableView.rowHeight =  80
        tableView.delegate =  self
        tableView.dataSource =  self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title =  "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func getFavorites(){
        PersistenceManager.retrieveFavorites {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(show: "No favorites?\nAdd one the follower screen.", in: self.view)
                } else {
                    self.favorites =  favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let failure):
                self.pressentGFAlertOnMainThread(title: "Something went wrong", message:ErrorMessage.unableToCompleate.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
extension FavoritesListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  =  tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        let favorite  =  favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVc =  FollowerListVc(username: favorite.login)
        navigationController?.pushViewController(destVc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) {[weak self] error in
            guard let self =  self else {return}
            guard let error =  error else {
                return
            }
            self.pressentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
        
    }
}
