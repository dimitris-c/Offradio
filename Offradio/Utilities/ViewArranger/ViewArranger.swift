//
//  ViewArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import UIKit

class ViewArranger : NSObject {
    var objects = [SizeObject]()
    var spacerObjects = [SizeObject]()
    var flexibleObjects = [SizeObject]()
    
    final func addObjects(_ objects:[SizeObject]) {
        for object in objects {
            add(object)
        }
    }
    
    final func add(_ object:SizeObject) {
        objects.append(object)
        if object.type == .Spacer {
            spacerObjects.append(object)
        } else if object.type == .Flexible {
            flexibleObjects.append(object)
        }
    }
    
    final func clear() {
        objects.removeAll()
        spacerObjects.removeAll()
        flexibleObjects.removeAll()
    }
}
