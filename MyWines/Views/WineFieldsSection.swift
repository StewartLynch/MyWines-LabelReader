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

/// The text fields in `WineFieldsSection`, used to track keyboard focus.
enum WineField: Hashable {
    case winery, wineName, variety, country, region, vintage, alcohol
}

/// Editable wine details for adding a wine and updating a saved wine.
struct WineFieldsSection: View {
    @Bindable var wine: Wine
    /// Focus is owned by the parent so a single keyboard toolbar can dismiss it.
    @FocusState.Binding var focusedField: WineField?

    var body: some View {
        Section("Wine details") {
            LabeledContent("Winery") {
                TextField("Winery", text: $wine.winery)
                    .focused($focusedField, equals: .winery)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Wine Name") {
                TextField("Wine Name", text: $wine.wineName)
                    .focused($focusedField, equals: .wineName)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Variety") {
                TextField("Variety", text: $wine.variety)
                    .focused($focusedField, equals: .variety)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Country") {
                TextField("Country", text: $wine.country)
                    .focused($focusedField, equals: .country)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Region") {
                TextField("Region", text: $wine.region)
                    .focused($focusedField, equals: .region)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Vintage") {
                TextField("Vintage", value: $wine.vintage, format: .number.grouping(.never))
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .vintage)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Alcohol %") {
                TextField("Alcohol %", value: $wine.alcoholPercentage, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .alcohol)
                    .multilineTextAlignment(.trailing)
            }
        }
        .task {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}
