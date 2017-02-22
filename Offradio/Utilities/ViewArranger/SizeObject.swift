//
//  SizeObject.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

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