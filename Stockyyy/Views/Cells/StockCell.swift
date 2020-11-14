//
//  StockCell.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

final class StockCell: UITableViewCell {
    
    static let identifier = "StockCell"
    
    var company: Company? {
        didSet {
            //TODO: Set labels
        }
    }
    
    //TODO: Create Labels
    //Symbol lbl
    //Name lbl
    //Exchange lbl
    //SV for three labels above
    //Price lbl

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //NOTE: Setup not needed.  Not using SB.
    }
    
}
