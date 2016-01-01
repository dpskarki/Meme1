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
    
    //variable to be used for meme detail view controller
    var originalImage : UIImage?
    var textTop: String?
    var textBottom: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self
        customTextField(topText)
        customTextField(bottomText)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        album.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        subscribeToKeyboardNotifications()
        
     
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
      
    }
    
  
    // setting custom attributes to textfield
    func customTextField(textField: UITextField) {
        
        textField.delegate = self
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5.5
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.text = ""
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
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
    
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    //view shift up only when the bottom text field is begin editing
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        
        if !(self.view.frame.origin.y == 0) {
            view.frame.origin.y = 0
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
      
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func save() {
        
        let meme = MemedDetail(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
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
        presentViewController(activity, animated: true, completion: nil)
        activity.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
    }
    
    
}

