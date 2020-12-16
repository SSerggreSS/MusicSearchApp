//
//  ItunesConnection.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 09.12.2020.
//


import UIKit

class ItunesConnection: NSObject {
    
   func request(searchTerm: String, completionHandler: @escaping (Result<Data, CIError>) -> (Void)) {
        
        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = createURL(parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTaskWith(request: request, completionHandler: completionHandler)
        task.resume()
    }
                
    private func prepareParameters(searchTerm: String) -> [String: String] {
        var params = [String: String]()
        params["term"] = searchTerm
        params["media"] = "music"
        params["attribute"] = "albumTerm"
        params["limit"] = "20"
        
        return params
    }
    
    private func createURL(parameters: [String: String]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = parameters.map({ (key: String, value: String) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        })
        
        return urlComponents.url!
        }

    private func createDataTaskWith(request: URLRequest,
                                    completionHandler: @escaping (Result<Data, CIError>) -> (Void)) -> URLSessionDataTask {

        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                if let data = data {
                    completionHandler(.success(data))
                } else {
                    completionHandler(.failure(.notDataFromItunesConnection))
                }
            }
        }
        
        return dataTask
    }
    
    func requestPageSongsBy(id: Int, completionHandler: @escaping (Result<Data, CIError>) -> (Void)) {
        
        let urlMusicSongsPageString = "https://itunes.apple.com/lookup?id=\(id)&entity=song"
        guard let urlMusicSongsPage = URL(string: urlMusicSongsPageString) else {
            completionHandler(.failure(.invalidURLForMusicSongsPage))
            return
        }
        var requestMusicSongsPage = URLRequest(url: urlMusicSongsPage)
        requestMusicSongsPage.httpMethod = "get"
        let dataTask = createDataTaskWith(request: requestMusicSongsPage, completionHandler: completionHandler)
       
        dataTask.resume()
        
    }
    
    
}


