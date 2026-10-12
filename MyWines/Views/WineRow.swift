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

struct WineRow: View {
    let wine: Wine

    var body: some View {
        HStack(spacing: 12) {
            if let data = wine.labelImageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(.rect(cornerRadius: 8))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(wine.winery).font(.headline)
                if !wine.wineName.isEmpty {
                    Text(wine.wineName).font(.subheadline)
                }
                Text([wine.variety, wine.vintage.flatMap { $0 > 0 ? String($0) : nil }]
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .joined(separator: " · "))
                    .font(.subheadline)
                let origin = [wine.region, wine.country].filter { !$0.isEmpty }.joined(separator: ", ")
                if !origin.isEmpty {
                    Text(origin)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let abv = wine.alcoholPercentage, abv > 0 {
                    Text("\(abv, format: .number)% ABV")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .contentShape(.rect)
    }
}

