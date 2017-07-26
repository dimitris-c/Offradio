//
//  VerticalArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

struct VerticalArranger: ViewArranger {

    var objects: [SizeObject]           = []
    var spacerObjects: [SizeObject]     = []
    var flexibleObjects: [SizeObject]   = []

    //Resize resizeable views to fit constraint size
    func resizeToFit() {
        for object in objects {
            object.resizeWithFixedWidth()
        }
    }

    @discardableResult
    func arrange(to dimension: CGFloat? = nil) -> CGFloat {
        //If there are any spacer objects, find their height
        if let height = dimension, !spacerObjects.isEmpty {
            var totalHeight = height
            for object in objects where object.type != .spacer {
                totalHeight -= object.size.height
            }
            let spacerHeight = totalHeight / CGFloat(spacerObjects.count)
            for spacer in spacerObjects {
                spacer.size.height = spacerHeight
            }
        }
        //Arrange views
        var y: CGFloat = 0
        for object in objects {
            object.setAttached(y: y)
            if object.type == .flexible {
                object.setAttached(height: object.size.height)
                if object.resizeBoth {
                    object.setAttached(width: object.size.width)
                }
            }
            y += object.size.height
        }
        return y
    }
}
