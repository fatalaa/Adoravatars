import UIKit

protocol AvatarsView: class {
    func updateItem(at indexPath: IndexPath)
}

class AvatarsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let presenter: AvatarsPresenterProtocol
    
    init(with presenter: AvatarsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "AvatarsViewController", bundle: .main)
        title = "Adoravatars"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(cellClass: AvatarCell.self)
        collectionView.allowsSelection = false
        collectionView.dragInteractionEnabled = false
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 115, height: 115)
        collectionView.collectionViewLayout = flowLayout
        presenter.didLoad()
    }
}

extension AvatarsViewController: AvatarsView {
    func updateItem(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

extension AvatarsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AvatarCell = collectionView.dequeueCell(for: indexPath)
        return cell
    }
}

extension AvatarsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? AvatarCell else {
            return
        }
        let model = presenter.avatars[indexPath.item]
        cell.bind(to: model)
    }
}
