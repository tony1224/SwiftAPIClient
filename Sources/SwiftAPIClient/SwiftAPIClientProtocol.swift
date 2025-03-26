//
//  APIClientProtocol.swift
//  SwiftAPIClient
//
//  Created by Jun Morita on 2025/03/26.
//

import Foundation

public protocol SwiftAPIClientProtocol {
    func request<T: SwiftAPIRequestProtocol>(api: T) async throws -> T.Response
}

public final class SwiftAPIClient: SwiftAPIClientProtocol {
    public init() {}
    
    public func request<T: SwiftAPIRequestProtocol>(api: T) async throws -> T.Response where T: SwiftAPIRequestProtocol {
        guard let urlRequest = try? createURLRequest(api) else {
            throw SwiftAPIError.url(api.baseURL.appendingPathComponent(api.path))
        }
        do {
            // TODO: retry
            // let result = try await Task.retrying(maxRetryCount: T.retryWhenNetworkConnectionLost.maxRetry) {
            // return try await URLSession.shared.data(for: urlRequest)
            // }.value
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)

            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                throw SwiftAPIError.emptyResponse
            }
            guard 200..<300 ~= urlResponse.statusCode else {
                throw SwiftAPIError.undefined(status: urlResponse.statusCode, data: data)
            }
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch {
            if let urlError = error as? URLError {
                print("URLError Code: \(urlError.code)")
            }
            throw SwiftAPIError.network
        }
    }
    
    private func createURLRequest<T: SwiftAPIRequestProtocol>(_ api: T) throws -> URLRequest {
        let url = api.baseURL.appendingPathComponent(api.path)
        var urlRequest: URLRequest
        
        switch api.method {
        case .get:
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw SwiftAPIError.url(url)
            }
            components.queryItems = api.parameters?.compactMap {
                .init(name: $0.key, value: "\($0.value)")
            }
            guard let tmpRequest = components.url.map({ URLRequest(url: $0)} ) else {
                throw SwiftAPIError.url(url)
            }
            urlRequest = tmpRequest
        case .post:
            urlRequest = URLRequest(url: url)
            if let httpBody = api.httpBody,
               let bodyData = try? JSONEncoder().encode(httpBody) {
                urlRequest.httpBody = bodyData
            }
        }
        urlRequest.httpMethod = api.method.rawValue
        
        if let header = api.header {
            urlRequest.allHTTPHeaderFields = header.values()
        }

        return urlRequest
    }
    
}
