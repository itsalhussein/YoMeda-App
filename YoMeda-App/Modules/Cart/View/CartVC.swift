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
        localization()
        setupUI()
        self.presenter?.interactor?.fetchItems()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
    
    func localization(){
        if Language.currentLanguage() == "ar" {
            backButton.setImage(UIImage(named: "ic_backAR"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "ic_back"), for: .normal)
        }
        cartTitle.text = "Cart".localiz()
        deliveryFeesLabel.text = "deliveryFeesLabel".localiz()
        deliveryFeesValue.text = "deliveryFeesValue".localiz()
        checkoutNoteLabel.text = "checkoutNoteLabel".localiz()
    }
    
    func setupUI(){
        itemsTotalValue.text = "\(UserDefaultsConstants.totalAmount)"
        itemsCountLabel.text = "Items".localiz() + "\(UserDefaultsConstants.cartCount)"
    }
    
    @IBAction func languageAction(_ sender: UIButton) {
        Language.showLanguageActionSheet(self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        presenter?.back()
    }
    @IBAction func searchAction(_ sender: UIButton) {
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
        var cellData = presenter?.getMedItem(at: indexPath)
        cell.deleteBTNClicked = {
            print("DELETE CLICKED")
            UserDefaultsConstants.cartCount -= cellData!.count
            UserDefaultsConstants.totalAmount -= cellData!.price
            self.presenter?.deleteMedItem(with: cellData?.itemID ?? "")
            self.setupUI()
        }
        cell.minusBTNClicked = {
            print("MINUS BTN CLICKED")
            var newCount = cellData!.count
            newCount -= 1
            if (newCount == 0) {
                print("DELETE CLICKED")
                UserDefaultsConstants.cartCount -= cellData!.count
                UserDefaultsConstants.totalAmount -= cellData!.price
                self.presenter?.deleteMedItem(with: cellData?.itemID ?? "")
                self.setupUI()
            } else {
                cell.itemCount.text = "\(newCount)"
                UserDefaultsConstants.cartCount -= 1
                UserDefaultsConstants.totalAmount -= cellData!.price
                NotificationCenter.default
                    .post(name: Notification.Name("showTotalData"), object: nil)
            }
            self.presenter?.updateMedItem(with: cellData?.itemID ?? "", count: cellData?.count ?? 0)
            self.setupUI()
            cellData?.count = newCount
        }
        cell.plusBTNClicked = {
            print("PLUS BTN CLICKED")
            var newCount = cellData!.count
            newCount += 1
            cell.itemCount.text = "\(String(describing: newCount))"
            UserDefaultsConstants.cartCount += 1
            UserDefaultsConstants.totalAmount += cellData!.price
            NotificationCenter.default
                .post(name: Notification.Name("showTotalData"), object: nil)
            self.presenter?.updateMedItem(with: cellData?.itemID ?? "", count: cellData?.count ?? 0)
            self.setupUI()
            cellData?.count = newCount
        }
        cell.configreCell(cellData: cellData)
        print("CELL DATA ", cellData)
        return cell
    }
    
    
}

