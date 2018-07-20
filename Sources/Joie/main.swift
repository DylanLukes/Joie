//
//  main.swift
//  Joie
//
//  Created by Dylan Lukes on 6/27/18.
//  Copyright © 2018 Dylan Lukes. All rights reserved.
//

import Foundation
import JoieKit
import Darwin

let bot = Bot()
let conn = IRCSession("irc.freenode.net", 6667, delegate: bot)
conn.run()



