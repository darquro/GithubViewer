import UIKit
import SwiftUI

public struct SearchTextField: View {

    @Binding var keyword: String
    @Binding var isEditing: Bool
    var onCommit: (() -> Void)? = nil

    public init(keyword: Binding<String>,
                isEditing: Binding<Bool>,
                onCommit: (() -> Void)? = nil) {
        self._keyword = keyword
        self._isEditing = isEditing
        self.onCommit = onCommit
    }

    public var body: some View {
        HStack {
            TextField("keyword",
                      text: $keyword,
                      onEditingChanged: { changed in
                        isEditing = changed
                      }, onCommit: {
                        onCommit?()
                      })
                .padding(.vertical, 8)
                .padding(.horizontal, 32)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
            if isEditing {
                Button("Cancel") {
                    keyword = ""
                    isEditing = false
                    UIApplication.shared.endEditing()
                }
            }
        }
    }
}

struct SearchTextFieldModifier_Preview: PreviewProvider {

    @State static var keyword: String = ""
    @State static var isEditing: Bool = true
    @State static var isNotEditing: Bool = false

    static var previews: some View {
        Group {
            Group {
                SearchTextField(keyword: $keyword, isEditing: $isNotEditing)
                SearchTextField(keyword: $keyword, isEditing: $isEditing)
            }
            .preferredColorScheme(.light)
            Group {
                SearchTextField(keyword: $keyword, isEditing: $isEditing)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}

