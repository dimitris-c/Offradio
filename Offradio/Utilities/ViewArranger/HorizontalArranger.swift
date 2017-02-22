//
//  HorizontalArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

final class HorizontalArranger : ViewArranger {
    
    //Resize resizeable views to fit constraint size
    final func resizeToFit() {
        for object in objects {
            object.resizeWithFixedHeight()
        }
    }
    
    final func arrange(toWidth width:CGFloat? = nil) -> CGFloat {
        
        //If there are any spacer objects, find their width
        if let width = width , spacerObjects.count > 0 {
            var totalWidth = width
            for object in objects {
                if object.type != .Spacer {
                    totalWidth -= object.size.width
                }
            }
            let spacerWidth = totalWidth / CGFloat(spacerObjects.count)
            for spacer in spacerObjects {
                spacer.size.width = spacerWidth
            }
        }
        //Arrange views
        var x:CGFloat = 0
        for object in objects {
            
            object.setAttachedX(x)
            object.setAttachedWidth(object.size.width)
            if object.resizeBoth {
                object.setAttachedHeight(object.size.height)
            }
            
            x += object.size.width
        }
        return x
    }
}