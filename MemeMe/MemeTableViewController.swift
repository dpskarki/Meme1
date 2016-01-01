//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Dipesh karki on 1/01/2016.
//  Copyright © 2016 Dipesh karki. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
 
    var memes = [MemedDetail]()
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reusableCell", forIndexPath: indexPath)
        cell.imageView!.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        cell.imageView!.contentMode = .ScaleAspectFill
        var text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].topText
        text = text + "..." + (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].bottomText
        cell.textLabel?.text = text
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("detailView") as! MemeDetailViewController
        detailViewController.savedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        navigationController!.pushViewController(detailViewController, animated: true)
        
    }
    
    

}
