//
//  TestRepositoryProtocol.swift
//  SwiftAPIClientDemo
//
//  Created by Jun Morita on 2025/03/26.
//

import SwiftAPIClient

protocol TestRepositoryProtocol {
    func fetch() async throws -> TestResponse
}

class TestRepository: TestRepositoryProtocol {
    private let apiClient: SwiftAPIClientProtocol
    
    init(apiClient: SwiftAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetch() async throws -> TestResponse {
        try await apiClient.request(api: TestMockAPI())
    }
}
