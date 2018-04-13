import UIKit

struct AvatarModel {
    let name: AvatarName
    var image: UIImage?
    var state: RequestState
    
    var isQueued: Bool {
        switch state {
        case .inProgress(_), .queued(_):
            return true
        default:
            return false
        }
    }
}
