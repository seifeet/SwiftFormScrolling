//
//  DoubleViewBuilder.swift
//  FormScrollingiOS14
//
//  Created by AT on 1/9/21.
//

import Combine
import Foundation
import UIKit

struct DoubleViewBuilder {

    enum ViewType {
        // Welcome alert
        case welcome
        // Hello alert
        case hello
    }

    private var make: (ViewType, UIViewController) -> DoubleViewController

    init(make: @escaping (ViewType, UIViewController) -> DoubleViewController) {
        self.make = make
    }

    func make(alertType: ViewType, presentingViewController: UIViewController)
    -> DoubleViewController {
        return self.make(alertType, presentingViewController)
    }

}

extension DoubleViewBuilder {

    static func live() -> DoubleViewBuilder {
        return DoubleViewBuilder(
            make: { type, parentViewController in
                return make(
                    with: type,
                    parentViewController: parentViewController
                )
            }
        )
    }

    private static func make(
        with type: ViewType,
        parentViewController: UIViewController,
        dismissable: Bool = false
    ) -> DoubleViewController {
        switch type {
        case .welcome:
            return DoubleViewController(
                contentViewController: ContentViewController(),
                bottomSheetViewController: ContainerViewController(),
                bottomSheetConfiguration: .init(
                    height: UIScreen.main.bounds.height * 0.8,
                    initialOffset: 60
                )
            )
        case .hello:
            return DoubleViewController(
                contentViewController: ContentViewController(),
                bottomSheetViewController: ContainerViewController(),
                bottomSheetConfiguration: .init(
                    height: UIScreen.main.bounds.height * 0.8,
                    initialOffset: 60
                )
            )
        }
    }
}

#if DEBUG
extension DoubleViewBuilder {
    static func viewTypeSubjecMock(subject: PassthroughSubject<ViewType, Never>) -> DoubleViewBuilder {
        return DoubleViewBuilder(
            make: { alertType, parentViewController in
                subject.send(alertType)
                return DoubleViewController(
                    contentViewController: ContentViewController(),
                    bottomSheetViewController: ContainerViewController(),
                    bottomSheetConfiguration: .init(
                        height: UIScreen.main.bounds.height * 0.8,
                        initialOffset: 60
                    )
                )
            })
    }
}
#endif
