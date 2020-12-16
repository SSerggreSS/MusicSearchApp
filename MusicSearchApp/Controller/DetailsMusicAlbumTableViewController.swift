//
//  DetailsMusicAlbumTableViewController.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 13.12.2020.
//

import UIKit

enum TypeSection: Int {
    
    case detailsMusicAlbum
    case listMusicSongs
    
}

private let reuseIdentifier = "reuseIdentifier"

class DetailsMusicAlbumTableViewController: UITableViewController {
    
    var musicAlbum: MusicAlbumData! = nil
    
    var musicSongsPage: MusicSongsPageData! = nil {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Life Cycle View
    
    override func loadView() {
        super.loadView()
        
        NetworkDataFetcher.shared.fetchSongsPageBy(id: self.musicAlbum.collectionId) { [weak self] (result) -> (Void) in
            guard let self = self else { return }
            
            switch result {
            case .success(let musicSongsPageData):
                self.musicSongsPage = musicSongsPageData
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let musicSongsPage = musicSongsPage else { return 0 }
        
        var numberOfRows = 0
        
        let typeSection = TypeSection(rawValue: section) ?? TypeSection.detailsMusicAlbum
        switch typeSection {
        case .detailsMusicAlbum:
            numberOfRows = 1
        case .listMusicSongs:
            numberOfRows = musicSongsPage.results.count
        }
        
        return numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        let typeSection = TypeSection(rawValue: indexPath.section) ?? .detailsMusicAlbum
        switch typeSection {
        
        case .detailsMusicAlbum:
            
            let cell = DetailsAlbumTableCell()
            cell.configureDetailsWith(album: musicAlbum)
            return cell
            
        case .listMusicSongs:
            
            let song = musicSongsPage.results[indexPath.row]
            cell.backgroundColor = .black
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = "\(indexPath.row + 1)🎶 - \(song.trackName ?? "")"
            
        }
        
        return cell
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(Constants.labelFontSize)
        label.textColor = .black
        label.backgroundColor = .darkGray
        label.textAlignment = .center
        
        let typeSection = TypeSection(rawValue: section) ?? .detailsMusicAlbum
        switch typeSection {
        case .detailsMusicAlbum:
            label.text = Constants.titleForHeaderDetailsMusicAlbumSection
        case .listMusicSongs:
            label.text = Constants.titleForHeaderDetailsMusicSong
        }
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.heightForHeaderInSection
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var heightForRow: CGFloat = 0
        
        let typeSection = TypeSection(rawValue: indexPath.section) ?? .detailsMusicAlbum
        switch typeSection {
        case .detailsMusicAlbum:
            heightForRow = Constants.heightForRowDetailsMusicAlbum
        case .listMusicSongs:
            heightForRow = Constants.heightForRowMusicSong
        }
        
        return heightForRow
    }
    
}
