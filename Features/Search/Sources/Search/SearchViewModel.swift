//
//  SearchViewModel.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/31.
//

import Foundation
import Combine
import ViewComponents

public protocol SearchViewModelProtocol: ViewModelObject where Input: SearchViewModelInput,
                                                        Binding: SearchViewModelBinding,
                                                        Output: SearchViewModelOutput {
}

public protocol SearchViewModelInput: InputObject {
    var onCommit: PassthroughSubject<Void, Never> { get }
}

public protocol SearchViewModelBinding: BindingObject {
    var keyword: String { get set }
}

public protocol SearchViewModelOutput: OutputObject {
    var state: SearchViewModelState { get }
    var items: [CardViewEntity] { get set }
    var isAlertShowing: Bool { get set }
}

public enum SearchViewModelState: String {
    case initialzed, dataLoading, dataFeched, error
}

public final class SearchViewModel: SearchViewModelProtocol {

    final public class Input: SearchViewModelInput {
        public var onCommit: PassthroughSubject<Void, Never> = .init()

        public init () {}
    }

    final public class Binding: SearchViewModelBinding {
        @Published public var keyword: String = ""

        public init () {}
    }

    final public class Output: SearchViewModelOutput {
        public var state: SearchViewModelState = .initialzed
        @Published public var items: [CardViewEntity] = []
        @Published public var isAlertShowing: Bool = false

        public init () {}
    }

    public let input: Input
    public var binding: Binding
    public var output: Output
    private let usecase: SearchUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(input: Input = Input(),
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
