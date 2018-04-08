import XCTest

typealias Image = UIImage

class ImageServiceListenerTests: XCTestCase {
    
    func testListenerInvocations() {
        let listener = ImageServiceListenerMock()
        let imageService = ImageServiceMock()
        imageService.add(listener: listener)
        XCTAssert(listener.downloadDidQueueInvokedCount == 0)
        XCTAssert(listener.downloadDidStartInvokedCount == 0)
        XCTAssert(listener.downloadDidFinishInvokedCount == 0)
        guard let url = URL(string: "https://api.adorable.io/100/Panaka.png") else {
            XCTFail("The provided url is not valid")
            return
        }
        imageService.download(image: url)
        XCTAssert(listener.downloadDidQueueInvokedCount == 1)
        XCTAssert(listener.downloadDidStartInvokedCount == 1)
        XCTAssert(listener.downloadDidFinishInvokedCount == 1)
    }
}

class ImageServiceMock: ImageServiceProtocol {
    
    var listeners: [ImageServiceListener] = []
    
    func add(listener: ImageServiceListener) {
        listeners.append(listener)
    }
    
    func remove(listener: ImageServiceListener) {
        if let index = listeners.index(where: { $0 === listener }) {
            listeners.remove(at: index)
        }
    }
    
    func download(image url: URL) {
        listeners.forEach {
            $0.downloadDidQueue(for: url)
        }
        listeners.forEach {
            $0.downloadDidStart(for: url)
        }
        listeners.forEach {
            $0.downloadDidFinish(for: url, error: nil, image: nil)
        }
    }
}

class ImageServiceListenerMock: ImageServiceListener {
    
    var downloadDidQueueInvokedCount = 0
    var downloadDidStartInvokedCount = 0
    var downloadDidFinishInvokedCount = 0
    
    func downloadDidQueue(for url: URL) {
        downloadDidQueueInvokedCount += 1
    }
    
    func downloadDidStart(for url: URL) {
        downloadDidStartInvokedCount += 1
    }
    
    func downloadDidFinish(for url: URL, error: NSError?, image: Image?) {
        downloadDidFinishInvokedCount += 1
    }
}
