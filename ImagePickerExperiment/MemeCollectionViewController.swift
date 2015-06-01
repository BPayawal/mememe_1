//
//  MemeCollectionViewController.swift
//  ImagePickerExperiment
//
//  Created by Brian M Payawal on 5/28/15.
//  Copyright (c) 2015 Brian Payawal. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        memes = appDelegate.memes
        
        }
    
    
    // The number of items in the grid is equal to the number of memes in our Meme array
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
        
    }
    
    // Populate the grid with our memes
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeCollectionCell", forIndexPath: indexPath) as! MemeCustomCell
        
        // retrieve the corresponding meme
        let meme = memes[indexPath.item]
        // display the meme(s)
        cell.memeImageView.image = meme.image
        cell.labelTop.text = meme.textTop
        cell.labelBottom.text = meme.textBottom
        
        return cell
        
    }
    
    // Present the selected meme
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let myController = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemeDetailViewController") as! SentMemeDetailViewController
        
        myController.meme = memes[indexPath.item]
        
        self.navigationController?.pushViewController(myController, animated: true)
        
    }
    
    // Edit a new Meme
    @IBAction func editNewMeme(sender: UIBarButtonItem) {
        let myController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        presentViewController(myController, animated: true, completion: nil)
        
    }
    
    
}
