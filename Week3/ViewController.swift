//
//  ViewController.swift
//  Libros
//
//  Created by Eliseo Fuentes on 6/22/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var portada: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbn.returnKeyType = UIReturnKeyType.Search
        portada.image = UIImage(named: "img1.jpg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didEnterSearch(sender: AnyObject) {
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urls = urls+isbn.text!
        let url = NSURL(string: urls)
        let session = NSURLSession.sharedSession()
        let bloque = { (datos:NSData?, resp : NSURLResponse?,error : NSError?)->Void in
            if error?.code != nil {
                dispatch_sync(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error", message:
                        error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            } else{
                //let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                dispatch_sync(dispatch_get_main_queue(), {
                    do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!,
                        options: NSJSONReadingOptions.MutableLeaves)
                    let dico = json as! NSDictionary
                    if(dico["ISBN:"+self.isbn.text!] != nil){
                        let dico1 = dico["ISBN:"+self.isbn.text!] as! NSDictionary
                        let title = dico1["title"] as! String
                        self.titulo.text = title
                        let n: Int! = self.navigationController?.viewControllers.count
                        let masterViewController = self.navigationController?.viewControllers[n-2] as! MasterViewController
                        var authorsText = ""
                        if((dico1["by_statement"]) != nil){
                            authorsText = dico1["by_statement"] as! String
                        }
                        else{
                            let authors = dico1["authors"] as! NSArray
                            var author = NSDictionary()
                            for i in 0  ..< authors.count {
                                author = authors[i] as! NSDictionary
                                if(authorsText != "")
                                {
                                    authorsText += "," + (author["name"] as! String)
                                }
                                else{
                                    authorsText += author["name"] as! String
                                }
                            }
                        }
                        self.results.text = authorsText
                        let data : NSData = NSData()
                        if((dico1["cover"]) != nil){
                            let cover = dico1["cover"] as! NSDictionary
                            let url = cover["medium"] as! String
                            let data:NSData = NSData(contentsOfURL: NSURL(string:url)!)!
                            self.portada.image = UIImage(data: data)
                            masterViewController.insNewObject(self.isbn.text!, title: title, autores: authorsText, portada: data)
                        }
                        else{
                            self.portada.image = UIImage(named: "img1.jpg")
                            masterViewController.insNewObject(self.isbn.text!, title: title, autores: authorsText, portada: data)
                        }
                        self.isbn.resignFirstResponder()
                    }
                    else{
                        let alertController = UIAlertController(title: "Error", message:
                            "Not a valid ISBN", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                    catch{
                    }
                })
            }
        }
        
        let dt = session.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
    }
    func getImage(url : NSURL)->UIImage{
        let session = NSURLSession.sharedSession()
        var image = UIImage(named: "img1.jpg")
        let bloque = { (datos:NSData?, resp : NSURLResponse?,error : NSError?)->Void in
            if error?.code != nil {
                dispatch_sync(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error", message:
                        error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            } else{
                dispatch_sync(dispatch_get_main_queue(), {
                image = UIImage (data: datos!)!
                })
            }
        }
        let dt = session.dataTaskWithURL(url, completionHandler: bloque)
        dt.resume()
        print(image!)
        return image!
    }
}

