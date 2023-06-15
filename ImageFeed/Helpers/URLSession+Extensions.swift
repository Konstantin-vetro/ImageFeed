//
//  URLSession+Extensions.swift
//  ImageFeed
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {

        
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                if let error = error {
                    completion(.failure(NetworkError.urlRequestError(error)))
                }
                
                if let response = response as? HTTPURLResponse,
                   !(200 ..< 300).contains(response.statusCode) {
                    completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedData = try decoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(NetworkError.urlSessionError))
                    }
                } else { return }
            }
        }
        return task
    }
}

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
