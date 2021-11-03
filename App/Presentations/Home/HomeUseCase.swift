//
//  HomeUseCase.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/26.
//

import Foundation
import Combine
import GitHubAPIRequest

protocol HomeUseCaseProtocol {
    func fetch() -> AnyPublisher<[CardViewEntity], Error>
}

final class HomeUseCase: HomeUseCaseProtocol {

    private let searchRepository: GitHubSearchRepositoryProtocol = GitHubSearchRepository()

    func fetch() -> AnyPublisher<[CardViewEntity], Error> {
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
