//
//  CardViewEntity.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import Foundation

public struct CardViewEntity: Identifiable {

    // MARK: Data
    public let id: UUID = .init()
    public let imageURL: URL
    public let title: String
    public let subTitle: String
    public let language: String?
    public let star: Int
    public let description: String?
    public let url: URL

    // MARK: User Action
    public var isNavigationPushing: Bool = false

    public init(imageURL: URL,
                title: String,
                subTitle: String,
                language: String?,
                star: Int,
                description: String?,
                url: URL) {
        self.imageURL = imageURL
        self.title = title
        self.subTitle = subTitle
        self.language = language
        self.star = star
        self.description = description
        self.url = url
    }
}
