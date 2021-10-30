//
//  ViewModelObject.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/25.
//

import Foundation
import SwiftUI
import Combine

protocol ViewModelObject: ObservableObject {

    associatedtype Input: InputObject
    associatedtype Binding: BindingObject
    associatedtype Output: OutputObject

    var input: Input { get }
    var binding: Binding { get set }
    var output: Output { get set }

}

extension ViewModelObject where Binding.ObjectWillChangePublisher == ObservableObjectPublisher, Output.ObjectWillChangePublisher == ObservableObjectPublisher {

    var objectWillChange: AnyPublisher<Void, Never> {
        return Publishers.Merge(binding.objectWillChange, output.objectWillChange).eraseToAnyPublisher()
    }

}

protocol InputObject: AnyObject {
}

protocol BindingObject: ObservableObject {
}

protocol OutputObject: ObservableObject {
}

@propertyWrapper struct BindableObject<T: BindingObject> {

    @dynamicMemberLookup struct Wrapper {
        fileprivate let binding: T
        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value>) -> Binding<Value> {
            return .init(
                get: { self.binding[keyPath: keyPath] },
                set: { self.binding[keyPath: keyPath] = $0 }
            )
        }
    }

    var wrappedValue: T

    var projectedValue: Wrapper {
        return Wrapper(binding: wrappedValue)
    }

}
