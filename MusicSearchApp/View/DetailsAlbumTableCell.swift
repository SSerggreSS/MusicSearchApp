//
//  DetailsAlbumTableCell.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 13.12.2020.
//

import UIKit
import SDWebImage

class DetailsAlbumTableCell: UITableViewCell {
    
    
    //MARK: - UI Elements
    
    private let musicAlbumImageView: UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        
        return imageView
    }()
    
    private let musicAlbumDetailsLabels: [UILabel] = {
        
        var labels = [UILabel]()
        
        for i in 0...4 {
            
            let label = UILabel(frame: .zero)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            label.tag = i
            
            switch i {
            case 0:
                label.font = UIFont(name: "Arial black", size: 30)
            case 1:
                break
            case 2:
                break
            case 3:
                break
            default:
                break
            }
            
            labels.append(label)
            
        }
        
        return labels
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - Setup Auto Layout

private extension DetailsAlbumTableCell {
    
    private func setupAutoLayout() {
        
        setupAutoLayoutMusicAlbumImageView()
        setupAutoLayoutMusicAlboumPriceLabel()
        setupAutoLayoutMusicAlbomDetails()
        setupAutoLayoutMusicAlbumGenreNameLabel()
        
    }
    
    private func setupAutoLayoutMusicAlbumImageView() {
        
        contentView.addSubview(musicAlbumImageView)
        
        NSLayoutConstraint.activate(
            [
                musicAlbumImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                musicAlbumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                musicAlbumImageView.widthAnchor.constraint(equalToConstant: Constants.widthAlbumImageView),
                musicAlbumImageView.heightAnchor.constraint(equalToConstant: Constants.heightAlbumImageView)
            ]
        )
    }
    
    private func setupAutoLayoutMusicAlboumPriceLabel() {
        
        let priceLabel = musicAlbumDetailsLabels[3]
        
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate(
            [
                priceLabel.leadingAnchor.constraint(equalTo: musicAlbumImageView.trailingAnchor),
                priceLabel.bottomAnchor.constraint(equalTo: musicAlbumImageView.bottomAnchor),
                priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                priceLabel.heightAnchor.constraint(equalToConstant: 20)
            ]
        )
    }
    
    private func setupAutoLayoutMusicAlbomDetails() {
        
        let albumNameLabel = musicAlbumDetailsLabels[0]
        let albumArtistNameLabel = musicAlbumDetailsLabels[1]
        let albumDateRealisedLabel = musicAlbumDetailsLabels[2]
        
        let stackView = UIStackView(arrangedSubviews: [albumNameLabel,
                                                       albumArtistNameLabel,
                                                       albumDateRealisedLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: musicAlbumImageView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
    
    private func setupAutoLayoutMusicAlbumGenreNameLabel() {
        
        let genreLabel = musicAlbumDetailsLabels[4]
        contentView.addSubview(genreLabel)
    
        
        NSLayoutConstraint.activate(
            [
                genreLabel.topAnchor.constraint(equalTo: musicAlbumImageView.topAnchor),
                genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                genreLabel.trailingAnchor.constraint(equalTo: musicAlbumImageView.leadingAnchor),
                genreLabel.heightAnchor.constraint(equalTo: musicAlbumDetailsLabels[3].heightAnchor)
                
            ]
        )
    }
    
}

//MARK: Interface

extension DetailsAlbumTableCell {
    
    func configureDetailsWith(album: MusicAlbumData) {
        
        guard let urlImage = URL(string: album.artworkUrl100) else { return }
        musicAlbumImageView.sd_setImage(with: urlImage, completed: nil)
        
        musicAlbumDetailsLabels[0].text = album.collectionName
        musicAlbumDetailsLabels[1].text = album.artistName
        let dateString = album.releaseDate.dateString()
        musicAlbumDetailsLabels[2].text = dateString
        musicAlbumDetailsLabels[3].text = "\(album.collectionPrice) $"
        musicAlbumDetailsLabels[4].text = album.primaryGenreName
    }
}
