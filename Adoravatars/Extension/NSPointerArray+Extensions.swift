import Foundation

extension NSPointerArray {
    func add(object: AnyObject?) {
        guard let strong = object else {
            return
        }
        let pointer = Unmanaged.passUnretained(strong).toOpaque()
        addPointer(pointer)
    }
    
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = pointer(at: index) else {
            return nil
        }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
    
    func index(of object: AnyObject) -> Int? {
        guard let index = allObjects.index(where: { ($0 as AnyObject) === object }) else {
            return nil
        }
        return index
    }
    
    func remove(object: AnyObject) {
        guard let index = index(of: object) else {
            return
        }
        removePointer(at: index)
    }
}
