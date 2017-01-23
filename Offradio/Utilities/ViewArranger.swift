//
//  ViewArranger.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

enum SizeObjectType: String {
    case Fixed
    case Flexible
    case Spacer
}

class SizeObject {
    
    var type: SizeObjectType!
    var size: CGSize!
    var view: UIView?
    var resizeBoth: Bool
    
    var attachedSize:CGSize? {
        return view?.bounds.size
    }
    
    func setAttachedX(_ x:CGFloat) {
        view?.frame.origin.x = x
    }
    
    func setAttachedY(_ y:CGFloat) {
        view?.frame.origin.y = y
    }
    
    func setAttachedHeight(_ height:CGFloat) {
        view?.frame.size.height = height
    }
    
    func setAttachedWidth(_ width:CGFloat) {
        view?.frame.size.width = width
    }
    
    func resizeWithFixedWidth() {
        if let attachedSize = self.attachedSize {
            sizeThatFits(CGSize(width: attachedSize.width, height: CGFloat.greatestFiniteMagnitude))
        }
    }
    
    func resizeWithFixedHeight() {
        if let attachedSize = self.attachedSize {
            sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: attachedSize.height))
        }
    }
    
    func sizeThatFits(_ size:CGSize) {
        if type == .Flexible {
            view?.sizeToFit()
            if let size = view?.sizeThatFits(size) {
                self.size = size
            }
        } else if type == .Fixed {
            if let size = attachedSize {
                self.size = size
            }
        }
    }
    
    init(type:SizeObjectType, size:CGSize = CGSize.zero, view:UIView? = nil, resizeBoth:Bool = false) {
        self.type = type
        self.size = size
        self.view = view
        self.resizeBoth = resizeBoth
    }
}

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
