//
//  File.swift
//  
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/03.
//

import Foundation
import SwiftUI

enum Assets {
    enum Colors: String {
        case titleText = "TitleText"
        case bodyText = "BodyText"
        case secondaryText = "SecondaryText"
        case overlayBackground = "OverlayBackground"

        var color: Color {
            Color(rawValue, bundle: .module)
        }
    }
}
