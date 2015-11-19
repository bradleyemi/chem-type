//
//  ProcessedViewController.swift
//  chem-type
//
//  Created by triki on 11/14/15.
//  Copyright © 2015 triki. All rights reserved.
//

import UIKit

class ProcessedViewController: UIViewController {
    
    
    var imageDict: [Int: String] = [20: "acetone.png", 13: "alcohol.png", 8: "alkyne.png", 16: "cisbutene.png", 5: "epoxide.png", 1: "hackcsXLbenzene.png", 22: "malonicester.png", 4: "subbenzene.png", 19: "succinimide.png"]
    
    @IBOutlet weak var imageView: UIImageView!
    
    var transferInt = 0
    
    @IBAction func SaveToGalleryTapped(sender: AnyObject) {
        
        let imageToSave: UIImage
        
        //UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.savedImageAlert()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savedImageAlert()
    {
        let alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your chemical compound was saved to the Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
      /*var imageNum:Int = 5 //get as OCR Output
        var image: UIImage {
                get{
                    return images[imageNum]!
                }
        } */
        
      
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    //print(transferInt)
        let string = imageDict[transferInt]
        print(transferInt)
        print(string)
        let image = UIImage(named: string!)
        imageView.image = image
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
