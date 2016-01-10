//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dipesh karki on 1/01/2016.
//  Copyright © 2016 Dipesh karki. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var savedMeme : MemedDetail!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.image = savedMeme.memedImage

    }
    

}
