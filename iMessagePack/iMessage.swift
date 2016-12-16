//
//  iMessage.swift
//  iMessagePack
//
//  Created by Jonah Witcig on 11/2/16.
//  Copyright © 2016 Jonah Witcig. All rights reserved.
//

import Messages

import JWSwiftTools

infix operator |

@available(iOS 10.0, *)
public protocol iMessageCycle {
    func handleStarterEvent(message: MSMessage, conversation: MSConversation)
}

@available(iOS 10.0, *)
public extension iMessageCycle where Self: MSMessagesAppViewController {
    func didSelect(_ message: MSMessage, conversation: MSConversation) {
        guard message != nil else { return } // potential Xcode bug, message might come thru as nil
        handleStarterEvent(message: message, conversation: conversation)
    }
}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public protocol OrientationManager {
    func requestPresentationStyle(_: MSMessagesAppPresentationStyle)
}

extension MSMessagesAppViewController: OrientationManager { }

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public protocol MessageSender {
    func send(message: MSMessage, layout: MSMessageTemplateLayout, completionHandler handler: ((Error?)->Void)?)
}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public extension MessageSender where Self: MSMessagesAppViewController {
    public func send(message: MSMessage, layout: MSMessageTemplateLayout, completionHandler handler: ((Error?)->Void)?) {
        message.layout = layout
        activeConversation?.insert(message, completionHandler: handler)
    }
}

@available(iOSApplicationExtension 10.0, *)
public extension UIViewController {
    public func present(_ controller: UIViewController) {
        childViewControllers.forEach {
            $0.willMove(toParentViewController: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParentViewController()
        }
    
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    public func throwAway<T: UIViewController>(controller: T) {
        (controller.view.superview != nil) | controller.view.removeFromSuperview
        (controller.parent != nil) | removeFromParentViewController
    }
}
