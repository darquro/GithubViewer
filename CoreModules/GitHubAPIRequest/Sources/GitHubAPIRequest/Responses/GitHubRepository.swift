import Foundation

public struct GitHubRepository: Decodable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let owner: GitHubRepositoryOwner
    public let htmlUrl: URL
    public let description: String?
    public let language: String?
    public let stargazersCount: Int
}
