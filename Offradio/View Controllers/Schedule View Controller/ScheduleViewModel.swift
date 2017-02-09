//
//  ScheduleViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire

final class ScheduleViewModel {
    let disposeBag: DisposeBag = DisposeBag()
    
    var refresh: Variable<Bool> = Variable<Bool>(false)
    var scheduleService: ScheduleService!
    var producersService: ProducersBioService!
    
    var schedule: Variable<[ScheduleItem]> = Variable<[ScheduleItem]>([])
    var producers: Variable<[Producer]> = Variable<[Producer]>([])
    
    init() {
        scheduleService = ScheduleService()
        producersService = ProducersBioService()
                
        self.fetchSchedule().catchErrorJustReturn([]).bindTo(schedule).addDisposableTo(disposeBag)
        
        self.refresh.asObservable().filter { $0 }.flatMapLatest { _ -> Observable<[ScheduleItem]> in
            return self.fetchSchedule()
        }.bindTo(schedule).addDisposableTo(disposeBag)
        
        self.fetchProducers().catchErrorJustReturn([]).bindTo(producers).addDisposableTo(disposeBag)
        
    }
    
    func getProducerBio(`for` name: String) -> Producer? {
        return self.producers.value.filter { $0.name == name }.first
    }
    
    func getSchedule(at indexPath: IndexPath) -> ScheduleItem {
        return self.schedule.value[indexPath.row]
    }
    
    fileprivate func fetchSchedule() -> Observable<[ScheduleItem]> {
        return self.scheduleService.rxCall().do(onError: { [weak self] (_) in
            self?.refresh.value = false
        }, onCompleted: { [weak self] in
            self?.refresh.value = false
        })
    }
    
    fileprivate func fetchProducers() -> Observable<[Producer]> {
        return self.producersService.rxCall()
    }

    /// DEPRECATED
    fileprivate func fetchItems() -> Observable<[ScheduleItem]> {
        return Observable<[ScheduleItem]>.create({ [weak self] (observer) -> Disposable in
            let request = self?.scheduleService.call { (success, data, headers) in
                if success {
                    if let items = data as? [ScheduleItem] {
                        observer.onNext(items)
                        observer.onCompleted()
                        self?.refresh.value = false
                    }
                } else {
                    let error = APIError.error(data as? String)
                    observer.onError(error)
                }
            }
            return Disposables.create(with: { [weak request] in request?.cancel() })
        })
    }
    
}
