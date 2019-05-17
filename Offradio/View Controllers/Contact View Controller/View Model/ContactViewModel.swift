//
//  ContactViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 10/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ContactViewModelInputs {
    func viewDidLoad()
}

protocol ContactViewModelOutputs {
    var data: Driver<[ContactItem]> { get }
}

protocol ContactViewModelType {
    var inputs: ContactViewModelInputs { get }
    var outputs: ContactViewModelOutputs { get }
}

final class ContactViewModel: ContactViewModelType, ContactViewModelInputs, ContactViewModelOutputs {

    let viewDidLoadSubject: PublishSubject<Void> = PublishSubject<Void>()
    let data: Driver<[ContactItem]>

    init() {
        self.data = viewDidLoadSubject
            .asDriver(onErrorDriveWith: .empty())
            .map { _ -> [ContactItem] in
                return ContactItemType.allCases
                    .map { ContactItem(title: $0.title, type: $0) }
            }
    }

    func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }

    internal var inputs: ContactViewModelInputs { return self }
    internal var outputs: ContactViewModelOutputs { return self }
}
