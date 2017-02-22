//
//  VerticalArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

final class VerticalArranger : ViewArranger {
    
    //Resize resizeable views to fit constraint size
    final func resizeToFit() {
        for object in objects {
            object.resizeWithFixedWidth()
        }
    }
    
    @discardableResult
    final func arrange(toHeight height:CGFloat? = nil) -> CGFloat {
        
        //If there are any spacer objects, find their height
        if let height = height , spacerObjects.count > 0 {
            var totalHeight = height
            for object in objects {
                if object.type != .Spacer {
                    totalHeight -= object.size.height
                }
            }
            let spacerHeight = totalHeight / CGFloat(spacerObjects.count)
            for spacer in spacerObjects {
                spacer.size.height = spacerHeight
            }
        }
        //Arrange views
        var y:CGFloat = 0
        for object in objects {
            object.setAttachedY(y)
            if object.type == .Flexible {
                object.setAttachedHeight(object.size.height)
                if object.resizeBoth {
                    object.setAttachedWidth(object.size.width)
                }
            }
            y += object.size.height
        }
        return y
    }
}
