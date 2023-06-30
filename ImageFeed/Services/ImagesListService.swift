//
//  ImagesListService.swift
//  ImageFeed
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let builder: URLRequestBuilder
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if currentTask != nil {
            currentTask?.cancel()
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let request = makeRequest(page: nextPage) else {
            print("запрос не удался")
            return
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                        let newPhotos = photoResults.map { Photo(photoResult: $0) }
                        self.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: nil)
                    if self.lastLoadedPage == nil {
                        self.lastLoadedPage = 1
                    } else {
                        self.lastLoadedPage! += 1
                    }
                    
                    self.currentTask = nil
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func makeRequest(page: Int) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        return builder.makeHTTPRequest(
            path: "/photos",
            httpMethod: "GET",
            queryItems: queryItems,
            baseURL: String(describing: APIKeys.defaultBaseURL)
        )
    }
}
