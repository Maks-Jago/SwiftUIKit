//
//  PagerView.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import SwiftUI

public struct PagerView<Page: View>: View {
    @Binding public var pageSelection: Int
    public var pages: [Page]
    private var dispayPagesIndicator: Bool = false
    
    @available(iOS 14, *)
    public init(pageSelection: Binding<Int>? = nil, dispayPagesIndicator: Bool = true, @ViewBuilder content: () -> Page) {
        self._pageSelection = pageSelection ?? .constant(0)
        self.dispayPagesIndicator = dispayPagesIndicator
        self.pages = [content()]
    }
    
    public init(pageSelection: Binding<Int>? = nil, pages: [Page]) {
        self._pageSelection = pageSelection ?? .constant(0)
        self.pages = pages
    }
    
    public var body: some View {
        if #available(iOS 14, *) {
            TabView(selection: $pageSelection) {
                ForEach(0..<pages.count) { index in
                    pages[index]
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: dispayPagesIndicator ? .always : .never))
        } else {
            PageViewController(
                controllers: pages.map {
                    let hostingController = UIHostingController(rootView: $0)
                    hostingController.view.backgroundColor = .clear
                    return hostingController
                },
                currentPage: $pageSelection
            )
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14, *) {
            PagerView {
                Color.red
                Color.blue
                Color.yellow
            }
        } else {
            PagerView(pages: [
                Color.green,
                Color.blue,
                Color.yellow
            ])
        }
    }
}


private struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard !controllers.isEmpty else {
            return
        }
        context.coordinator.parent = self
        
        if controllers.count != pageViewController.viewControllers?.count {
            pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: false)
        }
    }
    
    final class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = parent.controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}
#endif
