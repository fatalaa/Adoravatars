import UIKit

extension UIViewController {
    var embeddedInNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
