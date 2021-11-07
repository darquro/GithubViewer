//
//  HomeViewModel.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/25.
//

import Foundation
import Combine
import ViewComponents

public protocol HomeViewModelProtocol: ViewModelObject where Input: HomeViewModelInput,
                                                      Binding: HomeViewModelBinding,
                                                      Output: HomeViewModelOutput {
}

public protocol HomeViewModelInput: InputObject {
    typealias onRefreshCompletion = () -> Void
    var onLoad: PassthroughSubject<Void, Never> { get }
    var onTappedCardView: PassthroughSubject<Int, Never> { get }
    var onRefresh: PassthroughSubject<onRefreshCompletion, Never> { get }
}

public protocol HomeViewModelBinding: BindingObject {
}

public protocol HomeViewModelOutput: OutputObject {
    var state: HomeViewModelState { get }
    var items: [CardViewEntity] { get set }
    var isAlertShowing: Bool { get set }
}

public enum HomeViewModelState: String {
    case initialzed, dataLoading, dataFeched, error
}

public final class HomeViewModel: HomeViewModelProtocol {

    final public class Input: HomeViewModelInput {
        public var onLoad: PassthroughSubject<Void, Never> = .init()
        public var onTappedCardView: PassthroughSubject<Int, Never> = .init()
        public var onRefresh: PassthroughSubject<onRefreshCompletion, Never> = .init()

        public init() {}
    }

    final public class Binding: HomeViewModelBinding {
        public init() {}
    }

    final public class Output: HomeViewModelOutput {
        @Published public var state: HomeViewModelState = .initialzed
        @Published public var items: [CardViewEntity] = []
        @Published public var isAlertShowing: Bool = false

        public init() {}
    }

    public let input: Input
    public var binding: Binding
    public var output: Output
    private let useCase: HomeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(input: Input = Input(),
                binding: Binding = Binding(),
                output: Output = Output(),
                useCase: HomeUseCaseProtocol = HomeUseCase()) {
        self.input = input
        self.binding = binding
        self.output = output
        self.useCase = useCase

        input.onLoad
            .print("onLoad")
            .sink(receiveValue: { [weak self] in
                self?.fetch(completion: nil)
            })
            .store(in: &cancellables)

        input.onTappedCardView
            .print("onTappedCardView")
            .sink(receiveValue: { [weak self] index in
                self?.output.items[index].isNavigationPushing = true
            })
            .store(in: &cancellables)

        input.onRefresh
            .print("onRefresh")
            .sink(receiveValue: { [weak self] value in
                self?.fetch(completion: value)
            })
            .store(in: &cancellables)
    }

    private func fetch(completion action: (() -> Void)?) {
        output.state = .dataLoading
        useCase.fetch()
            .delay(for: 2, scheduler: DispatchQueue.main) // delayをかけて、画面の反映が早すぎないようにする
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.output.isAlertShowing = true
                    self?.output.state = .error
                    action?()
                }
            }, receiveValue: { [weak self] value in
                self?.output.items = value
                self?.output.state = .dataFeched
                action?()
            })
            .store(in: &cancellables)
    }
}
