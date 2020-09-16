import Foundation
import RxSwift
import RxCocoa

open class RxApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>, DelegateProxyType, UIApplicationDelegate {

    // Typed parent object.
    public weak private(set) var application: UIApplication?

    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxApplicationDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxApplicationDelegateProxy(application: $0) }
    }

    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?, to object: UIApplication) {
        object.delegate = delegate
    }

    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?, retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }

}
