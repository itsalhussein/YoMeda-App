//
//  CartItemCell.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 30/10/2022.
//

import UIKit
import SDWebImage

class CartItemCell: UITableViewCell {
    //MARK: - Outlets
  
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var plusAndMinusView: UIStackView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    //MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Properties

    static var identifier: String {
        return String.init(describing: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
    
    var minusBTNClicked: (()->())?
    var plusBTNClicked: (()->())?
    var deleteBTNClicked: (()->())?


    //MARK: - Methods

    func configreCell(cellData: CartItemEntity?){
        guard let cellData = cellData else { return }
        
        let medPicture = cellData.picURL
        let medPicURL = medPicture.removingWhitespaces()
        let transformer = SDImageResizingTransformer(size: CGSize(width: self.itemImage.frame.width, height: self.itemImage.frame.height), scaleMode: .fill)
        self.itemImage.sd_setImage(with: URL(string: medPicURL), placeholderImage: UIImage(named: "ic_tempMed"), context: [.imageTransformer: transformer])

        self.itemName.text = cellData.englishName
        if Language.currentLanguage() == "en"{
            self.itemName.text = cellData.englishName
        } else {
            self.itemName.text = cellData.arabicName
        }
        self.itemPrice.text = "\(cellData.price)"
        self.itemCount.text = "\(cellData.count)"
    }

    //MARK: - Actions

    @IBAction func plusAction(_ sender: UIButton) {
        plusBTNClicked?()
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        minusBTNClicked?()
    }
    
    @IBAction func deleteAction(_ sender: PMSuperButton) {
        deleteBTNClicked?()
    }
}
