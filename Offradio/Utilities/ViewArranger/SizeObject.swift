//
//  SizeObject.swift
//  Offradio
//
//  Created by Dimitris C. on 20/10/2016.
//  Copyright © 2016 decimal. All rights reserved.
//
import UIKit

public enum SizeObjectType: String {
    case fixed
    case flexible
    case spacer
}

public protocol SizeObjectProtocol {
    var type: SizeObjectType { get set }
    var view: UIView? { get }

    func setAttached(x positionX: CGFloat)
    func setAttached(y positionY: CGFloat)
    func setAttached(height sizeHeight: CGFloat)
    func setAttached(width sizeWidth: CGFloat)
}

extension SizeObjectProtocol {
    func setAttached(x positionX: CGFloat) {
        view?.frame.origin.x = positionX
    }

    func setAttached(y positionY: CGFloat) {
        view?.frame.origin.y = positionY
    }

    func setAttached(height sizeHeight: CGFloat) {
        view?.frame.size.height = sizeHeight
    }

    func setAttached(width sizeWidth: CGFloat) {
        view?.frame.size.width = sizeWidth
    }
}

protocol SizeObjectConvertible {
    func toSizeObject(withType type: SizeObjectType) -> SizeObject
}

extension SizeObjectConvertible where Self: UIView {
    func toSizeObject(withType type: SizeObjectType) -> SizeObject {
        return SizeObject(type: type, view: self, resizeBoth: true)
    }
}

extension UIView: SizeObjectConvertible { }

final class SizeObject: SizeObjectProtocol {

    public var type: SizeObjectType
    public var view: UIView?

    var size: CGSize!
    var resizeBoth: Bool

    var attachedSize: CGSize? {
        return view?.bounds.size
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

    func sizeThatFits(_ size: CGSize) {
        if type == .flexible {
            view?.sizeToFit()
            if let size = view?.sizeThatFits(size) {
                self.size = size
            }
        } else if type == .fixed {
            if let size = attachedSize {
                self.size = size
            }
        }
    }

    init(type: SizeObjectType, size: CGSize = CGSize.zero, view: UIView? = nil, resizeBoth: Bool = false) {
        self.type = type
        self.size = size
        self.view = view
        self.resizeBoth = resizeBoth
    }
}
