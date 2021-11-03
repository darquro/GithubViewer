import Foundation
import APIClient

public protocol GitHubAPIRequest: APIRequest {
}

public extension GitHubAPIRequest {
    var baseURL: URL { URL(string: "https://api.github.com")! }
}
