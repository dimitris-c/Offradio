import Foundation

/// Types adopting the `ProxyType` protcol can act as a proxy between the consumer and the actual object.
///
/// Due to limitations in Swift at the moment we cannot make a transparent proxy. Instead consumers have to access the
/// conceret object via the `object` property.
public protocol ProxyType {
    /// The type of the proxied object.
    associatedtype ObjectType

    /// The proxied object.
    var object: ObjectType { get }
}

/// Returns the object proxied by the given _proxy_.
///
/// - parameter proxy: The proxy object.
///
/// - returns: The actual object being proxied.
@inline(__always)
public func actual<T: ProxyType>(_ proxy: T) -> T.ObjectType {
    proxy.object
}
