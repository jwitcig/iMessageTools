//
//  Interpreter.swift
//  iMessagePack
//
//  Created by Jonah Witcig on 11/2/16.
//  Copyright © 2016 Jonah Witcig. All rights reserved.
//

import Foundation
import Messages

import SwiftTools

public protocol MessageInterpreter { }
//
//@available(iOS 10.0, *)
//@available(iOSApplicationExtension 10.0, *)
//public struct Reader: MessageInterpreter {
//    public let data: [String: String]
//    
//    public let message: MSMessage
//    
//    public init?(message: MSMessage) {
//        self.message = message
//        guard let url = message.url else { return nil }
//        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
//        guard let queryItems = components?.queryItems else { return nil }
//        
//        self.data = queryItems.reduce([:]) { dict, queryItem in
//            return dict.merged([queryItem.name: queryItem.value!])
//        }
//    }
//    
//    public func value(forKey key: String) -> String {
//        guard let value = (data.filter{$0.key==key}).first?.value else {
//            fatalError()
//        }
//        return value
//    }
//}


@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public protocol MessageReader: MessageInterpreter {
    var data: [String: String] { get set }
    
    var message: MSMessage { get set }
    
    init()
    mutating func isValid(data: [String : String]) -> Bool
}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public extension MessageReader {
    public init?(message: MSMessage) {
        self.init()
        self.message = message
        guard let url = message.url else { return nil }
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let queryItems = components?.queryItems else { return nil }
        
        let data = queryItems.reduce([:]) { dict, queryItem in
            return dict.merged([queryItem.name: queryItem.value!])
        }
        guard isValid(data: data) else { return nil }
        
        self.data = data
    }
}

//@available(iOS 10.0, *)
//@available(iOSApplicationExtension 10.0, *)
//public struct GeneralMessageWriter: MessageInterpreter {
//    public let message: MSMessage
//    public let data: [String: String]
//    
//    public init(data: [String: String], session: MSSession?) {
//        guard let components = NSURLComponents(string: "iMessage") else { fatalError() }
//        components.queryItems = data.map(NSURLQueryItem.init) as [URLQueryItem]
//        self.message = MSMessage(session: session ?? MSSession())
//        self.message.url = components.url
//        self.data = data
//    }
//}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public protocol MessageWriter: MessageInterpreter {
    var message: MSMessage { get set }
    var data: [String: String] { get set }
    
    init()
    
    func isValid(data: [String : String]) -> Bool
}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public extension MessageWriter {
    public init?(data: [String: String], session: MSSession?) {
        self.init()
        
        guard isValid(data: data) else { return nil }

        guard let components = NSURLComponents(string: "iMessage") else { fatalError() }
        components.queryItems = data.map(NSURLQueryItem.init) as [URLQueryItem]
        self.message = MSMessage(session: session ?? MSSession())
        self.message.url = components.url
        self.data = data
    }
}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public struct GeneralMessageReader: MessageReader {
    public var data: [String: String]
    
    public var message: MSMessage
    
    public init() {
        self.message = MSMessage()
        self.data = [:]
    }
    
    public mutating func isValid(data: [String : String]) -> Bool {
        return true
    }
}

@available(iOS 10.0, *)
@available(iOSApplicationExtension 10.0, *)
public protocol MessageValidator {
    var writer: MessageWriter { get }
    
    func messageIsValid() -> Bool
}


@available(iOS 10.0, *)
public protocol Messageable {
    associatedtype MessageWriterType: MessageWriter
    associatedtype MessageLayoutBuilderType: MessageLayoutBuilder
    
    var messageSession: MSSession? { get }
}

@available(iOS 10.0, *)
public protocol MessageLayoutBuilder {
    func generateLayout() -> MSMessageTemplateLayout
}


