import UIKit

extension UICollectionView {
    func dequeueCell<CellClass: UICollectionViewCell>(for indexPath: IndexPath) -> CellClass {
        let identifier = String(describing: CellClass.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CellClass else {
            fatalError("UICollectionViewCell subclass \(CellClass.self) has not been registered with identifier: \(identifier)")
        }
        return cell
    }
    
    func register<CellClass: UICollectionViewCell>(cellClass: CellClass.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
}
