import Foundation
import Combine
import Repositories
import ViewComponents

public protocol HomeUseCaseProtocol {
    func fetch() -> AnyPublisher<[CardViewEntity], Error>
}

public final class HomeUseCase: HomeUseCaseProtocol {

    private let searchRepository: GitHubSearchRepositoryProtocol = GitHubSearchRepository()

    public init() {}

    public func fetch() -> AnyPublisher<[CardViewEntity], Error> {
        searchRepository.fetchSwiftTopicRepos()
            .map { response in
                response.items.map {
                    CardViewEntity(imageURL: $0.owner.avatarUrl,
                                   title: $0.name,
                                   subTitle: $0.owner.login,
                                   language: $0.language,
                                   star: $0.stargazersCount,
                                   description: $0.description,
                                   url: $0.htmlUrl)
                }
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
