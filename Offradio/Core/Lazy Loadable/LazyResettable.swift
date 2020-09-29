import Foundation

/// Types adopting the `LazyResettable` protocol act as a proxy which lazy loads a represented object. The adopting
/// types also supports resetting the objects. After which the object can be loaded again, resulting in a new instance.
///
/// - seealso: `ResettableLazyLoaded` for a concrete implemeentation.
public protocol LazyResettable: LazyLoadable {
    /// Resets the lazy loaded object.
    ///
    /// The next time the object is accessed a new instance should be returned.
    func reset()
}

/// Class adopting the `LazyResettable` protocol providing a thread-safe resettable lazy loaded proxy. The object is
/// created on first access.
///
/// The implementation attempts to be as resource efficient as possible and will throw away the loader when it’s no
/// longer needed.
///
/// ## Usage
///
/// ```swift
/// class Heavy { /*…*/ }
///
/// let heavy = LazyLoaded { Heavy() }
/// actual(heavy).doThings()
/// ```
///
/// - note: This class is thread-safe.
public final class ResettableLazyLoaded<T>: LazyResettable {
    // MARK: Interacting with The Proxy

    public var object: T {
        loadAndRetrieve()
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        realObject = nil
    }

    public var isLoaded: Bool {
        lock.lock(); defer { lock.unlock() }
        return realObject != nil
    }

    public func loadIfNeeded() {
        _ = object
    }

    // MARK: Creating a Resettable Lazy Loaded Proxy Object

    /// Initialize a `LazyObject` instance with the given _loader_ closure.
    ///
    /// - note: The _loader_ closure will be thrown away as soon as the object has been loaded.
    ///
    /// - parameter loader: The closure which produces the object.
    public init(loader: @escaping () -> T) {
        self.loader = loader
    }

    /// Initialize a `LazyObject` instance with the given _loader_ closure.
    ///
    /// - note: The _loader_ closure will be thrown away as soon as the object has been loaded.
    ///
    /// - parameter loader: The closure which produces the object.
    public init(_ loader: @escaping @autoclosure () -> T) {
        self.loader = loader
    }

    // MARK: Loading the Object

    /// The closure which loads the object.
    private var loader: () -> T

    private let lock = NSLock()
    private var realObject: T?
    private func loadAndRetrieve() -> T {
        lock.lock(); defer { lock.unlock() }

        if let object = realObject { return object }

        let object = loader()
        realObject = object

        return object
    }
}

// MARK: - CustomDebugStringConvertible

extension ResettableLazyLoaded: CustomDebugStringConvertible {
    public var debugDescription: String {
        if isLoaded {
            return "<ResettableLazyLoaded<\(T.self)> loaded = \"\(object)\">"
        } else {
            return "<ResettableLazyLoaded<\(T.self)> not-loaded>"
        }
    }
}
