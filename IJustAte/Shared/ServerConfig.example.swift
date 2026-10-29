//
//  ServerConfig.example.swift
//  IJustAte
//
//  TEMPLATE for ServerConfig.swift, which is untracked.
//
//  Copy this file to ServerConfig.swift and fill in your own value. That
//  copy is gitignored, so the project will not build until you create it.
//

import Foundation

struct ServerConfig {
    /// Base URL of ijustate-server, with a trailing slash.
    ///
    /// Recommended: expose the server on your tailnet with
    /// `tailscale serve --bg 8000` and use its MagicDNS name over HTTPS, e.g.
    /// "https://my-machine.tailnet-name.ts.net/". Tailscale manages the
    /// certificate, so App Transport Security is satisfied without any
    /// Info.plist exceptions, and the server needs no open ports.
    static let baseURL = "https://my-machine.tailnet-name.ts.net/"
}
