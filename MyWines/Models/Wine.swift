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


import Foundation
import SwiftData

@Model
final class Wine {
    var winery: String
    var wineName: String = ""
    var variety: String
    var country: String = ""
    var region: String = ""
    var vintage: Int?
    var alcoholPercentage: Double?
    var dateAdded: Date
    @Attribute(.externalStorage) var labelImageData: Data?

    init(
        winery: String,
        wineName: String = "",
        variety: String,
        country: String = "",
        region: String = "",
        vintage: Int? = nil,
        alcoholPercentage: Double? = nil,
        labelImageData: Data? = nil,
        dateAdded: Date = .now
    ) {
        self.winery = winery
        self.wineName = wineName
        self.variety = variety
        self.country = country
        self.region = region
        self.vintage = vintage
        self.alcoholPercentage = alcoholPercentage
        self.labelImageData = labelImageData
        self.dateAdded = dateAdded
    }
}
