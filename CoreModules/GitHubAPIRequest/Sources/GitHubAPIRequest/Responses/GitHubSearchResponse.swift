import Foundation

public struct GitHubSearchResponse: Decodable {
    public let items: [GitHubRepository]
}
