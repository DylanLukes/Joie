import Foundation

public enum IRCMessage {
    typealias Raw = RawIRCMessage
    
    /// 3.1 Connection Registration
    case pass(password: String)
    case nick(nick: String)
    case user(user: String, mode: String, realName: String)
    
    /// 3.2 Channel Operations
    
    /// 3.3 Sending Messages
    case notice(target: String, text: String)
}



public extension IRCMessage {
    static func parse(_ line: String) throws -> IRCMessage? {
        let raw = try IRCMessage.Raw.parse(line)
        
        //        return IRCMessage.pass¿(password: raw[safe: 0])
                
        switch raw.verb {
        case "NOTICE":
            guard let target = raw[safe: 0],
                let text = raw[safe: 1] else {
                    return nil
            }
            return IRCMessage.notice(
                target: target,
                text: text
            )
        default:
            print("Unhandled message.")
        }
        
        return nil
    }
}
