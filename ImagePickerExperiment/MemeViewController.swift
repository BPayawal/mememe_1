//
//  MemeViewController.swift
//  ImagePickerExperiment
//
//  Created by Brian M Payawal on 5/18/15.
//  Copyright (c) 2015 Brian Payawal. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    //View
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //Buttons
    @IBOutlet weak var pickFromCamera: UIBarButtonItem!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    
    //Textfields
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()

    //Navigation and Toolbar
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the attributes of the textfields
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor() ,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0,
        ]
        
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        
        textFieldTop.textAlignment = .Center
        textFieldBottom.textAlignment = .Center
        
        textFieldBottom.borderStyle = .None
        textFieldTop.borderStyle = .None
        
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        
        // Delegate the text fields to the class TextFieldDelegate
        textFieldTop.delegate = textFieldDelegate
        textFieldBottom.delegate = textFieldDelegate
        
        // Disable the share button untill an image is picked
        shareMeme.enabled = false
        
        }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Enable the camera button only if the device has a camera
        pickFromCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Set the attribute of the imagePickerView
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // Call the suscribe to keyboard notifications method
        subscribeToKeyboardNotification()
        
        }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        // Call the unsubscribe to keyboard notifications method
        unsubscribeToKeyboardNotification()
        
    }
    
        // Create Meme Object and add to Meme Array.
        func save() {
            
            // Create Meme Object
            var meme = Meme(textTop: textFieldTop.text!, textBottom: textFieldBottom.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
            // Add it to the Meme array
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Generate a meme image
    func generateMemedImage () -> UIImage {
        
        // Hide navigation bar & tool bar
        toolBar.hidden = true
        navigationBar.hidden = true
        
        // Resign first responders
        textFieldBottom.resignFirstResponder()
        textFieldTop.resignFirstResponder()
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show navigation bar & tool bar
        toolBar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
        
    }
    
    // Share the Meme
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        //Generate the meme
        let memedImage = generateMemedImage()
        // Define an array that will store our meme image
        var memedImages = [UIImage]()
        //Add it to our array of meme
        memedImages.append(memedImage)
        // pass the activity item to our activityViewController
        let myController = UIActivityViewController(activityItems: memedImages as [AnyObject], applicationActivities: nil)
        // present our activityViewController
        presentViewController(myController, animated: true, completion: nil)
        
        // Choose the completion item handler
        myController.completionWithItemsHandler = saveMemeAfterSharing
    }
    
    // The completion item handler that call the methods, to save and dismiss the viewcontroller
    func saveMemeAfterSharing (String!,completed: Bool, [AnyObject]!, NSError!) -> Void {
        if completed {
            save()
            
            // Present the sent table view controller
            presentSentMemeController()
            
            
        }
    }
    
    // Present the Sent memes when the user hits cancel
    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
    
    // Present the sent table view controller
        presentSentMemeController()
    }
    
    // Method to present the Sent Meme View Controller
    func presentSentMemeController() {
        
        let tabController = storyboard!.instantiateViewControllerWithIdentifier("SentMemeController") as! UITabBarController
        
        presentViewController(tabController, animated: true, completion: nil)
        
    }
    

        


    // Subscribe to keyboard notifications
        func subscribeToKeyboardNotification () {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        }
        
        // Unsubscribe to keyboard notifications
        func unsubscribeToKeyboardNotification() {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
        
        // Get the height of the keyboard
        func getKeyboardHeight(notification : NSNotification) -> CGFloat {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            
            return keyboardSize.CGRectValue().height
        }
        
        // Move the view when the keyboard covers the text field.
        func keyboardWillShow(notification : NSNotification) {
            if textFieldBottom.isFirstResponder() {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }

        // View goes down when keyboard is dismissed.
        func keyboardWillHide(notification : NSNotification) {
            if textFieldBottom.isFirstResponder() {
                view.frame.origin.y = 0
            }
        }
        
    //Pick an image from Photo Library.
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Set sourcetype to photo library.
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    //Pick an image from camera.
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Set sourcetype to camera.
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // Display the picked image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imagePickerView.image = image
            
        // enable the "Share" button
        shareMeme.enabled = true
            
        dismissViewControllerAnimated(true, completion: nil)
            
    }
        
        // Dismiss the view controller if the user presses "Cancel"
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
}
}
