//
//  EasyImageVideoPicker
//
//  Created by Avijit Babu on 04/05/2020.
//  Copyright (c) 2020 Avijit Babu. All rights reserved.
//

import UIKit
import EasyImageVideoPicker

class ViewController: UIViewController {
    
    @IBOutlet weak var img : UIImageView!
    
    var imgPicker : EasyImageVideoPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker = EasyImageVideoPicker(presentationController: self, delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func pickVideo(_ sender : UIButton){
        imgPicker?.present(from: sender, mediaType: .video, onViewController: self)
    }
    
    @IBAction func pickImage(_ sender : UIButton){
        imgPicker?.present(from: sender, mediaType: .images, onViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController : EasyImageVideoPickerDelegate{
    
    func didSelect(image: UIImage?, video: URL?, fileName: String?) {
        img.image = image
    }
}
