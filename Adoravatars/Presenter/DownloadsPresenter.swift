import Kingfisher
import UIKit

protocol DownloadsPresenterProtocol {
    var downloads: [DownloadModel] { get }
}

class DownloadsPresenter: DownloadsPresenterProtocol {
    var downloads: [DownloadModel] = []
    weak var view: NetworkView?
    
    fileprivate let imageService: ImageServiceProtocol
    fileprivate let avatarNameMapper: AvatarNameMapping
    
    init(with imageService: ImageServiceProtocol, avatarNameMapper: AvatarNameMapping, avatarNames: [AvatarName]) {
        self.imageService = imageService
        self.avatarNameMapper = avatarNameMapper
        downloads = avatarNames.map {
            DownloadModel(with: $0)
        }
    }
    
    deinit {
        self.imageService.remove(delegate: self)
    }
}

extension DownloadsPresenter: ImageServiceDelegate {
    func downloadDidQueue(for url: URL) {
        commonNotifyView(state: .queued(Date()), url: url)
    }
    
    func downloadDidStart(for url: URL) {
        commonNotifyView(state: .inProgress(Date()), url: url)
    }
    
    func downloadDidFinish(for url: URL, error: NSError?, image: Image?) {
        let state: RequestState = error == nil ? .done(Date()) : .failed(Date())
        commonNotifyView(state: state, url: url)
    }
    
    private func commonNotifyView(state: RequestState, url: URL) {
        let avatarName = avatarNameMapper.map(from: url)
        guard let index = downloads.indexOfName(name: avatarName) else {
            return
        }
        let download = downloads[index]
        download.states.append(state)
        let indexPath = IndexPath(row: download.states.count - 1, section: index)
        view?.updateItem(at: indexPath)
    }
}
