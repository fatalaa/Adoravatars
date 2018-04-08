import UIKit

class AvatarCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AvatarCell"

    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 95))
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 95),
            avatarImageView.widthAnchor.constraint(equalToConstant: 95),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        loadingIndicator.stopAnimating()
        nameLabel.text = nil
        avatarImageView.backgroundColor = .gray
    }
    
    private func addSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(loadingIndicator)
    }
    
    func bind(to avatarModel: AvatarModel) {
        nameLabel.text = avatarModel.name
        switch avatarModel.state {
        case .initial:
            loadingIndicator.stopAnimating()
        case .queued( _), .failed(_):
            loadingIndicator.stopAnimating()
        case .done(_):
            loadingIndicator.stopAnimating()
            avatarImageView.image = avatarModel.image
        case .inProgress(_):
            loadingIndicator.startAnimating()
        }
    }
}
