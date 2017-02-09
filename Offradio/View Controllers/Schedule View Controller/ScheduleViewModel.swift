//
//  ScheduleViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa

final class ScheduleViewModel {
    let disposeBag: DisposeBag = DisposeBag()
    
    var refresh: Variable<Bool> = Variable<Bool>(false)
    var service: ScheduleService!
    
    var schedule: Observable<[ScheduleItem]>!
//    var producers: [Producer] = []
    
    init() {
        service = ScheduleService()
        
        schedule = fetchItems()
        
        refresh.asObservable().subscribe(onNext: { [weak self] (refresh) in
            if refresh {
                self?.schedule = self?.fetchItems()
            }
        }).addDisposableTo(disposeBag)
     
    }
    
    func fetchItems() -> Observable<[ScheduleItem]> {
        return Observable<[ScheduleItem]>.create({ [weak self] (observer) -> Disposable in
            let request = self?.service.call { (success, data, headers) in
                if success {
                    if let items = data as? [ScheduleItem] {
                        observer.onNext(items)
                        observer.onCompleted()
                    }
                } else {
                    let error = DCError.FoundNil("")
                    observer.onError(error)
                }
            }
            return Disposables.create(with: { [weak request] in request?.cancel() })
        })
    }
    
}

enum DCError: Error {
    case FoundNil(String)
}
