//
//  main.swift
//  Joie
//
//  Created by Dylan Lukes on 6/27/18.
//  Copyright © 2018 Dylan Lukes. All rights reserved.
//

import NIO
import NIOOpenSSL

public class IRCMessageCodec: ByteToMessageDecoder /* MessagetoByteEnxoder */ {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = String
    
    public var cumulationBuffer: ByteBuffer?
    
    public func decode(ctx: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        let view = buffer.readableBytesView
        
        guard let crIndex = view.firstIndex(of: 0x0D) else {
            return .needMoreData
        }
        // Ensure we don't overflow.
        guard view.distance(from: crIndex, to: view.endIndex) > 1 else {
            return .needMoreData
        }
        // Check for LF.
        guard view[view.index(after: crIndex)] == 0x0A else {
            return .needMoreData
        }
        
        let lineLength = view.distance(from: view.startIndex, to: crIndex)
    
        guard (lineLength > 0) else {
            return .needMoreData
        }
        
        guard let line = buffer.readString(length: lineLength) else {
            print("Reading string failed. Not enough data.")
            return .needMoreData
        }
        
        // Discard CRLF.
        buffer.moveReaderIndex(forwardBy: 2)
        
        ctx.fireChannelRead(self.wrapInboundOut(line))
        
        return .continue
    }
}

public class IRCHandler: ChannelInboundHandler {
    public typealias InboundIn = String
    public typealias InboundOut = String
    
    public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let line = self.unwrapInboundIn(data)
        
        print(line)
        ctx.fireChannelRead(self.wrapInboundOut(line))
    }
}

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
    try! group.syncShutdownGracefully()
}

let host = "irc.freenode.net"
let port = 6697

let sslConfig = TLSConfiguration.forClient()
let sslContext = try! SSLContext(configuration: sslConfig)
let sslHandler = try! OpenSSLClientHandler(context: sslContext, serverHostname: host)

let ircCodec = IRCMessageCodec()
let ircHandler = IRCHandler()

let bootstrap = ClientBootstrap(group: group)
    .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .channelInitializer { channel in
        channel.pipeline.addHandlers(sslHandler, ircCodec, ircHandler, first: true)
    }

//    .channelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

let channel = try! bootstrap.connect(host: "irc.freenode.net", port: 6697).wait()

print("Client connected to irc.freenode.net:6697.")

try! channel.closeFuture.wait()
