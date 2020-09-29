/// Types adopting the `LazyLoadable` protocol act as a proxy which lazy loads a represented object.
///
/// Once the object has been loaded it will stay loaded until de-initialized.
///
/// - seealso: `LazyLoaded` for a concrete implementation.
/// - seealso: `LazyResettable` for an extension of the type which can be reset and the object then re-loaded.
public protocol LazyLoadable: ProxyType {
    // MARK: Interacting with The Proxy

    /// Whether the object has been loaded or not.
    ///
    /// - note: Calling this property is safe and will not trigger a load the object.
    var isLoaded: Bool { get }

    /// Load the proxied object if needed.
    ///
    /// - note: Normally you don’t need to use this function. Accessing the the proxied using `actual(_: ProxyType)`
    ///         will trigger a load for you. However if you need the object to exist for some performance critical it
    ///         might be beneficial to load it beforehand.
    func loadIfNeeded()
}

/// Class representing a lazy loaded object which isn’t created until it’s accessed for the first time.
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
public final class LazyLoaded<T>: LazyLoadable {
    /// Type of a closure which loads an instance of the associated object type _ObjectType_.
    private typealias Loader = () -> T
    /// The closure which loads the object.
    private var loader: Loader?

    public lazy var object: T = {
        let object = self.loader!()
        self.loader = nil
        return object
    }()

    public var isLoaded: Bool {
        loader == nil
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
}

// MARK: - CustomDebugStringConvertible

extension LazyLoaded: CustomDebugStringConvertible {
    public var debugDescription: String {
        if isLoaded {
            return "<LazyLoaded<\(T.self)> loaded = \"\(object)\">"
        } else {
            return "<LazyLoaded<\(T.self)> not-loaded>"
        }
    }
}
