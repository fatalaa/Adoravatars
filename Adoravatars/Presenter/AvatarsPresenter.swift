import Foundation
import UIKit

typealias AvatarName = String

protocol AvatarNameMapping {
    func map(from avatarName: AvatarName) -> URL
    func map(from url: URL) -> AvatarName
}

struct AvatarNameMapper: AvatarNameMapping {
    
    private let url: URL
    
    init?(with baseUrl: String, imageSize: Int = 285) {
        var baseUrl = baseUrl
        while baseUrl.hasSuffix("/") {
            baseUrl.removeLast()
        }
        guard let url = URL(string: "\(baseUrl)/\(imageSize)") else {
            return nil
        }
        self.url = url
    }
    
    func map(from url: URL) -> AvatarName {
        guard let avatarName = url.deletingPathExtension().pathComponents.last else {
            fatalError("Bad url passed to the mapper")
        }
        return avatarName
    }
    
    func map(from avatarName: AvatarName) -> URL {
        return url.appendingPathComponent(avatarName).appendingPathExtension("png")
    }
}

protocol AvatarsPresenterProtocol {
    var avatars: [AvatarModel] { get }
    func didLoad()
}

class AvatarsPresenter: AvatarsPresenterProtocol {
    
    var avatars: [AvatarModel] = []
    
    fileprivate let imageService: ImageServiceProtocol
    fileprivate let avatarNameMapper: AvatarNameMapping
    weak var view: AvatarsView?
    
    
    init(with imageService: ImageServiceProtocol, avatarNameMapper: AvatarNameMapping, avatarNames: [AvatarName]) {
        self.imageService = imageService
        self.avatarNameMapper = avatarNameMapper
        avatars = avatarNames.map {
            AvatarModel(name: $0, image: nil, state: .initial)
        }
        self.imageService.add(delegate: self)
    }
    
    func didLoad() {
        avatars.forEach {
            let url = avatarNameMapper.map(from: $0.name)
            imageService.download(image: url)
        }
    }
    
    deinit {
        imageService.remove(delegate: self)
    }
}

extension AvatarsPresenter: ImageServiceDelegate {
    func downloadDidQueue(for url: URL) {
        let avatarName = avatarNameMapper.map(from: url)
        guard let index = avatars.index(where: { $0.name.elementsEqual(avatarName) }) else {
            return
        }
        let updatedAvatar = AvatarModel(name: avatarName, image: nil, state: .queued(Date()))
        avatars[index] = updatedAvatar
        let indexPath = IndexPath(item: index, section: 0)
        view?.updateItem(at: indexPath)
        print("Download queued for url: \(url.absoluteString)\n")
    }
    
    func downloadDidStart(for url: URL) {
        let avatarName = avatarNameMapper.map(from: url)
        guard let index = avatars.index(where: { $0.name.elementsEqual(avatarName) }) else {
            return
        }
        let updatedAvatar = AvatarModel(name: avatarName, image: nil, state: .inProgress(Date()))
        avatars[index] = updatedAvatar
        let indexPath = IndexPath(item: index, section: 0)
        view?.updateItem(at: indexPath)
        print("Download started for url: \(url.absoluteString)\n")
    }
    
    func downloadDidFinish(for url: URL, error: NSError?, image: UIImage?) {
        let avatarName = avatarNameMapper.map(from: url)
        guard let index = avatars.index(where: { $0.name.elementsEqual(avatarName) }) else {
            return
        }
        let updatedAvatar = AvatarModel(name: avatarName, image: image, state: error == nil ? .done(Date()) : .failed(Date()))
        avatars[index] = updatedAvatar
        let indexPath = IndexPath(item: index, section: 0)
        view?.updateItem(at: indexPath)
        print("Download finished for url: \(url.absoluteString)\nError: \(String(describing: error?.localizedDescription))\n")
    }
}
