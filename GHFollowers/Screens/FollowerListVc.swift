//
//  FollowerListVc.swift
//  GHFollowers
//
//  Created by Мария  on 21.12.22.
//

import UIKit
protocol FollowerListVCDelegate : AnyObject {
    func didRequestFollowers(for username : String)
}

class FollowerListVc: GFDataLoadingVC {
    enum Section {
        case main
    }
    var username : String!
    var page : Int =  1
    var hasMoreFollowers = true
    var isSearching = false
    var followers : [Follower] = []
    var filteredFollowers : [Follower] = []
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section,Follower>!
    var isLoading =  false
    
    init(username : String) {
        super.init(nibName: nil, bundle: nil)
        self.username =  username
        title =  username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("View is loaded")
        configureSearchController()
        configureCollectionView()
        configureViewController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
       
    }
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate =  self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    func configureSearchController(){
        let searchController =  UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    func getFollowers(username : String,page: Int){
        showLoadingView()
        isLoading =  true
        NetworkManager.shared.getFollowers(for: username, page: page) {[weak self] followers, errorMessage in
            guard let self =  self else {return}
            self.dissmissLoadingView()
            guard let followers = followers else {
                self.pressentGFAlertOnMainThread(title: "Bad staff happened", message: errorMessage!.rawValue, buttonTitle: "Ok")
                return
            }
            if followers.count < 100 {self.hasMoreFollowers = false}
            self.followers.append(contentsOf: followers)
            self.updateData(on: self.followers)
            if self.followers.isEmpty {
                let message = "This user doesn't have any followers.Go follow them ☺️."
                DispatchQueue.main.async {
                    self.showEmptyStateView(show: message, in: self.view)
                    return
                }
            }
            self.isLoading =  false
        }
       
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: {( collectionView, indexPath, follower)->UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(for: follower)
            return cell
        })
    }
    func updateData(on followers : [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
   
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self =  self else {return}
            self.dissmissLoadingView()
            switch result {
            case.success(let user) :
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .ad) {  [weak self]error in
                    guard let self =  self else {return}
                    guard let error = error else {
                        self.pressentGFAlertOnMainThread(title: "Success", message: "You have successfuly favorited this user!", buttonTitle: "Ok")
                        return
                    }
                    self.pressentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            case .failure(let error) :
                self.pressentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }
}
extension FollowerListVc : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY =  scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight -  height {
            guard hasMoreFollowers,!isLoading else {return}
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate =  self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
extension FollowerListVc : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else{
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
        isSearching = false
    }
}
extension FollowerListVc : FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username =  username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
