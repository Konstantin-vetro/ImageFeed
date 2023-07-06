//
//  ProfileImageService.swift
//  ImageFeed

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let builder: URLRequestBuilder
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    
    private var task: URLSessionTask?
    private var lastUserName: String?
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfileImageURL(_ username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUserName != username else { return }
        guard let request = makeRequest(username: username) else { return }
        
        task?.cancel()
        lastUserName = username
        
        let urlSession = URLSession.shared
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImageURL, Error>) in
            guard let self else { return }
            switch result {
            case .success(let image):
                let avatar = image.profileImage["small"]
                self.avatarURL = avatar
                completion(.success(avatar ?? ""))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL ?? ""])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastUserName = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(username: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: APIKeys.defaultBaseURL.absoluteString
        )
    }
}
