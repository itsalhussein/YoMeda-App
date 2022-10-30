//
//  CartVC.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 30/10/2022.
//

import UIKit

class CartVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var cartTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var deliveryFeesLabel: UILabel!
    @IBOutlet weak var itemsTotalValue: UILabel!
    @IBOutlet weak var deliveryFeesValue: UILabel!
    @IBOutlet weak var checkoutButton: PMSuperButton!
    @IBOutlet weak var checkoutNoteLabel: UILabel!
    
    //MARK: - Properties
    
    var presenter: CartPresenterProtocol?

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartItemCell.nib, forCellReuseIdentifier: CartItemCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        self.presenter?.interactor?.fetchItems()
    }
    
    @IBAction func languageAction(_ sender: UIButton) {
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        presenter?.back()
    }
}

//MARK: - View Delegate

extension CartVC:CartViewProtocol {
    func update(with items: [CartItemEntity]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateWithError(with error: String) {
        print(error)
    }
}
//MARK: - Table View delegate methods

extension CartVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.getMedsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as! CartItemCell
        let cellData = presenter?.getMedItem(at: indexPath)
        cell.configreCell(cellData: cellData)
        print("CELL DATA ", cellData)
        cell.deleteBTNClicked = {
            print("DELETE CLICKED")
            self.presenter?.deleteMedItem(with: cellData?.itemID ?? "")
        }
        cell.minusBTNClicked = {
            print("MINUS BTN CLICKED")
        }
        cell.plusBTNClicked = {
            print("MINUS BTN CLICKED")
        }
        return cell
    }
    
    
}
//MARK: - Properties

extension CartVC:UISearchBarDelegate{
    
}
