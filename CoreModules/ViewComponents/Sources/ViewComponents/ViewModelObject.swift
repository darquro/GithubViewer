import Foundation
import SwiftUI
import Combine

public protocol ViewModelObject: ObservableObject {

    associatedtype Input: InputObject
    associatedtype Binding: BindingObject
    associatedtype Output: OutputObject

    var input: Input { get }
    var binding: Binding { get }
    var output: Output { get }

}

public extension ViewModelObject where Binding.ObjectWillChangePublisher == ObservableObjectPublisher, Output.ObjectWillChangePublisher == ObservableObjectPublisher {

    var objectWillChange: AnyPublisher<Void, Never> {
        return Publishers.Merge(binding.objectWillChange, output.objectWillChange).eraseToAnyPublisher()
    }

}

public protocol InputObject: AnyObject {
}

public protocol BindingObject: ObservableObject {
}

public protocol OutputObject: ObservableObject {
}

@propertyWrapper public struct BindableObject<T: BindingObject> {

    @dynamicMemberLookup public struct Wrapper {
        fileprivate let binding: T
        public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value>) -> Binding<Value> {
            return .init(
                get: { self.binding[keyPath: keyPath] },
                set: { self.binding[keyPath: keyPath] = $0 }
            )
        }
    }

    public var wrappedValue: T

    public var projectedValue: Wrapper {
        return Wrapper(binding: wrappedValue)
    }

    public init(_ wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}
