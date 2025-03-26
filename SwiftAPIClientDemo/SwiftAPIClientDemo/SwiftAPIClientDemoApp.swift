//
//  SwiftAPIClientDemoApp.swift
//  SwiftAPIClientDemo
//
//  Created by Jun Morita on 2025/03/26.
//

import SwiftUI
import SwiftAPIClient

@main
struct SwiftAPIClientDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentStore(repository: TestRepository(apiClient: SwiftAPIClient())))
        }
    }
}
