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


import FoundationModels

@Generable
struct ExtractedWineInfo {
    @Guide(description: "The producer: winery, estate, château, domaine or bodega that made the wine. Not the region or the grape.")
    var winery: String

    @Guide(description: "The specific named wine or bottling line printed on the label, separate from the winery and the grape variety, such as 'Vintners Collection', 'Reserve' or 'Estate Grown'. Empty if not printed.")
    var wineName: String

    @Guide(description: "The grape variety or wine type, such as Merlot, Chardonnay, Pinot Noir or Sauvignon Blanc. Empty if not printed.")
    var variety: String

    @Guide(description: "The country of origin, e.g. France, Italy, Canada, USA. Infer from the region or 'Product of' text if not stated directly. Empty if unknown.")
    var country: String

    @Guide(description: "The wine region or appellation, e.g. Napa Valley, Bordeaux, Barossa Valley, Okanagan Valley. Empty if not printed.")
    var region: String

    @Guide(description: "The four digit vintage year printed on the label, or nil if there is none.")
    var vintage: Int?

    @Guide(description: "Alcohol by volume as a number, e.g. 13.5 for '13.5% ALC./VOL.'. nil if not printed.")
    var alcoholPercentage: Double?
}
