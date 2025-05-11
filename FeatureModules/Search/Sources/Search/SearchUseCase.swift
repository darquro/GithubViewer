import Foundation
import Combine
import Repositories
import ViewComponents

public protocol SearchUseCaseProtocol {
    func fetch(keyword: String) -> AnyPublisher<[CardViewEntity], Error>
}

public final class SearchUseCase: SearchUseCaseProtocol {

    private let searchRepository: GitHubSearchRepositoryProtocol = GitHubSearchRepository()

    public init() {}

    public func fetch(keyword: String) -> AnyPublisher<[CardViewEntity], Error> {
        searchRepository.fetch(keyword: keyword)
            .map {
                $0.items.map { item in
                    CardViewEntity(imageURL: item.owner.avatarUrl,
                                   title: item.name,
                                   subTitle: item.owner.login,
                                   language: item.language,
                                   star: item.stargazersCount,
                                   description: item.description,
                                   url: item.htmlUrl)
                }
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
