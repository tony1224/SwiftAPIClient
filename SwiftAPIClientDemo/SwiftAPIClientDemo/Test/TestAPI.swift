//
//  TestAPI.swift
//  SwiftAPIClientDemo
//
//  Created by Jun Morita on 2025/03/26.
//

import Foundation
import SwiftAPIClient

protocol TestAPI: SwiftAPIRequestProtocol {}

extension TestAPI {
    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    var header: HttpHeader? {
        nil
    }
}

struct TestMockAPI: TestAPI {
    var path: String = "posts/1"
    typealias Response = TestResponse
    var method: HTTPMethod = .get
    var httpBody: Encodable?
    var parameters: [String : String]?    
}
