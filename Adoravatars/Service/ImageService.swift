import Kingfisher

protocol ImageServiceProtocol {
    func add(listener: ImageServiceListener)
    func remove(listener: ImageServiceListener)
    func download(image url: URL)
}

protocol ImageServiceListener: class {
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
    fileprivate var listeners: NSPointerArray = NSPointerArray.weakObjects()
    fileprivate let downloadOptions: KingfisherOptionsInfo
    
    func add(listener: ImageServiceListener) {
        listeners.add(object: listener)
    }
    
    func remove(listener: ImageServiceListener) {
        listeners.remove(object: listener)
    }
    
    func download(image url: URL) {
        statusMap[url] = .queued(Date())
        listeners.compact()
        for index in 0..<listeners.count {
            guard let listener = listeners.object(at: index) as? ImageServiceListener else {
                continue
            }
            listener.downloadDidQueue(for: url)
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
            strongSelf.listeners.compact()
            for index in 0..<strongSelf.listeners.count {
                guard let listener = strongSelf.listeners.object(at: index) as? ImageServiceListener else {
                    continue
                }
                listener.downloadDidFinish(for: url, error: error, image: image)
            }
        }
    }
}

extension ImageService: ImageDownloaderDelegate {
    func imageDownloader(_ downloader: ImageDownloader, willDownloadImageForURL url: URL, with request: URLRequest?) {
        statusMap[url] = .inProgress(Date())
        listeners.compact()
        for index in 0..<listeners.count {
            guard let listener = listeners.object(at: index) as? ImageServiceListener else {
                continue
            }
            listener.downloadDidStart(for: url)
        }
    }
}
