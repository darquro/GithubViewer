//
//  HomeUseCase.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/26.
//

import Foundation
import Combine

protocol HomeUseCaseProtocol {
    func fetch() -> AnyPublisher<[CardViewEntity], Error>
}

final class HomeUseCase: HomeUseCaseProtocol {

    private let searchRepository: GitHubSearchRepositoryProtocol = GitHubSearchRepository()
    private var cancellables = Set<AnyCancellable>()

    func fetch() -> AnyPublisher<[CardViewEntity], Error> {
        Future<[CardViewEntity], Error> { promise in
            self.searchRepository.fetchSwiftTopicRepos()
                .sink(receiveCompletion: { completion in
                    print(completion)
                }, receiveValue: { value in
                    let entities = value.items.map {
                        CardViewEntity(imageURL: URL(string: $0.owner.avatarUrl)!,
                                       title: $0.name,
                                       subTitle: $0.owner.login,
                                       language: $0.language,
                                       star: $0.stargazersCount,
                                       description: $0.description,
                                       url: URL(string: $0.htmlUrl)!)
                    }
                    promise(.success(entities))
                })
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}
