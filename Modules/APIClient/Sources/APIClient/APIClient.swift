import Foundation
import Combine

public protocol APIRequest {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var decoder: JSONDecoder { get }
}

public enum APIError: Error {
    case invalidURL
    case responseError
    case parseError(Error)
}

extension APIRequest {

    /// Default Decoder
    public var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    /// API Request
    /// - Returns: Publisher
    public func request() -> AnyPublisher<Response, APIError> {
        guard let url = URL(string: path, relativeTo: baseURL),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return URLSession.shared.dataTaskPublisher(for: request)
            .print( "API request:\(url.absoluteURL)" )
            .map { data, urlResponse in data }
            .mapError { _ in APIError.responseError }
            .decode(type: Response.self, decoder: decoder)
            .mapError { error in APIError.parseError(error) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
