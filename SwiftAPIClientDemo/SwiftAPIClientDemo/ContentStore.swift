//
//  ContentStore.swift
//  SwiftAPIClient
//
//  Created by Jun Morita on 2025/03/26.
//

import Foundation
import Combine

@MainActor
final class ContentStore: ObservableObject {
    @Published private(set) var value: TestResponse = .init(userId: 0, id: 0, title: "title", body: "body")
    
    private let repository: any TestRepositoryProtocol
    
    init(repository: any TestRepositoryProtocol) {
        self.repository = repository
    }

    func fetch() async throws {
        value = try await repository.fetch()
    }

}
