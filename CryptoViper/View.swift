//
//  View.swift
//  CryptoViper
//
//  Created by Erdem Siyam on 10.04.2022.
//

import Foundation
import UIKit

// -> Presenter

protocol AnyView {
    var presenter : AnyPresenter? {get set}
    
    func update(with cryptos: [Crypto])
    func update(with error: String)
}

// Ana Sayfa
class CryptoViewController: UIViewController, AnyView,UITableViewDelegate,UITableViewDataSource {
    
    var presenter: AnyPresenter?
    var cryptos: [Crypto]  = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let lblMessage : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Downloading..."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        view.addSubview(tableView)
        view.addSubview(lblMessage)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Subviewler yüklendikten sonra
        tableView.frame = view.bounds // tableView büyüklüğü, ekranın büyüklüğü kadar olur
        lblMessage.frame = CGRect(x:view.frame.width / 2 - 75 ,y:view.frame.height / 2 - 25,width: 150,height: 50)
    }
    
    func update(with cryptos: [Crypto]) {
        DispatchQueue.main.sync {
            self.cryptos = cryptos
            self.lblMessage.isHidden = true
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.sync {
            self.cryptos = []
            self.tableView.isHidden = true
            self.lblMessage.text = error
            self.lblMessage.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        cell.contentConfiguration = content
        cell.backgroundColor = .yellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Satır seçildiğinde
        let detailViewController = DetailViewController()
        detailViewController.selectedCrypto = cryptos[indexPath.row]
        self.present(detailViewController, animated: true)
    }
}

// Detay Sayfası : Aslında bunun için ayrı bir modül açılmalı, Viper yapısına aykırıdır
class DetailViewController : UIViewController {

    var selectedCrypto:Crypto?
    
    private let lblCurrency : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let lblPrice : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        view.addSubview(lblCurrency)
        view.addSubview(lblPrice)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lblCurrency.frame = CGRect(x:view.frame.width / 2 - 75 ,y:view.frame.height / 2 - 25,width: 150,height: 50)
        lblPrice.frame = CGRect(x:view.frame.width / 2 - 75 ,y:view.frame.height / 2 + 25,width: 150,height: 50)
        
        lblCurrency.text = selectedCrypto?.currency ?? ""
        lblPrice.text = selectedCrypto?.price ?? ""
    }
}
