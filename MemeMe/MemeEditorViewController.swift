//
//  ViewController.swift
//  MemeMe
//
//  Created by Dipesh karki on 30/12/2015.
//  Copyright © 2015 Dipesh karki. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var resetMeme: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 4.5,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        topText.delegate = self
        bottomText.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Buttons are enable only source type is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        album.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        
     
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
      
    }
  

    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
   
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
       
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        resetMeme.enabled = true
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imagePickerView.image = originalImage
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        if(textField == bottomText){
            registerAnObserver()
        }
       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        removeAnObserver()
        if resetMeme.enabled == false {
            resetMeme.enabled = true
        }
        return true
        
    }
    
    
    //registering an observer
    func registerAnObserver() {
        let notification = NSNotificationCenter.defaultCenter()
        notification.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    // moving the view up
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // moving the view down by adding the actual height we moved up
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    
    // returning keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
   // removing an observer
    func removeAnObserver() {
   
        let notification = NSNotificationCenter.defaultCenter()
        notification.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePickerView.image = nil
        
    }
    
    func save() {
        let meme = MemedDetail(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Adding to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    func generateMemedImage() -> UIImage{
        
        navigationController!.navigationBar.hidden = true
        bottomToolbar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationController?.navigationBar.hidden = false
        bottomToolbar.hidden = false
        return memedImage
        
        }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let sharedMeme = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [sharedMeme], applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
        activity.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
}

