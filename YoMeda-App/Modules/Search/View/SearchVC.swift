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
    
    //MARK: - Properties
    var presenter: SearchPresenterProtocol?
    var searchActive : Bool = false
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(SearchItemCell.nib, forCellReuseIdentifier: SearchItemCell.identifier)
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(updateTotal(_:)),
                         name: NSNotification.Name ("com.updateCalc.search"),
                         object: nil)
    }
    //MARK: - Methods
    
    @objc func updateTotal(_ notification: Notification){
        print("NOTIFICATION OBSERVER <><><><><><><>")
        print(notification.userInfo?["itemInfo"] as? [String: Any] ?? [:])
    }
    
    
    //MARK: - Actions
    @IBAction func changeLanguageAction(_ sender: UIButton) {
    }
    @IBAction func backAction(_ sender: UIButton) {
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        self.presenter?.confirmMeds()
    }
}

//MARK: - Search View Protocol Methods
extension SearchVC : SearchViewProtocol {
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
        let cellData = self.presenter?.getMedItem(at: indexPath)
        cell.configreCell(cellData: cellData)
        cell.indexPathForCell = indexPath
        cell.saveItemToCart = { count in
            let entity = CartItemEntity(itemID: cellData?.id ?? "",arabicName: cellData?.arabicName ?? "", englishName: cellData?.englishName ?? "", price: cellData?.price ?? 0.0, count: count , picURL: cellData?.picUrl ?? "")
            print("PRINT ENTITY : - ",entity)
            self.presenter?.interactor?.saveToCoreData(item: entity)
        }
        cell.minusBTNClosure = { tag in
            if (tag == indexPath.row) {
                let count = Int(cell.itemCount.text ?? "0")
                guard let count = count else { return }
                if (count == 1) {
                    cell.addToCartButton.isHidden = false
                    cell.plusAndMinusView.isHidden = true
                }
                cell.itemsCount = count - 1
                cell.itemCount.text = "\(cell.itemsCount)"
                print("COUNT MATE : - ",cell.itemsCount)
                
                let countInfo = ["itemInfo": ["count": cell.itemsCount, "price": cellData?.price]]
                NotificationCenter.default
                    .post(name: NSNotification.Name("com.updateCalc.search"),
                          object: nil,
                          userInfo: countInfo)
            }
            
        }
        cell.addToCartClosure = { tag in
            if (tag == indexPath.row) {
                cell.addToCartButton.isHidden = true
                cell.plusAndMinusView.isHidden = false
                self.confirmView.isHidden = false
            
                let count = Int(cell.itemCount.text ?? "0")
                guard let count = count else { return }
                cell.itemsCount = count + 1
                //SAVE TO CART
                cell.saveItemToCart?(cell.itemsCount)
                cell.itemCount.text = "\(cell.itemsCount)"
                let countInfo = ["itemInfo": ["count": cell.itemsCount, "price": cellData?.price]]
                NotificationCenter.default
                    .post(name: NSNotification.Name("com.updateCalc.search"),
                          object: nil,
                          userInfo: countInfo)
            }
        }
        cell.plusBTNClosure = { tag in
            if (tag == indexPath.row) {
                let count = Int(cell.itemCount.text ?? "0")
            guard let count = count else { return }
                cell.itemsCount = count + 1
                cell.itemCount.text = "\(cell.itemsCount)"
                print("COUNT MATE : - ",cell.itemsCount)
                let countInfo = ["itemInfo": ["count": cell.itemsCount, "price": cellData?.price]]
                NotificationCenter.default
                    .post(name: NSNotification.Name("com.updateCalc.search"),
                          object: nil,
                          userInfo: countInfo)
            }
              
        }
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
