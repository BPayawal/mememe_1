//
//  SentMemeDetailViewController.swift
//  
//
//  Created by Brian M Payawal on 5/24/15.
//
//

import UIKit

class SentMemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var meme:Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        memeImageView.image = meme.memedImage
        
    }

}
