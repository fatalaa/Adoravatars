import UIKit

extension UITableView {
    func dequeue<CellClass: UITableViewCell>(for indexPath: IndexPath) -> CellClass {
        let identifier = String(describing: CellClass.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CellClass else {
            fatalError("UICollectionViewCell subclass \(CellClass.self) has not been registered with identifier: \(identifier)")
        }
        return cell
    }
    
    func register<CellClass: UITableViewCell>(cellClass: CellClass.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
}
