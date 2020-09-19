//
//  ScheduleViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

final class ScheduleViewModel {
    let disposeBag: DisposeBag = DisposeBag()

    var firstLoad = BehaviorRelay<Bool>(value: true)
    var refresh = BehaviorRelay<Bool>(value: false)

    fileprivate var scheduleService = MoyaProvider<ScheduleService>()
    fileprivate var producersService = MoyaProvider<ProducersBioService>()

    let navigationTitle = BehaviorRelay<String>(value: "Offradio")
    let schedule = BehaviorRelay<[ScheduleItem]>(value: [])
    let producers = BehaviorRelay<[Producer1]>(value: [])

    init() {

        self.fetchSchedule()
            .do(onNext: { [weak self] schedule in
                self?.navigationTitle.accept(schedule.dayFormatted)
            })
            .map { $0.shows }
            .catchErrorJustReturn([])
            .bind(to: schedule)
            .disposed(by: disposeBag)

        self.refresh.asObservable()
            .filter { $0 }
            .flatMapLatest { [weak self] _ -> Observable<Schedule> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.fetchSchedule()
            }
            .map { $0.shows }
            .catchErrorJustReturn([])
            .bind(to: schedule)
            .disposed(by: disposeBag)

        self.fetchProducers().catchErrorJustReturn([]).bind(to: producers).disposed(by: disposeBag)

    }

    // MARK: Public methods

    func getProducerBio(`for` id: String) -> Producer1? {
        return self.producers.value.filter { $0.producerId == Int(id) }.first
    }

    func getSchedule(at indexPath: IndexPath) -> ScheduleItem {
        return self.schedule.value[indexPath.row]
    }

    // MARK: Internal methods

    fileprivate func fetchSchedule() -> Observable<Schedule> {
        return self.scheduleService.rx.request(.schedule)
            .map(Schedule.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .asObservable()
            .do(onError: { [weak self] _ in
                self?.refresh.accept(false)
                self?.firstLoad.accept(false)
            }, onCompleted: { [weak self] in
                self?.refresh.accept(false)
                self?.firstLoad.accept(false)
            })
    }

    fileprivate func fetchProducers() -> Observable<[Producer1]> {
        return self.producersService.rx.request(.producers)
            .map([Producer1].self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: true)
            .asObservable()
    }

}
