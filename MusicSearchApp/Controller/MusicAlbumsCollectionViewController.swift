//
//  MusicAlbumsCollectionViewController.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 10.12.2020.
//

import UIKit
import SDWebImage

class MusicAlbumsCollectionViewController: UICollectionViewController {

    private let sectionEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var musicAlbumsPage: MusicAlbumsPageData? = nil
    
    private var numberOfcolumns: Int {
        return musicSearchController.searchBar.selectedScopeButtonIndex + 1
    }
    
    //MARK: - UI Elements
    
    private let musicSearchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        searchController.searchBar.tintColor = .red
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.scopeButtonTitles = ["one", "two"]
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        
        return searchController
    }()
    
    private let musicAlbumsLabel: UIBarButtonItem = {
        
        let label = UILabel()
        label.text = "MUSIC ALBUMS"
        label.textColor = .red
        
        return UIBarButtonItem(customView: label)
    }()
    
    let alert: UIAlertController = {
        let alert = UIAlertController(title: "Not Found Music Albums",
                                      message: "please check the introductory terms",
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        return alert
    }()

    //MARK: Life Cycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupRemoveResultsSearchRightBarButtonItem()
        self.collectionView!.register(MusicAlbumCollectionCell.self,
                                      forCellWithReuseIdentifier: MusicAlbumCollectionCell.reuseIdentifier)
        
    }

    //MARK: - Setup UI Elements
    
    private func setupNavigationItems() {
        
        musicSearchController.searchBar.delegate = self
        navigationItem.searchController = musicSearchController
        navigationItem.leftBarButtonItem = musicAlbumsLabel
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    private func setupRemoveResultsSearchRightBarButtonItem () {
        
        let removeRightBarItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                 target: self,
                                                 action: #selector(removeResultsSearchRightBarButtonTappedAction(sender:)))
        removeRightBarItem.tintColor = .red
        navigationItem.rightBarButtonItem = removeRightBarItem
        
    }
    
    @objc private func removeResultsSearchRightBarButtonTappedAction(sender: UIBarButtonItem) {
       
        if musicAlbumsPage?.resultCount != Int.zero {
            musicAlbumsPage?.results.removeAll()
            collectionView.reloadData()
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.musicAlbumsPage?.results.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicAlbumCollectionCell.reuseIdentifier,
                                                      for: indexPath) as! MusicAlbumCollectionCell
        
        if let musicAlbum = self.musicAlbumsPage?.results[indexPath.row] {
            cell.configureWith(musicAlbum: musicAlbum)
        }
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let musicAlbum = self.musicAlbumsPage?.results[indexPath.row] else { return }
        
        let detailsMusicAlbumTableVC = DetailsMusicAlbumTableViewController()
        detailsMusicAlbumTableVC.musicAlbum = musicAlbum
        navigationController?.show(detailsMusicAlbumTableVC, sender: self)
        
    }
    
    
}

//MARK: - UISearchBarDelegate

extension MusicAlbumsCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchTerm = searchBar.text {
            
            NetworkDataFetcher.shared.fetchMusicAlbumsBy(searchTerm: searchTerm) { [weak self] (result) in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let musicAlbumsPage) where musicAlbumsPage.results.isEmpty:
                    
                    self.musicAlbumsPage?.results.removeAll()
                    self.collectionView.reloadData()
                    self.present(self.alert, animated: true, completion: nil)
                    
                case .success(let musicAlbumsPage):
                    
                    self.musicAlbumsPage = musicAlbumsPage
                    self.collectionView.reloadData()
                    
                case .failure(let error):
                    
                    print(error.rawValue)
                    self.musicAlbumsPage?.results.removeAll()
                    self.collectionView.reloadData()
                    self.alert.title = Constants.alertTitle
                    self.alert.message = Constants.alertMessage
                    self.present(self.alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        collectionView.reloadData()
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension MusicAlbumsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionEdgeInsets.left
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionEdgeInsets.left * CGFloat(numberOfcolumns + 1)
        let availabelWidth = view.frame.width - paddingWidth
        let widthPerItem = availabelWidth / CGFloat(numberOfcolumns)
        return CGSize(width: widthPerItem, height: Constants.heightCell)
        
    }

    
}

//MARK: UIScrolViewDelegate

extension MusicAlbumsCollectionViewController {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        musicSearchController.searchBar.endEditing(true)
    }
    
}
