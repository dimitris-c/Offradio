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
    
    var firstLoad: Variable<Bool> = Variable<Bool>(true)
    var refresh: Variable<Bool> = Variable<Bool>(false)
    
    fileprivate var scheduleService: ScheduleService!
    fileprivate var producersService: ProducersBioService!
    
    let navigationTitle: Variable<String> = Variable<String>("Offradio")
    let schedule: Variable<[ScheduleItem]> = Variable<[ScheduleItem]>([])
    let producers: Variable<[Producer]> = Variable<[Producer]>([])
    
    init() {
        scheduleService = ScheduleService()
        producersService = ProducersBioService()
        
        self.fetchSchedule()
            .do(onNext: { [weak self] schedule in
                self?.navigationTitle.value = schedule.dayFormatted
            })
            .map { $0.items }
            .catchErrorJustReturn([])
            .bind(to: schedule)
            .addDisposableTo(disposeBag)
        
        self.refresh.asObservable()
            .filter { $0 }
            .flatMapLatest { [weak self] _ -> Observable<Schedule> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.fetchSchedule()
            }
            .map { $0.items }
            .bind(to: schedule)
            .addDisposableTo(disposeBag)
        
        self.fetchProducers().catchErrorJustReturn([]).bind(to: producers).addDisposableTo(disposeBag)
        
    }
    
    // MARK: Public methods
    
    func getProducerBio(`for` name: String) -> Producer? {
        return self.producers.value.filter { $0.name == name }.first
    }
    
    func getSchedule(at indexPath: IndexPath) -> ScheduleItem {
        return self.schedule.value[indexPath.row]
    }
    
    // MARK: Internal methods

    fileprivate func fetchSchedule() -> Observable<Schedule> {
        return self.scheduleService.rxCall().do(onError: { [weak self] (_) in
            self?.refresh.value = false
            self?.firstLoad.value = false
        }, onCompleted: { [weak self] in
            self?.refresh.value = false
            self?.firstLoad.value = false
        })
    }
    
    fileprivate func fetchProducers() -> Observable<[Producer]> {
        return self.producersService.rxCall()
    }
    
}
