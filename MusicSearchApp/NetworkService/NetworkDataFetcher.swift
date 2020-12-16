//
//  NetworkDataFetcher.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 10.12.2020.
//

import Foundation

class NetworkDataFetcher {
    
    static let shared = NetworkDataFetcher()
    private init() {}
    
    private let itunesConnection = ItunesConnection()
    
    func fetchMusicAlbumsBy(searchTerm: String, completion: @escaping (Result<MusicAlbumsPageData, CIError>) -> Void) {
        
        itunesConnection.request(searchTerm: searchTerm) { (result) -> (Void) in
            
            switch result {
            case .success(let data):
                guard let musicAlbumsPageData = self.decodeJSON(type: MusicAlbumsPageData.self,
                                                                from: data) else {
                    completion(.failure(.notDataForMusicAlbumsPage))
                    return
                }
                completion(.success(musicAlbumsPageData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        guard let data = from else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("Failed to decode JSON \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchSongsPageBy(id: Int, completionHandler: @escaping (Result<MusicSongsPageData, CIError>) -> (Void))  {
        
        itunesConnection.requestPageSongsBy(id: id) { (result) -> (Void) in
            
            switch result {
            case .success(let data):
                guard var musicSongsPageData = self.decodeJSON(type: MusicSongsPageData.self,
                                                               from: data) else {
                    completionHandler(.failure(.notDataForMusicSongsPage))
                    return
                }
                musicSongsPageData.results.removeFirst()
                completionHandler(.success(musicSongsPageData))
            case .failure(let error):
                print(error.rawValue)
                completionHandler(.failure(.notDataForMusicSongsPage))
            }
        }
    }
    
}

