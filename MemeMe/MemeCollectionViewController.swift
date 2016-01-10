//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Dipesh karki on 1/01/2016.
//  Copyright © 2016 Dipesh karki. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes = [MemedDetail]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView!.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
       
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reusableItem", forIndexPath: indexPath) as! MemedCollectionViewCell
         let meme = memes[indexPath.item]
         cell.imageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("detailView") as! MemeDetailViewController
        detailViewController.savedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item]
        navigationController!.pushViewController(detailViewController, animated: true)
        
    }

   
}


