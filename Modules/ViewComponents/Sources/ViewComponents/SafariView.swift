//
//  SafariView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/30.
//

import SwiftUI
import SafariServices

public struct SafariView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = SFSafariViewController

    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
