//
//  HomeViewModel.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/25.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: ViewModelObject where Input: HomeViewModelInput,
                                                      Binding: HomeViewModelBinding,
                                                      Output: HomeViewModelOutput {
}

protocol HomeViewModelInput: InputObject {
    var onLoad: PassthroughSubject<Void, Error> { get }
    var onTappedCardView: PassthroughSubject<Int, Never> { get }
}

protocol HomeViewModelBinding: BindingObject {
}

protocol HomeViewModelOutput: OutputObject {
    var state: HomeViewModel.State { get }
    var items: [CardViewEntity] { get set }
    var isAlertShowing: Bool { get set }
}

final class HomeViewModel: HomeViewModelProtocol {

    final class Input: HomeViewModelInput {
        var onLoad = PassthroughSubject<Void, Error>()
        var onTappedCardView = PassthroughSubject<Int, Never>()
    }

    final class Binding: HomeViewModelBinding {}

    final class Output: HomeViewModelOutput {
        var state: HomeViewModel.State = .initialzed
        @Published var items: [CardViewEntity] = []
        @Published var isAlertShowing: Bool = false
    }

    enum State: String {
        case initialzed, dataLoading, dataFeched, error
    }

    let input: Input
    var binding: Binding
    var output: Output
    private let useCase: HomeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(input: Input = Input(),
         binding: Binding = Binding(),
         output: Output = Output(),
         useCase: HomeUseCaseProtocol = HomeUseCase()) {
        self.input = input
        self.binding = binding
        self.output = output
        self.useCase = useCase

        input.onLoad
            .handleEvents(receiveOutput: {  [weak self] value in
                self?.output.state = .dataLoading
            })
            .delay(for: .seconds(1), scheduler: DispatchQueue.global(), options: .none) // for test
            .flatMap { _ in self.useCase.fetch() }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.output.state = .dataFeched
                case .failure(let error):
                    print(error)
                    self?.output.isAlertShowing = true
                    self?.output.state = .error
                }
            }, receiveValue: { [weak self] value in
                self?.output.items = value

            })
            .store(in: &cancellables)

        input.onTappedCardView
            .print("onTappedCardView")
            .sink(receiveValue: { [weak self] index in
                self?.output.items[index].isNavigationPushing = true
            })
            .store(in: &cancellables)
    }
}
