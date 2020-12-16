//
//  ConnectionError.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 15.12.2020.
//

import Foundation

enum CIError: String, Error {
    
    case invalidURLForMusicAlbumsPage = "URL address invalid for Music Albums Page"
    case notDataForMusicAlbumsPage    = "Not data for Music Albums Page"
    case invalidURLForMusicSongsPage  = "URL address invalid for Music Songs Page"
    case notDataForMusicSongsPage     = "Not data for Music Songs Page"
    case notDataFromItunesConnection  = "Not data from Itunes Server"
    
}
