import UIKit

protocol Navigation {
    func present(_ viewController: UIViewController, from: UIViewController)
    func dismiss(_ viewController: UIViewController)
}

struct Navigator: Navigation {
    func present(_ viewController: UIViewController, from: UIViewController) {
        if viewController.navigationController == nil {
            from.present(viewController.embeddedInNavigationController, animated: true, completion: nil)
        } else {
            from.present(viewController, animated: true, completion: nil)
        }
    }
    
    func dismiss(_ viewController: UIViewController) {
        guard let from = viewController.parent else {
            fatalError("The presented viewController does not seem to have a parent.")
        }
        from.dismiss(animated: true, completion: nil)
    }
}
