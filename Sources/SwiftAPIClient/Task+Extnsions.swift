//
//  Task+Extensions.swift
//  SwiftAPIClient
//
//  Created by Jun Morita on 2023/01/28.
//

import Foundation

extension Task where Failure == Error {
    @discardableResult
    public static func retrying(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 3,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            for _ in 0..<maxRetryCount {
                try Task<Never, Never>.checkCancellation()
                
                do {
                    return try await operation()
                } catch {
                    continue
                }
            }
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
