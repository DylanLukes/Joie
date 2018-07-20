//
//  IRCBot.swift
//  JoieKit
//
//  Created by Dylan Lukes on 3/5/18.
//

import JoieKit

public class Bot: IRCSessionDelegate {
    public func handle(message: IRCMessage) {
        print(message)
    }
}
