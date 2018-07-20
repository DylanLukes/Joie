//
//  IRCError.swift
//  Socket
//
//  Created by Dylan Lukes on 3/2/18.
//

import Foundation

public enum IRCError: Error {
    case decodingError(data: Data)
    case malformedMessage(rawMessage: String)
}


