//
//  ProfileService.swift
//  ImageFeed
//

import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    private let builder: URLRequestBuilder
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let request = makeRequest() else { return }
        
        let urlSession = URLSession.shared
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(ProfileResult: body)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "me",
            httpMethod: "GET",
            baseURL: APIKeys.defaultBaseURL.absoluteString
        )
    }
}
