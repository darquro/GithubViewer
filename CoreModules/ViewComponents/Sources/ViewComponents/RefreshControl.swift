//
//  https://github.com/Geri-Borbas/iOS.Blog.SwiftUI_Pull_to_Refresh/
//

import Foundation
import UIKit
import SwiftUI
import Combine

public final class RefreshControl: ObservableObject {

    let onValueChanged: ((_ refreshControl: UIRefreshControl) -> Void)

    internal init(onValueChanged: @escaping ((UIRefreshControl) -> Void)) {
        self.onValueChanged = onValueChanged
    }

    /// Adds a `UIRefreshControl` to the `UIScrollView` provided.
    func add(to scrollView: UIScrollView) {
        scrollView.refreshControl = UIRefreshControl().withTarget(
            self,
            action: #selector(self.onValueChangedAction),
            for: .valueChanged
        ).testable(as: "RefreshControl")
    }

    @objc private func onValueChangedAction(sender: UIRefreshControl) {
        self.onValueChanged(sender)
    }
}

public extension UIRefreshControl {

    /// Convinience method to assign target action inline.
    func withTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> UIRefreshControl {
        self.addTarget(target, action: action, for: controlEvents)
        return self
    }

    /// Convinience method to match refresh control for UI testing.
    func testable(as id: String) -> UIRefreshControl {
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = id
        return self
    }
}

public struct RefreshControlModifier: ViewModifier {

    @State var geometryReaderFrame: CGRect = .zero
    let refreshControl: RefreshControl

    internal init(onValueChanged: @escaping (UIRefreshControl) -> Void) {
        self.refreshControl = RefreshControl(onValueChanged: onValueChanged)
    }

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    ScrollViewMatcher(
                        onResolve: { scrollView in
                            refreshControl.add(to: scrollView)
                        },
                        geometryReaderFrame: $geometryReaderFrame
                    )
                    .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
                    .onPreferenceChange(FramePreferenceKey.self) { frame in
                        self.geometryReaderFrame = frame
                    }
                }
            )
    }
}

public extension View {

    func refreshable(onValueChanged: @escaping (_ refreshControl: UIRefreshControl) -> Void) -> some View {
        self.modifier(RefreshControlModifier(onValueChanged: onValueChanged))
    }
}

final class ScrollViewMatcher: UIViewControllerRepresentable {

    let onMatch: (UIScrollView) -> Void
    @Binding var geometryReaderFrame: CGRect

    init(onResolve: @escaping (UIScrollView) -> Void, geometryReaderFrame: Binding<CGRect>) {
        self.onMatch = onResolve
        self._geometryReaderFrame = geometryReaderFrame
    }

    func makeUIViewController(context: Context) -> ScrollViewMatcherViewController {
        ScrollViewMatcherViewController(onResolve: onMatch, geometryReaderFrame: geometryReaderFrame)
    }

    func updateUIViewController(_ viewController: ScrollViewMatcherViewController, context: Context) {
        viewController.geometryReaderFrame = geometryReaderFrame
    }
}

class ScrollViewMatcherViewController: UIViewController {

    let onMatch: (UIScrollView) -> Void
    private var scrollView: UIScrollView? {
        didSet {
            if oldValue != scrollView,
               let scrollView = scrollView {
                onMatch(scrollView)
            }
        }
    }

    var geometryReaderFrame: CGRect {
        didSet {
            match()
        }
    }

    init(onResolve: @escaping (UIScrollView) -> Void, geometryReaderFrame: CGRect, debug: Bool = false) {
        self.onMatch = onResolve
        self.geometryReaderFrame = geometryReaderFrame
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(onMatch:) to instantiate ScrollViewMatcherViewController.")
    }

    func match() {
        // matchUsingHierarchy()
        matchUsingGeometry()
    }

    func matchUsingHierarchy() {
        if parent != nil {

            // Lookup view ancestry for any `UIScrollView`.
            view.searchViewAnchestorsFor { (scrollView: UIScrollView) in
                self.scrollView = scrollView
            }
        }
    }

    func matchUsingGeometry() {
        if let parent = parent {
            if let scrollViewsInHierarchy: [UIScrollView] = parent.view.viewsInHierarchy() {

                // Return first match if only a single scroll view is found in the hierarchy.
                if scrollViewsInHierarchy.count == 1,
                   let firstScrollViewInHierarchy = scrollViewsInHierarchy.first {
                    self.scrollView = firstScrollViewInHierarchy

                // Filter by frame origins if multiple matches found.
                } else {
                    if let firstMatchingFrameOrigin = scrollViewsInHierarchy.filter({
                        $0.globalFrame.origin.close(to: geometryReaderFrame.origin)
                    }).first {
                        self.scrollView = firstMatchingFrameOrigin
                    }
                }
            }
        }
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        match()
    }
}

fileprivate extension CGPoint {

    /// Returns `true` if this point is close the other point (considering a ~1 pt tolerance).
    func close(to point: CGPoint) -> Bool {
        let inset = CGFloat(1)
        let rect = CGRect(x: x - inset, y: y - inset, width: inset * 2, height: inset * 2)
        return rect.contains(point)
    }
}

struct FramePreferenceKey: PreferenceKey {

    typealias Value = CGRect
    static var defaultValue = CGRect.zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension UIView {

    /// Returs frame in screen coordinates.
    var globalFrame: CGRect {
        if let window = window {
            return convert(bounds, to: window.screen.coordinateSpace)
        } else {
            return .zero
        }
    }

    /// Returns with all the instances of the given view type in the view hierarchy.
    func viewsInHierarchy<ViewType: UIView>() -> [ViewType]? {
        var views: [ViewType] = []
        viewsInHierarchy(views: &views)
        return views.count > 0 ? views : nil
    }

    fileprivate func viewsInHierarchy<ViewType: UIView>(views: inout [ViewType]) {
        subviews.forEach { eachSubView in
            if let matchingView = eachSubView as? ViewType {
                views.append(matchingView)
            }
            eachSubView.viewsInHierarchy(views: &views)
        }
    }

    /// Search ancestral view hierarcy for the given view type.
    func searchViewAnchestorsFor<ViewType: UIView>(
        _ onViewFound: (ViewType) -> Void
    ) {
        if let matchingView = self.superview as? ViewType {
            onViewFound(matchingView)
        } else {
            superview?.searchViewAnchestorsFor(onViewFound)
        }
    }
}
