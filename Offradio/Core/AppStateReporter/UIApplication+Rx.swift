import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIApplication {

    public var delegate: DelegateProxy<UIApplication, UIApplicationDelegate> {
        return RxApplicationDelegateProxy.proxy(for: base)
    }
    
    public var didFinishLaunching: ControlEvent<AppState> {
        let source = delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidFinishLaunching(_:)))
            .map { _ in AppState.launched }
        return ControlEvent<AppState>(events: source)
    }

    public var willEnterForeground: ControlEvent<AppState> {
        let source = delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
            .map { _ in AppState.inactive }
        return ControlEvent<AppState>(events: source)
    }

    public var didBecomeActive: ControlEvent<AppState> {
        let source = delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
            .map { _ in return AppState.active }
        return ControlEvent<AppState>(events: source)
    }

    public var didEnterBackground: ControlEvent<AppState> {
        let source = delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
            .map { _ in return AppState.background }
        return ControlEvent<AppState>(events: source)
    }

    public var willResignActive: ControlEvent<AppState> {
        let source = delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map { _ in return AppState.inactive }
        return ControlEvent<AppState>(events: source)
    }

    public var willTerminate: ControlEvent<AppState> {
        let source = delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
            .map { _ in return AppState.terminated }
        return ControlEvent<AppState>(events: source)
    }

    public var appState: Observable<AppState> {
        return Observable.of(
            didBecomeActive,
            willResignActive,
            willEnterForeground,
            didEnterBackground,
            willTerminate
            )
            .merge()
            .share(replay: 1, scope: .whileConnected)
    }
    
    public var didOpenApp: Observable<Void> {
        return didFinishLaunching.asObservable().map { _ in () }
    }
}
