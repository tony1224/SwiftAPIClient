//
//  TestResponse.swift
//  SwiftAPIClientDemo
//
//  Created by Jun Morita on 2025/03/26.
//

struct TestResponse: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}
