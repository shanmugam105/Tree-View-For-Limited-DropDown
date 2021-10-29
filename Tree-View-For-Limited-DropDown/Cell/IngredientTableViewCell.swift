//
//  IngredientTableViewCell.swift
//  KJExpandableTableTree_Example
//
//  Created by Mac on 07/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBox1: UIImageView!
    @IBOutlet weak var checkBox2: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    
    func configureView(state: CellState,
                       ingredient: String,
                       price: String,
                       spacing: Int,
                       type: CellType? = .CheckBox) {
        switch state {
        case .open:
            checkBox1.image = #imageLiteral(resourceName: "down-chevron")
            checkBox2.image = #imageLiteral(resourceName: "down-chevron")
        case .close:
            checkBox1.image = #imageLiteral(resourceName: "right-chevron")
            checkBox2.image = #imageLiteral(resourceName: "right-chevron")
        case .none: break
        }
        
        var leadingConstant: CGFloat = 0
        
        if spacing == 1 {
            leadingConstant = 30
            checkBox1.isHidden = false
            checkBox2.isHidden = true
        } else if spacing == 4 {
            leadingConstant = 15
            checkBox1.isHidden = false
            checkBox2.isHidden = true
            checkBox1.image = #imageLiteral(resourceName: "trash")
        } else {
            checkBox1.isHidden = true
            checkBox2.isHidden = false
        }
        checkBox2.image = checkBox2.image?.withRenderingMode(.alwaysTemplate)
        checkBox2.tintColor = .link
        checkBox1.image = checkBox1.image?.withRenderingMode(.alwaysTemplate)
        checkBox1.tintColor = .link
        nameLabel.text = ingredient.capitalized
        nameLabel.font = .systemFont(ofSize: 16)
        selectionStyle = .none
        titleLeadingConstraint.constant = CGFloat(15 * spacing) - leadingConstant
    }
}
