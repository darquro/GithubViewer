import Foundation
import APIClient

/// GitHub Search API Request
/// Sample URL: https://api.github.com/search/repositories\?q=topic:ios+language:swift+stars:\>\=1000\&sort\=stars\&order\=desc
public struct GitHubSearchAPIRequest: GitHubAPIRequest {
    public typealias Response = GitHubSearchResponse

    public var path: String = "/search/repositories"

    public var queryItems: [URLQueryItem]? {
        var items = [URLQueryItem]([
            .init(name: "sort", value: "stars"),
            .init(name: "order", value: "desc")
        ])

        var params: [String] = []

        if let language = language, !language.isEmpty {
            params.append("language:\(language)")
        }

        if let hasStars = hasStars, hasStars > 0 {
            params.append("stars:>=\(hasStars)")
        }

        if let topic = topic, !topic.isEmpty {
            params.append("topic:\(topic)")
        }

        let joinedParams = params.joined(separator: "+")

        var q = ""
        if let keyword = keyword, !keyword.isEmpty {
            q = "\(keyword)+\(joinedParams)"
        } else {
            q = joinedParams
        }

        items.append(.init(name: "q", value: q))

        return items
    }

    let keyword: String?
    let language: String?
    let hasStars: Int?
    let topic: String?

    public init(keyword: String? = nil,
                language: String? = nil,
                hasStars: Int? = nil,
                topic: String? = nil) {
        self.language = language
        self.keyword = (keyword?.isEmpty ?? true) ? "" : keyword
        self.hasStars = hasStars
        self.topic = (topic?.isEmpty ?? true) ? "" : topic
    }
}
