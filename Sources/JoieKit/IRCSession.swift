import Foundation
import Dispatch
import Socket

public class IRCSession {
    let host: String
    let port: CInt
    
    var socket: Socket!
    
    let readQueue: DispatchQueue
    let writeQueue: DispatchQueue
    
    var source: DispatchSourceRead!
    var buffer: DispatchData
    
    public var delegate: IRCSessionDelegate?
    
    public init(_ host: String, _ port: Int, delegate: IRCSessionDelegate? = nil) {
        self.host = host
        self.port = CInt(port)
        
        self.readQueue = DispatchQueue(label: "joie.irc.read", qos: .userInteractive)
        self.writeQueue = DispatchQueue(label: "joie.irc.write", qos: .userInitiated)
        
        self.buffer = DispatchData.empty
        
        self.delegate = delegate
    }
    
    func readEventHandler() {
        let bytesAvailable = Int(source.data)
        
        let ptr = UnsafeMutablePointer<CChar>.allocate(capacity: Int(bytesAvailable))
        let buf = UnsafeRawBufferPointer(start: ptr, count: bytesAvailable)
        
        let block = DispatchData(bytesNoCopy: buf, deallocator: .custom(readQueue, {
            ptr.deallocate()
        }))
        
        // Read in the available data.
        do {
            let bytesRead = try socket.read(into: ptr, bufSize: bytesAvailable)
            assert(bytesRead == bytesAvailable) // for now?
            buffer.append(block)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Look for 0...n lines.
        repeat {
            do {
                // Scan for '\r\n'.
                guard let cr = buffer.index(of: 0x0D) else { break }
                guard buffer.distance(from: cr, to: buffer.endIndex) > 1 else { break }
                guard buffer[cr + 1] == 0x0A else { break }
                
                // Consume the line, valid UTF-8 or not.
                defer { buffer = buffer.subdata(in: (cr + 2)..<buffer.endIndex) }
                guard let line = String(bytes: buffer[..<cr], encoding: .utf8) else {
                    throw IRCError.decodingError(data: Data(buffer[..<cr]))
                    
                }
                
                // TODO: dispatch to parse queue and do something useful.
                print(line)
                guard let message = try IRCMessage.parse(line) else {
                    fatalError("Message parse failed for some reason. Oops.")
                }
                delegate?.handle(message: message)
            }
            catch IRCError.decodingError(_) {
                print("UTF8 Error: could not decode line. Skipping.")
            }
            catch IRCError.malformedMessage(_) {
                print("Malformed IRC message received. Skipping.")
            }
            catch {
                print("Unexpected Error: \(error.localizedDescription)")
            }
        } while true
    }
    
    public func connect() {
        do {
            self.socket = try Socket.create()
            try socket.connect(to: host, port: port)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Setup read source
        source = DispatchSource.makeReadSource(fileDescriptor: socket.socketfd,
                                               queue: readQueue)
        source.setEventHandler(handler: readEventHandler)
        source.activate()
    }
    
    public func run() -> Never {
        connect()
        dispatchMain()
    }
}

