import UIKit

protocol NetworkView: class {
    func updateItem(at indexPath: IndexPath)
}

class NetworkViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let presenter: DownloadsPresenterProtocol
    
    init(with presenter: DownloadsPresenterProtocol, navigator: Navigator) {
        self.presenter = presenter
        super.init(with: navigator, nibName: "NetworkViewController", bundle: .main)
        title = "Downloads"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellClass: UITableViewCell.self)
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(barButtonItemDidTap))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func barButtonItemDidTap() {
        navigator.dismiss(self)
    }
}

extension NetworkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let download = presenter.downloads[section]
        return download.states.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.downloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath)
        return cell
    }
}

extension NetworkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let download = presenter.downloads[section]
        return download.name
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = presenter.downloads[indexPath.section]
        let state = model.states[indexPath.row]
        var labelText: String
        switch state {
        case .initial:
            labelText = "Initial"
        case .queued(let date):
            labelText = "Queued at \(date.timeIntervalSince1970)"
        case .inProgress(let date):
            labelText = "In progress at: \(date.timeIntervalSince1970)"
        case .done(let date):
            labelText = "Done at: \(date.timeIntervalSince1970)"
        case .failed(let date):
            labelText = "Failed at: \(date.timeIntervalSince1970)"
        }
        cell.textLabel?.text = labelText
    }
}

extension NetworkViewController: NetworkView {
    func updateItem(at indexPath: IndexPath) {
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}
