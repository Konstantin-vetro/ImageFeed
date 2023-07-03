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

// MARK: - Response Photo Next Page
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
                    if self.lastLoadedPage == nil {
                        self.lastLoadedPage = 1
                    } else {
                        self.lastLoadedPage! += 1
                    }
                    
                    let newPhotos = photoResults.map { $0.convertToPhoto() }
                    self.photos.append(contentsOf: newPhotos)

                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
// MARK: - Request For Page
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

// MARK: - Response Change Like
extension ImagesListService {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if currentTask != nil {
            currentTask?.cancel()
        }
        
        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike) else {
            print("запрос не удался")
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<PhotoLike, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                        completion(.success(()))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func makeLikeRequest(
        photoId: String,
        isLike: Bool
    ) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            baseURL: APIKeys.defaultBaseURL.absoluteString
        )
    }
}

