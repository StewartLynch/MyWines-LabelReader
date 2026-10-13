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


import SwiftUI

/// Keeps the iPhone Duo's vertical bar off screens where horizontal bars read better:
/// the open inner display, and modal sheets.
private struct HorizontalToolbarsOnly: ViewModifier {
    /// Force horizontal bars regardless of display (used for modal sheets).
    let always: Bool

    // The inner display is regular × regular; the outer display is compact width.
    // Reading the size class avoids any device-identity check.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        // The vertical bar API is new in iOS 27.1; the deployment target is 27.0.
        if #available(iOS 27.1, *) {
            content.toolbarVerticalBehavior(always || horizontalSizeClass == .regular ? .disabled : .automatic)
        } else {
            content
        }
    }
}

extension View {
    /// Opts out of the vertical toolbar on the Duo's inner display, and always when `always` is true.
    func horizontalToolbarsOnly(always: Bool = false) -> some View {
        modifier(HorizontalToolbarsOnly(always: always))
    }
}
