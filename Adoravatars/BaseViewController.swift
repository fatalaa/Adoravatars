import UIKit

class BaseViewController: UIViewController {
    
    let navigator: Navigator
    
    init(with navigator: Navigator, nibName: String?, bundle: Bundle?) {
        self.navigator = navigator
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
