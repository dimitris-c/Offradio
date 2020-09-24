import Foundation
import RxSwift
import UIKit.UIApplication

public enum AppState: Equatable {
    case unknown
    case launched
    case active
    case inactive
    case background
    case terminated
}

public protocol AppStateReporterType {
    var appState: Observable<AppState> { get }
    var application: UIApplication { get }
}

class AppStateReporter: AppStateReporterType {
    
    internal let application: UIApplication
    
    var appState: Observable<AppState> {
        application.rx.appState
    }
    
    init(application: UIApplication = .shared) {
        self.application = application
    }
    
}
