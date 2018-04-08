import Foundation

enum RequestState {
    case initial
    case queued(Date)
    case inProgress(Date)
    case done(Date)
    case failed(Date)
}
