import RxSwift
import Kingfisher

extension Reactive where Base == KingfisherManager {
    public func loadImage(with resource: Resource,
                          options: KingfisherOptionsInfo? = nil) -> Single<KFCrossPlatformImage> {
        return Single.create { [base] single in
            let task = base.retrieveImage(with: resource,
                                          options: options) { result in
                                            switch result {
                                            case .success(let value):
                                                single(.success(value.image))
                                            case .failure(let error):
                                                single(.error(error))
                                            }
            }
            
            return Disposables.create { task?.cancel() }
        }
    }
}

extension KingfisherManager: ReactiveCompatible {
    public var rx: Reactive<KingfisherManager> {
        get { return Reactive(self) }
        set { }
    }
}
