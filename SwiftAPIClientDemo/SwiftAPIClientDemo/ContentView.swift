//
//  ContentView.swift
//  SwiftAPIClient
//
//  Created by Jun Morita on 2025/03/26.
//

import SwiftUI

struct ContentView: View {
    @State private var shouldShowAlert: Bool = false
    @State private var errorMessage: String = ""
    @EnvironmentObject var contentStore: ContentStore
    
    var item: TestResponse {
        contentStore.value
    }
    
    func load() async {
        do {
            try await contentStore.fetch()
        } catch {
            shouldShowAlert = true
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("User ID: \(item.userId)")
            Text("ID: \(item.id)")
            Text("Title: \(item.title)")
            Text("Body: \(item.body)")
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .task {
            await load()
        }
        .alert("Error", isPresented: $shouldShowAlert, actions: {}, message: {
            Text(errorMessage)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentStore(repository: PreviewTestRepository()))
    }
}

private struct PreviewTestRepository: TestRepositoryProtocol {
    func fetch() async throws -> TestResponse {
        .init(userId: 1, id: 2, title: "hogehoge", body: "description")
    }
}
