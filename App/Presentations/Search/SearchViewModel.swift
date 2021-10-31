//
//  SearchViewModel.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/31.
//

import Foundation
import Combine

protocol SearchViewModelProtocol: ViewModelObject where Input: SearchViewModelInput,
                                                        Binding: SearchViewModelBinding,
                                                        Output: SearchViewModelOutput {
}

protocol SearchViewModelInput: InputObject {
    var onCommit: PassthroughSubject<Void, Never> { get }
}

protocol SearchViewModelBinding: BindingObject {
    var keyword: String { get set }
}

protocol SearchViewModelOutput: OutputObject {
    var items: [CardViewEntity] { get set }
}

final class SearchViewModel: SearchViewModelProtocol {

    final class Input: SearchViewModelInput {
        var onCommit: PassthroughSubject<Void, Never> = .init()
    }

    final class Binding: SearchViewModelBinding {
        @Published var keyword: String = ""
    }

    final class Output: SearchViewModelOutput {
        @Published var items: [CardViewEntity] = []
    }

    let input: Input
    var binding: Binding
    var output: Output
    private let usecase: SearchUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(input: Input = Input(),
         binding: Binding = Binding(),
         output: Output = Output(),
         usecase: SearchUseCaseProtocol = SearchUseCase()) {
        self.input = input
        self.binding = binding
        self.output = output
        self.usecase = usecase

        input.onCommit
            .flatMap { _ in self.usecase.fetch(keyword: binding.keyword) }
            .print("onCommit")
            .sink(receiveCompletion: { completion in

            }, receiveValue: { [weak self] value in
                self?.output.items = value
            })
            .store(in: &cancellables)
    }
}
