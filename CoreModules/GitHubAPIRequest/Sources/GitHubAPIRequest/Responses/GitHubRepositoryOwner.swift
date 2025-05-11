import Foundation

public struct GitHubRepositoryOwner: Decodable {
    public let id: Int
    public let login: String
    public let avatarUrl: URL
}
