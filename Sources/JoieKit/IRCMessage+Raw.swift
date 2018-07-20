//
//  RawIRCMessage.swift
//  JoieKit
//
//  Created by Dylan Lukes on 3/4/18.
//

import Foundation

/// A simplified representation used as an intermediate representation.
struct RawIRCMessage {
    let tags: [String]
    let source: String?
    let verb: String
    let parameters: [String]
    
    let hasTrailingParameter: Bool
}

extension RawIRCMessage: Collection {
    typealias Index = Int
    typealias Iterator = Array<String>.Iterator
    
    var startIndex: Int { return parameters.startIndex }
    var endIndex: Int { return parameters.endIndex }
    
    func index(after i: Int) -> Int {
        return parameters.index(after: i)
    }
    
    subscript(index: Int) -> String {
        return parameters[index]
    }
    
    func makeIterator() -> Array<String>.Iterator {
        return parameters.makeIterator()
    }
}

extension RawIRCMessage {
    /// Daniel Oak's Less Wrong IRC Regex is used
    /// as the foundation for parsing IRC messages.
    ///
    /// This regular expression does not handle *all* of IRC
    /// message parsing, just as much as is possible on a first
    /// pass without doing something blatantly wrong.
    ///
    /// - Note: http://danieloaks.net/irc-regex/
    static let RE = try! NSRegularExpression(
        pattern: """
            ^

            (?# 0: Tags Group )
            (?:
                @(?<tags>[^\\r\\n\\ ]*)\\ +
                | ()
            )

            (?# 1: Source Group )
            (?:
                :(?<source>[^\\r\\n\\ ]+)\\ +
                | ()
            )

            (?# 2: Verb Group )
            (?<verb>[^\\r\\n\\ ]+)

            (?# 3: Regular Params Group)
            (?:
                \\ +
                (?<params>
                    [^:\\r\\n\\ ]+[^\\r\\n\\ ]*
                    (?:
                        \\ +
                        [^:\\r\\n\\ ]+[^\\r\\n\\ ]*
                    )*
                )
                | ()
            )?

            (?# 4: Trailing Param Group)
            (?:
                \\ +
                :(?<tparam>[^\\r\\n]*)
                | \\ +()
            )?

            [\\r\\n]*
            $
        """,
        options: [.allowCommentsAndWhitespace])
}

extension RawIRCMessage {
    static func parse(_ line: String) throws -> IRCMessage.Raw {
        guard let m = IRCMessage.Raw.RE.firstMatch(in: line, options: [], range: line.nsRange) else {
            fatalError("bad regex")
        }
        
        let tags = m.range(withName: "tags")
            .of(line)
            .map { $0.components(separatedBy: " ") } ?? []
        
        let source = m.range(withName: "source")
            .of(line)
            .map { String($0) }
        
        let verb = m.range(withName: "verb")
            .of(line)
            .map { String($0) }!
        
        var parameters = m.range(withName: "params")
            .of(line)
            .map { $0.components(separatedBy: " ") } ?? []
        
        let trailingParameter = m.range(withName: "tparam")
            .of(line)
            .map { String($0) }
        
        parameters.append(contentsOf: trailingParameter)
        
        
        let raw = IRCMessage.Raw(
            tags: tags,
            source: source,
            verb: verb,
            parameters: parameters,
            hasTrailingParameter: trailingParameter != nil
        )
        
        return raw
    }
}

fileprivate extension String {
    var nsRange: NSRange {
        return NSRange(self.startIndex..., in: self)
    }
}

fileprivate extension NSRange {
    func over(_ string: String) -> Range<String.Index>? {
        return Range(self, in: string)
    }
    
    func of(_ string: String) -> Substring? {
        return self.over(string).map { string[$0] }
    }
}
