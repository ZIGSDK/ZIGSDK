//
//  BottomSheetProductCell.swift
//  zigsmartNewApp
//
//  Created by Closerlook on 3/20/24.
//

import UIKit

class BottomSheetProductCell: UITableViewCell {
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var increment: UIButton!
    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var decrement: UIButton!
    @IBOutlet weak var purchaseImage: UIView!
    @IBOutlet weak var fareAmount: UILabel!
    @IBOutlet weak var ticketIcon: UIImageView!
    @IBOutlet weak var ticketName: UILabel!
    @IBOutlet weak var ticketDescription: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var purchaseView: UIView!
    var decAction : (() -> Void)?
    var incAction : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overrideUserInterfaceStyle = .light
        purchaseView.layer.borderWidth = 2
        purchaseView.layer.cornerRadius = purchaseView.frame.height / 2
        
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.cornerRadius = 15
        outerView.backgroundColor = UIColor.systemBackground
        
        outerView.layer.shadowColor = UIColor.lightGray.cgColor
        outerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        outerView.layer.shadowOpacity = 0.5
        outerView.layer.shadowRadius = 2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func decBtn(_ sender: Any) {
        decAction?()
    }
    
    @IBAction func incBtn(_ sender: Any) {
        incAction?()
    }
}
