import Foundation
import Combine
import ViewComponents

public enum HomeViewModelState: String {
    case initialzed, dataLoading, dataFeched, error
}

public final class HomeViewModel: ViewModelObject {

    public typealias onRefreshCompletion = () -> Void

    final public class Input: InputObject {
        public var onLoad: PassthroughSubject<Void, Never> = .init()
        public var onTappedCardView: PassthroughSubject<Int, Never> = .init()
        public var onRefresh: PassthroughSubject<onRefreshCompletion, Never> = .init()

        public init() {}
    }

    final public class Binding: BindingObject {
        @Published public var isAlertShowing: Bool = false
        @Published public var items: [CardViewEntity] = []

        public init() {}
    }

    final public class Output: OutputObject {
        @Published public var state: HomeViewModelState = .initialzed

        public init() {}
    }

    public let input: Input
    @BindableObject public var binding: Binding
    public let output: Output

    private let useCase: HomeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(input: Input = .init(),
                binding: BindableObject<Binding> = .init(.init()),
                output: Output = .init(),
                useCase: HomeUseCaseProtocol = HomeUseCase()) {
        self.input = input
        self._binding = binding
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
                self?.binding.items[index].isNavigationPushing = true
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
                    self?.binding.isAlertShowing = true
                    self?.output.state = .error
                    action?()
                }
            }, receiveValue: { [weak self] value in
                self?.binding.items = value
                self?.output.state = .dataFeched
                action?()
            })
            .store(in: &cancellables)
    }
}
