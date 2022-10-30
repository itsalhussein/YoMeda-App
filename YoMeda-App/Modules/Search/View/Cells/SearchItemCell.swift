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
    var addToCartClosure : ((_ btnTag: Int)->())?
    var plusBTNClosure : ((_ btnTag: Int)->())?
    var minusBTNClosure : ((_ btnTag: Int)->())?
    var saveItemToCart : ((_ itemCount: Int)->())?
    var itemsCount = 0
    var indexPathForCell: IndexPath?

    static var identifier: String {
        return String.init(describing: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
        
    //MARK: - Methods

    func configreCell(cellData: Complaints?){
        guard let cellData = cellData else { return }
        guard let englishName = cellData.englishName else { return }
        guard let itemPrice = cellData.price else { return }
        guard let arabicName = cellData.arabicName else { return }
        
        let medPicture = cellData.picUrl ?? ""
        let medPicURL = medPicture.removingWhitespaces()
        let transformer = SDImageResizingTransformer(size: CGSize(width: self.itemImage.frame.width, height: self.itemImage.frame.height), scaleMode: .fill)
        self.itemImage.sd_setImage(with: URL(string: medPicURL), placeholderImage: UIImage(named: "ic_tempMed"), context: [.imageTransformer: transformer])

        self.itemName.text = englishName
        self.itemPrice.text = "\(itemPrice)"
        
        self.addToCartButton.tag = indexPathForCell?.row ?? 0
        self.plusButton.tag = indexPathForCell?.row ?? 0
        self.minusButton.tag = indexPathForCell?.row ?? 0
        
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        print("SENDER",sender.tag)
        print("INDEXPATH",indexPathForCell)
        minusBTNClosure?(indexPathForCell?.row ?? 0)
    }
    @IBAction func plusAction(_ sender: UIButton) {
        print("SENDER",sender.tag)
        print("INDEXPATH",indexPathForCell)
        plusBTNClosure?(indexPathForCell?.row ?? 0)
    }
    @IBAction func addToCartAction(_ sender: PMSuperButton) {
        print("SENDER",sender.tag)
        print("INDEXPATH",indexPathForCell)
        addToCartClosure?(indexPathForCell?.row ?? 0)
    }
}
