//
//  SearchItemCell.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import UIKit
import SDWebImage

class SearchItemCell: UITableViewCell {
    //MARK: - Outlets
    
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var addToCartButton: PMSuperButton!
    @IBOutlet weak var plusAndMinusView: UIStackView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        itemName.lineBreakMode = .byWordWrapping
        itemName.numberOfLines = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Properties
    var addToCartClosure : (()->())?
    var minusClosure : (()->())?
    var plusClosure : (()->())?
    var saveItemToCart : (()->())?
    var itemsCount = 0
    var indexPathForCell: IndexPath?
    
    static var identifier: String {
        return String.init(describing: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
    
    
    func configureCell(_ cellModel: CartItemEntity?){
        guard let cellModel = cellModel else {
            return
        }
        if cellModel.isAdded == true {
            self.addToCartButton.isHidden = true
            self.plusAndMinusView.isHidden = false
        } else {
            self.addToCartButton.isHidden = false
            self.plusAndMinusView.isHidden = true
        }
        let medPicture = cellModel.picURL
        let medPicURL = medPicture.removingWhitespaces()
        let transformer = SDImageResizingTransformer(size: CGSize(width: self.itemImage.frame.width, height: self.itemImage.frame.height), scaleMode: .fill)
        self.itemImage.sd_setImage(with: URL(string: medPicURL), placeholderImage: UIImage(named: "ic_tempMed"), context: [.imageTransformer: transformer])
        self.itemName.text = cellModel.englishName
        self.itemPrice.text = "\(cellModel.price)"
        self.itemCount.text = "\(cellModel.count)"
        
    }
    
    //MARK: - Actions
    
    @IBAction func cellAction(_ sender: PMSuperButton) {
        switch sender.tag {
        case 0:
            //ADD TO CART CASE
            addToCartButton.isHidden = true
            plusAndMinusView.isHidden = false
            addToCartClosure?()
            saveItemToCart?()
        case 1:
            //MINUS BUTTON CASE
            minusClosure?()
        case 2:
            //PLUS BUTTON CASE
            plusClosure?()
        default:
            break
        }
        
    }
}
