#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

public let cacheSize: Int? = {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        var result: Int = 0
        var size = MemoryLayout<Int>.size
        let status = sysctlbyname("hw.l1dcachesize", &result, &size, nil, 0)
        guard status != -1 else { return nil }
        return result
    #elseif os(Linux)
        let result = sysconf(Int32(_SC_LEVEL1_DCACHE_SIZE))
        guard result != -1 else { return nil }
        return result
    #else
        return nil // Unknown platform
    #endif
}()
