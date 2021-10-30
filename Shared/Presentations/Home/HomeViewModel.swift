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

final class HomeViewModel: HomeViewModelProtocol {

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
                self?.output.isProgressViewShowing = true
            })
            .delay(for: .seconds(1), scheduler: DispatchQueue.global(), options: .none) // for test
            .flatMap { _ in self.useCase.fetch() }
            .sink(receiveCompletion: { [weak self] complietion in
                switch complietion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.output.isAlertShowing = true
                }
                print(complietion)
            }, receiveValue: { [weak self] value in
                self?.output.items = value
                self?.output.isProgressViewShowing = false
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

protocol HomeViewModelInput: InputObject {
    var onLoad: PassthroughSubject<Void, Error> { get }
    var onTappedCardView: PassthroughSubject<Int, Never> { get }
}

protocol HomeViewModelBinding: BindingObject {
}

protocol HomeViewModelOutput: OutputObject {
    var items: [CardViewEntity] { get set }
    var isProgressViewShowing: Bool { get set }
    var isAlertShowing: Bool { get set }
}

extension HomeViewModel {

    final class Input: HomeViewModelInput {
        var onLoad = PassthroughSubject<Void, Error>()
        var onTappedCardView = PassthroughSubject<Int, Never>()
    }

    final class Binding: HomeViewModelBinding {}

    final class Output: HomeViewModelOutput {
        @Published var items: [CardViewEntity] = []
        @Published var isProgressViewShowing: Bool = false
        @Published var isAlertShowing: Bool = false
    }
}
