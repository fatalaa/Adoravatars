import Kingfisher

protocol ImageServiceProtocol {
    func add(delegate: ImageServiceDelegate)
    func remove(delegate: ImageServiceDelegate)
    func download(image url: URL)
}

protocol ImageServiceDelegate: class {
    func downloadDidQueue(for url: URL)
    func downloadDidStart(for url: URL)
    func downloadDidFinish(for url: URL, error: NSError?, image: Image?)
}

class ImageService: ImageServiceProtocol {
    
    init(with downloader: ImageDownloader, cache: ImageCache) {
        self.downloader = downloader
        self.cache = cache
        downloadOptions = [.downloader(self.downloader), .forceRefresh]
        self.downloader.delegate = self
    }
    
    var statusMap: [URL: RequestState] = [:]
    
    fileprivate let downloader: ImageDownloader
    fileprivate let cache: ImageCache
    fileprivate var delegates: NSPointerArray = NSPointerArray.weakObjects()
    fileprivate let downloadOptions: KingfisherOptionsInfo
    
    func add(delegate: ImageServiceDelegate) {
        delegates.add(object: delegate)
    }
    
    func remove(delegate: ImageServiceDelegate) {
        delegates.remove(object: delegate)
    }
    
    func download(image url: URL) {
        statusMap[url] = .queued(Date())
        delegates.compact()
        for index in 0..<delegates.count {
            guard let delegate = delegates.object(at: index) as? ImageServiceDelegate else {
                continue
            }
            delegate.downloadDidQueue(for: url)
        }
        downloader.downloadImage(with: url, options: downloadOptions) { [weak self] (image, error, url, data) in
            guard let strongSelf = self, let url = url else {
                return
            }
            if error == nil {
                strongSelf.statusMap[url] = .done(Date())
            } else {
                strongSelf.statusMap[url] = .failed(Date())
            }
            strongSelf.delegates.compact()
            for index in 0..<strongSelf.delegates.count {
                guard let delegate = strongSelf.delegates.object(at: index) as? ImageServiceDelegate else {
                    continue
                }
                delegate.downloadDidFinish(for: url, error: error, image: image)
            }
        }
    }
}

extension ImageService: ImageDownloaderDelegate {
    func imageDownloader(_ downloader: ImageDownloader, willDownloadImageForURL url: URL, with request: URLRequest?) {
        statusMap[url] = .inProgress(Date())
        delegates.compact()
        for index in 0..<delegates.count {
            guard let delegate = delegates.object(at: index) as? ImageServiceDelegate else {
                continue
            }
            delegate.downloadDidStart(for: url)
        }
    }
}
