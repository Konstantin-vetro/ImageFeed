//
//  URLRequest+Extensions.swift
//  ImageFeed
//

import Foundation

final class URLRequestBuilder {
    static let shared = URLRequestBuilder()
    
    private let storage: OAuth2TokenStorage
    
    init(storage: OAuth2TokenStorage = .shared) {
        self.storage = storage
    }
    
    func makeHTTPRequest(
        path: String,
        httpMethod: String,
        queryItems: [URLQueryItem]? = nil,
        baseURL: String
    ) -> URLRequest? {
        
        guard
            let url = URL(string: String(describing: baseURL)),
            var baseUrl = URL(string: path, relativeTo: url)
        else { return nil }
        
        baseUrl.appendQueryItems(queryItems: queryItems)
        var request = URLRequest(url: baseUrl)
        request.httpMethod = httpMethod
        
        if let token = storage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

extension URL {
    mutating func appendQueryItems(queryItems: [URLQueryItem]?) {
        guard let queryItems = queryItems,
              var urlComponents = URLComponents(string: absoluteString) else { return }
        
        var currentQueryItems = urlComponents.queryItems ?? []
        currentQueryItems.append(contentsOf: queryItems)
        urlComponents.queryItems = currentQueryItems
        
        if let newUrl = urlComponents.url {
            self = newUrl
        }
    }
}
