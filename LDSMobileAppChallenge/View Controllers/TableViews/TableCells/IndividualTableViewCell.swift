//
//  IndividualTableViewCell.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import UIKit

class IndividualTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    
    var cellIndividual : Individual?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellData() {
        guard let firstName = cellIndividual?.firstName else { return }
        guard let lastName = cellIndividual?.lastName else { return }
        self.cellNameLabel.text = firstName + " " + lastName
        loadImage()
    }
    
    func loadImage() {
        guard let individualImageData = self.cellIndividual?.profileImage else { return }
        let individualImage = UIImage(data: individualImageData)
        self.cellImage.image = individualImage
    }
}
