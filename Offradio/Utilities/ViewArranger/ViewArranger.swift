//
//  ViewArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import UIKit

protocol ViewArranger {
    var objects: [SizeObject] { get set }
    var spacerObjects: [SizeObject] { get set }
    var flexibleObjects: [SizeObject] { get set }

    mutating func add(objects array: [SizeObject])
    mutating func add(object item: SizeObject)
    mutating func clear()

    func resizeToFit()
    func arrange(to dimension: CGFloat?) -> CGFloat
}

extension ViewArranger {

    mutating func add(objects array: [SizeObject]) {
        for object in objects {
            add(object: object)
        }
    }

    mutating func add(object item: SizeObject) {
        objects.append(item)
        if item.type == .spacer {
            spacerObjects.append(item)
        } else if item.type == .flexible {
            flexibleObjects.append(item)
        }
    }

    final mutating func clear() {
        objects.removeAll()
        spacerObjects.removeAll()
        flexibleObjects.removeAll()
    }

}
