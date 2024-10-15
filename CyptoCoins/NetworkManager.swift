//
//  NetworkManager.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import Foundation
enum HTTPMethod:String, CustomStringConvertible {
    case get, post, patch, put, delete
    var description: String {
        self.rawValue.uppercased()
    }
}

protocol RequestBuilder {
    var path: String { get }
    var method: HTTPMethod { get }
    var timeoutInterval: TimeInterval { get }
    var body: Data? { get }
}

extension RequestBuilder {
    var method: HTTPMethod { .get }
    var timeoutInterval: TimeInterval { 15 }
    var body: Data? { nil }
}

enum NetworkError: Error {
    case requestError
    case responseError

}
final class NetworkManager {
    private let BASE_URL = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io"
    private static let sharedInstance = NetworkManager()
    private let session: URLSession
    class func shared() -> NetworkManager {
        return sharedInstance
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func makeRequest<T: Decodable>(from request: RequestBuilder, decodeType: T.Type) async throws -> T {
         let request = try createURLRequest(from: request)
        let (data, response) = try await session.data(for: request)
        guard !data.isEmpty, response.hasValidStatusCode else {
            throw NetworkError.responseError
        }
        let decodedData = try JSONDecoder().decode(decodeType, from: data)
        return decodedData
    }
}

private extension NetworkManager {
    func createURLRequest(from request: RequestBuilder) throws -> URLRequest {
        guard let url = URL.init(string: BASE_URL + request.path) else {
            throw NetworkError.requestError
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: request.timeoutInterval)
        urlRequest.httpMethod = request.method.description
        urlRequest.httpBody = request.body
        return urlRequest
    }
}

extension URLResponse {
    var hasValidStatusCode: Bool {
        guard let httpResponse = self as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
            return false
        }
        return true
    }
}
