import Foundation
import Combine
import ViewComponents

public enum SearchViewModelState: String {
    case initialzed, dataLoading, dataFeched, error
}

public final class SearchViewModel: ViewModelObject {

    final public class Input: InputObject {
        public var onCommit: PassthroughSubject<Void, Never> = .init()

        public init() {}
    }

    final public class Binding: BindingObject {
        @Published public var keyword: String = ""
        @Published public var isAlertShowing: Bool = false
        @Published public var items: [CardViewEntity] = []
        
        public init() {}
    }

    final public class Output: OutputObject {
        @Published public var state: SearchViewModelState = .initialzed

        public init() {}
    }

    public let input: Input
    @BindableObject public var binding: Binding
    public let output: Output
    private let usecase: SearchUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(input: Input = Input(),
                binding: BindableObject<Binding> = .init(.init()),
                output: Output = Output(),
                usecase: SearchUseCaseProtocol = SearchUseCase()) {
        self.input = input
        self._binding = binding
        self.output = output
        self.usecase = usecase

        input.onCommit
            .handleEvents(receiveOutput: {  [weak self] value in
                self?.output.state = .dataLoading
            })
            .flatMap { _ in self.usecase.fetch(keyword: self.binding.keyword) }
            .print("onCommit")
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.binding.isAlertShowing = true
                    self?.output.state = .error
                }
            }, receiveValue: { [weak self] value in
                self?.binding.items = value
                self?.output.state = .dataFeched
            })
            .store(in: &cancellables)
    }
}
