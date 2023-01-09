//
//  QRCodeView.swift
//
//
//  Created by Roberto Oliveira on 20/08/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class QRCodeView: UIView {
    
    // MARK: - Objects
    private let imageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - Methods
    func updateQRCodeWithString(_ string:String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)

        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")

        let qrImage:CIImage = filter!.outputImage!

        //qrImageView is a IBOutlet of UIImageView
        let size:CGFloat = 1000
        let scaleX = size / qrImage.extent.size.width
        let scaleY = size / qrImage.extent.size.height

        let resultQrImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        self.imageView.image = UIImage(ciImage: resultQrImage)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.imageView)
        self.addFullBoundsConstraintsTo(subView: self.imageView, constant: 0)
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.imageView, attribute: .width, multiplier: 1.0, constant: 0))
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
