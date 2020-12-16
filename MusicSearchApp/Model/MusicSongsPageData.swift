//
//  MusicSongsPageData.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 15.12.2020.
//

import Foundation

struct MusicSongsPageData: Codable {

    let resultCount: Int
    var results: [MusicSongData]

}

struct MusicSongData: Codable {
    
    let trackName: String?

}

