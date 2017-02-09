//
//  ScheduleDelegate.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

final class ScheduleDelegate: NSObject, UITableViewDelegate {
    
    weak var dataSource: ScheduleViewModel?
    weak var viewController: UIViewController?
    
    init(withViewController viewController: UIViewController, dataSource source: ScheduleViewModel) {
        super.init()
        self.viewController = viewController
        self.dataSource = source
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dataSource = dataSource else { return }
        
        let item = dataSource.getSchedule(at: indexPath)
        if item.hasBio, let bio = dataSource.getProducerBio(for: item.title) {
            
            self.viewController?.hideLabelOnBackButton()
            let producerBioViewController = ProducersBioViewController(with: bio)
            self.viewController?.navigationController?.pushViewController(producerBioViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Float.deviceValue(iPhone: 60, iPad: 80)
    }
    
}
