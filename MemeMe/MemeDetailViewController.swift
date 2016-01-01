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
    
    @IBAction func cancelDetailView(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editMeme = storyboard.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
        editMeme.originalImage = savedMeme.originalImage
        editMeme.textTop = savedMeme.topText
        editMeme.textBottom = savedMeme.bottomText
        
        presentViewController(editMeme, animated: true, completion: nil)
    }
   

}
