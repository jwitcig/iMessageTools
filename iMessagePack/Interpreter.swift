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

protocol MessageInterpreter { }

@available(iOSApplicationExtension 10.0, *)
public struct Reader: MessageInterpreter {
    public let data: [String: String]
    
    public let message: MSMessage
    
    public init?(message: MSMessage) {
        self.message = message
        guard let url = message.url else { return nil }
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let queryItems = components?.queryItems else { return nil }
        
        self.data = queryItems.reduce([:]) { dict, queryItem in
            return dict.merged([queryItem.name: queryItem.value!])
        }
    }
    
    public func value(forKey key: String) -> String {
        guard let value = (data.filter{$0.key==key}).first?.value else {
            fatalError()
        }
        return value
    }
}

@available(iOSApplicationExtension 10.0, *)
public struct MessageWriter: MessageInterpreter {
    public let message: MSMessage
    
    public init(data: [String: String], session: MSSession?) {
        guard let components = NSURLComponents(string: "iMessage") else { fatalError() }
        components.queryItems = data.map(NSURLQueryItem.init) as [URLQueryItem]
        self.message = MSMessage(session: session ?? MSSession())
        self.message.url = components.url
    }
}

@available(iOSApplicationExtension 10.0, *)
public protocol MessageSendable {
    static func parse(reader: Reader) -> Self?
}
