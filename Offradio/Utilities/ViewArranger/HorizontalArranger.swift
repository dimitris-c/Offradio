//
//  HorizontalArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import UIKit

struct HorizontalArranger: ViewArranger {

    var objects: [SizeObject]           = []
    var spacerObjects: [SizeObject]     = []
    var flexibleObjects: [SizeObject]   = []

    //Resize resizeable views to fit constraint size
    func resizeToFit() {
        for object in objects {
            object.resizeWithFixedHeight()
        }
    }

    func arrange(to dimension: CGFloat? = nil) -> CGFloat {
        //If there are any spacer objects, find their width
        if let width = dimension, !spacerObjects.isEmpty {
            var totalWidth = width
            for object in objects where object.type != .spacer {
                    totalWidth -= object.size.width
            }
            let spacerWidth = totalWidth / CGFloat(spacerObjects.count)
            for spacer in spacerObjects {
                spacer.size.width = spacerWidth
            }
        }
        //Arrange views
        var x: CGFloat = 0
        for object in objects {

            object.setAttached(x: x)
            object.setAttached(width: object.size.width)
            if object.resizeBoth {
                object.setAttached(height: object.size.height)
            }

            x += object.size.width
        }
        return x
    }
}
