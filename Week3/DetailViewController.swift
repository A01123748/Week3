//
//  DetailViewController.swift
//  Week3
//
//  Created by Eliseo Fuentes on 7/16/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tittle: UITextField!
    @IBOutlet weak var authors: UITextView!
    @IBOutlet weak var portada: UIImageView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.tittle {
                label.text = detail.valueForKey("title")!.description
            }
            if let label = self.authors {
                label.text = detail.valueForKey("authors")!.description
            }
            if let label = self.portada {
                let data : NSData? = detail.valueForKey("cover") as? NSData
                if data != nil{
                    if data!.length != 0{
                        label.image = UIImage(data: data!)!
                    }
                    else{
                        label.image = UIImage(named: "img1.jpg")
                    }
                }
                else{
                    label.image = UIImage(named: "img1.jpg")
                }
            }
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tittle.text = "Hola mundo"
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

