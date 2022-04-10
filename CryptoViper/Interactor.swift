//
//  Interactor.swift
//  CryptoViper
//
//  Created by Erdem Siyam on 10.04.2022.
//

import Foundation

// -> Presenter

protocol AnyInteractor {
    var presenter: AnyPresenter? {get set}
    
    func downloadCryptos()
}

class CryptoInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func downloadCryptos() {
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json") else  {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidDownloadCryptos(result: .failure(NetworkError.NetworkFailed))
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                self?.presenter?.interactorDidDownloadCryptos(result: .success(cryptos))
                
            } catch {
                self?.presenter?.interactorDidDownloadCryptos(result: .failure(NetworkError.ParsingFailed))
            }
        }
        
        task.resume()
    }
    
}
