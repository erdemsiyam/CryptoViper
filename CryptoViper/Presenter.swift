//
//  Presenter.swift
//  CryptoViper
//
//  Created by Erdem Siyam on 10.04.2022.
//

import Foundation

// -> Interactor, Router

enum NetworkError : Error {
    case NetworkFailed
    case ParsingFailed
}

protocol AnyPresenter {
    var router: AnyRouter? {get set}
    var interactor: AnyInteractor? {get set}
    var view: AnyView? {get set}
    
    func interactorDidDownloadCryptos(result: Result<[Crypto],Error>) // Result : başarılı,başarısız parametreleri dönülür
}

class CryptoPresenter : AnyPresenter {
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            // didSet : Atama işlemi yapıldığında
            interactor?.downloadCryptos() // kriptolar çekilir
        }
    }
    var view: AnyView?
    
    func interactorDidDownloadCryptos(result: Result<[Crypto], Error>) {
        switch result {
            case .success(let cryptos):
                view?.update(with: cryptos)
                break
            case .failure(let error):
                view?.update(with: error.localizedDescription)
                break
        }
    }
}
