//
//  SwiftAPIProtocol.swift
//  SwiftAPIClient
//
//  Created by Jun Morita on 2025/03/26.
//

import Foundation

public protocol SwiftAPIProtocol {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }

    // Not defined in associatedtype because it is also used for GET.
    var httpBody: Encodable? { get }
    
    // Type is optional because some api uses do not require a header specification.
    // ex) Youtube Data API
    var header: HttpHeader? { get }
    
    // static var retryWhenNetworkConnectionLost: ApiRetryStrategy { get }
}

public protocol SwiftAPIRequestProtocol: SwiftAPIProtocol {
    var parameters: [String: String]? { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public class HttpHeader {
    private var header: [String: String]
    
    init(_ header: [String: String]) {
        self.header = header
    }
    
    func addValues(_ values: [String: String]) -> HttpHeader {
        var header = self.header
        
        values.forEach { (key, value) in
            header[key] = value
        }

        return HttpHeader(header)
    }
    
    func values() -> [String:String] {
        return self.header
    }

}

public struct EmptyResponse: Codable {}


//public enum ApiRetryStrategy {
//    case none
//    case retry(maxRetry: Int)
//
//    public static func retryWhenNetworkConnectionLostDefault() -> ApiRetryStrategy {
//        return .retry(maxRetry: 3)
//    }
//
//    public var maxRetry: Int {
//        switch self {
//        case .none:
//            return 0
//        case .retry(let maxRetry):
//            return maxRetry
//        }
//    }
//}

//public enum ApiRequestContentsType: String {
//    case json = "application/json"
//    // Rだとapplication/x-protobufもある
//}

//public enum ApiResponseContentsType: String {
//    case json = "application/json"
//    // Rだとapplication/x-protobufもある
//}

//public enum ApiAcceptType: String {
//    case json = "application/json"
//    // Rだとapplication/x-protobufもある
//}