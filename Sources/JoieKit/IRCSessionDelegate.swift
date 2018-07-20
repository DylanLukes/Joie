//
//  IRCConnectionDelegate.swift
//  JoieKit
//
//  Created by Dylan Lukes on 3/5/18.
//

import Foundation

public protocol IRCSessionDelegate {
    func handle(message: IRCMessage)
}
