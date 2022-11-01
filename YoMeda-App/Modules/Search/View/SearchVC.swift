//
//  SearchVC.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 27/10/2022.
//

import UIKit
import CoreData

class SearchVC: UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var confirmView: ShadowView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - Properties
    var presenter: SearchPresenterProtocol?

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(SearchItemCell.nib, forCellReuseIdentifier: SearchItemCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localization()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(updateTotal(_:)),
                         name: NSNotification.Name ("showTotalData"),
                         object: nil)
        searchBar.text = ""
    }
    //MARK: - Methods
    
    @objc func updateTotal(_ notification: Notification){
        if UserDefaultsConstants.cartCount == 0 {
            self.confirmView.isHidden = true
        } else {
            self.confirmView.isHidden = false
        }
        self.cartCountLabel.text = "\(UserDefaultsConstants.cartCount)"
        self.totalPriceLabel.text = "\(UserDefaultsConstants.totalAmount)" + " " + "LE".localiz()
    }
    
    func localization(){
        titleLabel.text = "Search".localiz()
        confirmLabel.text = "Confirm".localiz()
        if Language.currentLanguage() == "ar" {
            backButton.setImage(UIImage(named: "ic_backAR"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "ic_back"), for: .normal)
        }
    }
    
    
    //MARK: - Actions
    @IBAction func changeLanguageAction(_ sender: UIButton) {
        Language.showLanguageActionSheet(self)
    }
    @IBAction func backAction(_ sender: UIButton) {
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        self.presenter?.confirmMeds()
    }
}

//MARK: - Search View Protocol Methods
extension SearchVC : SearchViewProtocol {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func update(with items: MedicationItems) {
        self.tableView.reloadData()
    }
    
    func updateWithError(with error: String) {
        print(error)
    }
    
}

//MARK: - Table View Delegate Methods

extension SearchVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.getMedsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.identifier, for: indexPath) as! SearchItemCell
        var modelItemCount = self.presenter?.medsList?[indexPath.row].count ?? 0
        let modelItemprice = self.presenter?.medsList?[indexPath.row].price ?? 0.0
        var itemID = self.presenter?.medsList?[indexPath.row].itemID

        cell.addToCartClosure = {
            self.presenter?.medsList?[indexPath.row].isAdded = true
            modelItemCount += 1
            cell.itemCount.text = "\(modelItemCount)"
            UserDefaultsConstants.cartCount += 1
            UserDefaultsConstants.totalAmount += modelItemprice
            NotificationCenter.default
                .post(name: Notification.Name("showTotalData"), object: nil)
            self.presenter?.medsList?[indexPath.row].count = modelItemCount
        }
        var cellModel = self.presenter?.getMedItem(at: indexPath)
        cell.minusClosure = {
            cellModel?.isAdded = true
            if (modelItemCount == 1){
                cell.addToCartButton.isHidden = false
                cell.plusAndMinusView.isHidden = true
                modelItemCount -= 1
                UserDefaultsConstants.cartCount -= 1
                UserDefaultsConstants.totalAmount -= modelItemprice
            } else if (modelItemCount == 0) {
              cell.addToCartButton.isHidden = false
              cell.plusAndMinusView.isHidden = true
              print("0 Tapped")
            } else {
                modelItemCount -= 1
                cell.itemCount.text = "\(modelItemCount)"
                UserDefaultsConstants.cartCount -= 1
                UserDefaultsConstants.totalAmount -= modelItemprice
            }
            NotificationCenter.default
                .post(name: Notification.Name("showTotalData"), object: nil)
            self.presenter?.medsList?[indexPath.row].count = modelItemCount
            self.presenter?.interactor?.updateCoreDataItem(itemId: itemID ?? "", count: modelItemCount)
        }
        cell.plusClosure = {
            cellModel?.isAdded = true
            modelItemCount += 1
            cell.itemCount.text = "\(modelItemCount)"
            UserDefaultsConstants.cartCount += 1
            UserDefaultsConstants.totalAmount += modelItemprice
            NotificationCenter.default
                .post(name: Notification.Name("showTotalData"), object: nil)
            self.presenter?.medsList?[indexPath.row].count = modelItemCount
            self.presenter?.interactor?.updateCoreDataItem(itemId: itemID ?? "", count: modelItemCount)
        }
        cell.saveItemToCart = {
            self.presenter?.interactor?.saveToCoreData(item: (self.presenter?.medsList?[indexPath.row])!)
        }
        cell.indexPathForCell = indexPath
        cell.configureCell(cellModel)
        return cell
    }
}

//MARK: - Search Bar Delegate Methods

extension SearchVC : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.presenter?.removeMedItems()
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter?.removeMedItems()
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            self.presenter?.removeMedItems()
            self.tableView.reloadData()
            print("nothing to search")
            return
        }
        print(query)
        self.presenter?.startLoading(queryText: query)
    }
}
