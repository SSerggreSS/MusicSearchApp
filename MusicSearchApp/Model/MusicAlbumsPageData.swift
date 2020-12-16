//
//  MusicAlbumsPageData .swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 10.12.2020.
//

import Foundation

struct MusicAlbumsPageData: Codable {
    
    let resultCount: Int
    var results: [MusicAlbumData]
    
}

struct MusicAlbumData: Codable {
    
    let artistName: String
    let artworkUrl100: String
    let collectionName: String
    let collectionViewUrl: String
    let primaryGenreName: String
    let releaseDate: String
    let collectionPrice: Double
    let trackCount: Int
    let collectionId: Int
    
}
