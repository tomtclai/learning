#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin // for arc4random_uniform()
#elseif os(Linux)
import Glibc // for random()
#endif

extension Sequence {
    public func shuffled() -> [Iterator.Element] {
        var contents = Array(self)
        for i in 0 ..< contents.count - 1 {
            #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                // FIXME: This breaks if the array has 2^32 elements or more.
                let j = i + Int(arc4random_uniform(UInt32(contents.count - i)))
            #elseif os(Linux)
                // FIXME: This has modulo bias. Also, `random` should be seeded by calling `srandom`.
                let j = i + random() % (contents.count - i)
            #endif
            contents.swapAt(i, j)
        }
        return contents
    }
}
