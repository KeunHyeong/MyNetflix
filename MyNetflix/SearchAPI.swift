//
//  SearchAPI.swift
//  MyNetflix
//
//  Created by KeunHyeong on 2020/10/18.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class SearchAPI {
    static func search(_ term:String, completion: @escaping ([Movie]) -> Void){
        let session = URLSession(configuration: .default)
        
        let iTunesURL = "https://itunes.apple.com/search?"
        
        var urlComponents = URLComponents(string:iTunesURL)!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil,
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                    completion([])
                    return
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
            
            let movies = SearchAPI.parseInfo(data: resultData)
            completion(movies)
        }
        
        dataTask.resume()
    }
    
    static func parseInfo(data: Data) ->[Movie]{
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
    }
}

struct Response:Codable {
    let resultCount : Int
    let movies :[Movie]
    
    enum CodingKeys: String, CodingKey{
        case resultCount
        case movies = "results"
    }
}

struct Movie: Codable{
    let title:String
    let director:String
    let thumbnailPath:String
    let previewURL:String
    
    enum CodingKeys: String, CodingKey{
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
     }
}
