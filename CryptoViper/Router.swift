//
//  Router.swift
//  CryptoViper
//
//  Created by Erdem Siyam on 10.04.2022.
//

import Foundation

protocol AnyRouter {
    static func startExecution() -> AnyRouter
}

class CryptoRouter : AnyRouter {
    static func startExecution() -> AnyRouter {
        return CryptoRouter()
    }
}
