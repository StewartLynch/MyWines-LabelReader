//
//----------------------------------------------
// Original project: MyWines
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.


import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Wine.dateAdded, order: .reverse) private var wines: [Wine]

    @State private var selectedWine: Wine?
    // Created once when "Add Wine" is tapped, so re-rendering this view can't swap in a fresh, empty Wine.
    @State private var newWine: Wine?

    var body: some View {
        NavigationSplitView {
            Group {
                if wines.isEmpty {
                    ContentUnavailableView(
                        "No Wines Yet",
                        systemImage: "wineglass",
                        description: Text("Tap + to add a wine.")
                    )
                } else {
                    List(selection: $selectedWine) {
                        ForEach(wines) { wine in
                            WineRow(wine: wine)
                                .tag(wine)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        if selectedWine == wine { selectedWine = nil }
                                        modelContext.delete(wine)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("My Wines")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Wine", systemImage: "plus") { newWine = Wine(winery: "", variety: "") }
                }
            }
        } detail: {
            if let selectedWine {
                WineDetailView(wine: selectedWine)
            } else {
                ContentUnavailableView(
                    "No Wine Selected",
                    systemImage: "wineglass",
                    description: Text("Select a wine from the list to view its details.")
                )
            }
        }
        .sheet(item: $newWine) { wine in
            WineDetailView(wine: wine, isNew: true)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Wine.self, inMemory: true)
}
