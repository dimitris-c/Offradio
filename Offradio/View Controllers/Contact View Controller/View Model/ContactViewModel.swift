//
//  ContactViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 10/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift

final class ContactViewModel {
    fileprivate let disposeBag: DisposeBag = DisposeBag()

    let data: Variable<[ContactItem]> = Variable<[ContactItem]>([])

    init() {

        self.data.value = createData()

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

}
