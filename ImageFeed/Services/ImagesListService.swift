//
//  ImagesListService.swift
//  ImageFeed
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let builder: URLRequestBuilder
    private let tokenStorage = OAuth2TokenStorage.shared
    
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
            return
        }
        
        guard let token = tokenStorage.token else {
            print("Не удалось получить токен")
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequest(token: token, page: nextPage) else {
            print("запрос не удался")
            return
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                let newPhotos = photos.map { Photo(photoResult: $0) }
                self.photos.append(contentsOf: newPhotos)
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: nil)
                self.lastLoadedPage! += 1
            case .failure(let error):
                print(error.localizedDescription)
                self.currentTask = nil
                self.lastLoadedPage = nil
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func makeRequest(token: String, page: Int) -> URLRequest? {
//        let queryItems = [
//            URLQueryItem(name: "page", value: "\(page)"),
//            URLQueryItem(name: "per_page", value: "10")
//        ]
        
        return builder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&per_page=10",
            httpMethod: "GET",
//            queryItems: queryItems,
            baseURL: String(describing: APIKeys.defaultBaseURL)
        )
    }
}
