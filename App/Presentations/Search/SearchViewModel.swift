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
    var state: SearchViewModelState { get }
    var items: [CardViewEntity] { get set }
    var isAlertShowing: Bool { get set }
}

enum SearchViewModelState: String {
    case initialzed, dataLoading, dataFeched, error
}

final class SearchViewModel: SearchViewModelProtocol {

    final class Input: SearchViewModelInput {
        var onCommit: PassthroughSubject<Void, Never> = .init()
    }

    final class Binding: SearchViewModelBinding {
        @Published var keyword: String = ""
    }

    final class Output: SearchViewModelOutput {
        var state: SearchViewModelState = .initialzed
        @Published var items: [CardViewEntity] = []
        @Published var isAlertShowing: Bool = false
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
            .handleEvents(receiveOutput: {  [weak self] value in
                self?.output.state = .dataLoading
            })
            .flatMap { _ in self.usecase.fetch(keyword: binding.keyword) }
            .print("onCommit")
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.output.isAlertShowing = true
                    self?.output.state = .error
                }
            }, receiveValue: { [weak self] value in
                self?.output.items = value
                self?.output.state = .dataFeched
            })
            .store(in: &cancellables)
    }
}
