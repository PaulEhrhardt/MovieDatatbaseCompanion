//
//  ContentView.swift
//  MovieDatatbaseCompanion
//
//  Created by Paul Ehrhardt on 29/11/24.
//

import SwiftUI
import SwiftData


// MARK: - ContentView -

struct ContentView: View {
    
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var selection: MenuItem? = MenuItem.menuItems.first

    
    // MARK: - Lifecycle
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: .bigSpace) {
                List(selection: $selection) {
                    Section {
                        ForEach(MenuItem.menuItems, id: \.self) { item in
                            NavigationLink(value: item) {
                                Label(item.title, systemImage: item.symbol)
                            }
                        }
                    }
                    .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
                }
                .background(Color(uiColor: UIColor.systemBackground))
                .scrollContentBackground(.hidden)

                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bigSpace)

                Spacer()
            }
            .background(Color(uiColor: UIColor.systemBackground))
        } detail: {
            if let selection = selection {
                NavigationStack {
                    switch selection.type {
                    case .trending:
                        TrendingView()
                    case .search:
                        SearchView()
                    }
                }
                .navigationTitle(selection.title)
                .toolbarTitleDisplayMode(.large)
            } else {
                Text("Please select a menu item.")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}