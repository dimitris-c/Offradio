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
    var data: Variable<[ContactItem]> { get }

    func getItem(at indexPath: IndexPath) -> ContactItem
}

protocol ContactViewModelType {
    var inputs: ContactViewModelInputs { get }
    var outputs: ContactViewModelOutputs { get }
}

final class ContactViewModel: ContactViewModelType, ContactViewModelInputs, ContactViewModelOutputs {
    fileprivate let disposeBag: DisposeBag = DisposeBag()

    let viewDidLoadSubject: PublishSubject<Void> = PublishSubject<Void>()
    let data: Variable<[ContactItem]> = Variable<[ContactItem]>([])

    init() {
        viewDidLoadSubject.asObservable().map { [weak self] _ -> [ContactItem] in
            guard let sSelf = self else { return [] }
            return sSelf.createData()
        }.bind(to: self.data)
        .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        viewDidLoadSubject.onNext()
    }

    func getItem(at indexPath: IndexPath) -> ContactItem {
        return self.data.value[indexPath.row]
    }

    fileprivate func createData() -> [ContactItem] {
        let facebook = ContactItem(title: "Offradio on Facebook", type: .facebook)
        let twitter  = ContactItem(title: "Offradio on Twitter", type: .twitter)
        let email    = ContactItem(title: "Email Offradio", type: .email)
        let visit    = ContactItem(title: "Visit Offradio.gr", type: .visit)
        return [facebook, twitter, email, visit]
    }

    internal var inputs: ContactViewModelInputs { return self }
    internal var outputs: ContactViewModelOutputs { return self }
}
