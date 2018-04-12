import Foundation

class DownloadModel {
    let name: String
    var states: [RequestState] = []
    
    init(with name: AvatarName) {
        self.name = name
    }
}

extension Array where Element == DownloadModel {
    func indexOfName(name: String) -> Int? {
        return index {
            $0.name.elementsEqual(name)
        }
    }
}
