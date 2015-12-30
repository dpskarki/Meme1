//
//  Meme.swift
//  MemeMe
//
//  Created by Dipesh karki on 31/12/2015.
//  Copyright © 2015 Dipesh karki. All rights reserved.
//

import Foundation
import UIKit

struct MemedDetail {
    
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    
}

