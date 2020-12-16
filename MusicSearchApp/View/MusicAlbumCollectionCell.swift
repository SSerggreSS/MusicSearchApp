//
//  MusicAlbumCollectionCell.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 11.12.2020.
//

import Foundation
import UIKit
import SDWebImage

class MusicAlbumCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AlbumCell"
    
    //MARK: UI Elements
    
    private let musicAlbumImageView: UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.1
        label.textColor = .white
        
        return label
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAutoLyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        musicAlbumImageView.image = nil
        nameLabel.text = nil
        isSelected = false
    
    }
    
}

//MARK: Setup Auto Layout

extension MusicAlbumCollectionCell {
    
    private func setupAutoLyout() {
        
        setupImageView()
        setupNameLabel()
        
    }
    
    private func setupImageView() {
        
        addSubview(musicAlbumImageView)
        
        NSLayoutConstraint.activate(
            [
                musicAlbumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                musicAlbumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                musicAlbumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                musicAlbumImageView.widthAnchor.constraint(equalToConstant: Constants.widthImageView)
            ]
        )
    }
    
    private func setupNameLabel() {
        
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate(
            [
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: musicAlbumImageView.trailingAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
            ]
        )
    }
}

//MARK: Interface

extension MusicAlbumCollectionCell {
    
    func configureWith(musicAlbum: MusicAlbumData) {
        
        guard let urlImage = URL(string: musicAlbum.artworkUrl100) else { return }
        musicAlbumImageView.sd_setImage(with: urlImage, completed: nil)
        
        nameLabel.text = musicAlbum.collectionName
    }
    
}
