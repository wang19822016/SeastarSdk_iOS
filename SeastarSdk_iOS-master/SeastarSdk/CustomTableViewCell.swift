//
//  CustomTableViewCell.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/5/5.
//
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 15, y: 6, width: 30, height: 30);
        self.textLabel?.frame = CGRect(x: 55, y: 6, width: 166, height: 30);
    }

}
