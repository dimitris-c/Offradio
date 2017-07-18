//
//  UIViewControllerExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    
    public final func hideLabelOnBackButton() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    final func addContainerViewController(_ content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = self.view.bounds
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    final func removeContainerViewController(_ content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    class func className() -> String {
        return String(describing: self)
    }
    
    class func createFromStoryboard() -> Self {
        return _createFromStoryboard()
    }
    
    private class func _createFromStoryboard<T>() -> T {
        Log.debug("Creating \(className())")
        let storyboard = UIStoryboard(name: className(), bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
}


extension Reactive where Base: UIViewController {
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }
    
}
