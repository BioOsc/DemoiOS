//
//  MainVC.swift
//  OscielDemo
//
//  Created by Desarrollo on 4/9/20.
//  Copyright © 2020 Desarrollo. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var testCamButton: UIButton!
    @IBOutlet var containerImgView: UIImageView!
    @IBOutlet var latitudTextField: UITextField!
    @IBOutlet var longitudTextField: UITextField!
    @IBOutlet var testLocationButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: - User Interaction
    @IBAction func goToTestCam(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .camera
            photoPicker.showsCameraControls = true
            photoPicker.allowsEditing = false
            self.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToTestLocation(_ sender: Any) {
        if (latitudTextField.text!.isEmpty) {
            CommonUtils.presentAlert(message: "Latitud no puede estar vacio", title: "Error", origin: self)
            return
        }
        if (latitudTextField.text!.isEmpty) {
            CommonUtils.presentAlert(message: "Longitud no puede estar vacio", title: "Error", origin: self)
            return
        }
        performSegue(withIdentifier: "GoToMap", sender: self)
    }
    
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Constants.KEY_SESION_ACTIVE)
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - Cam Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            containerImgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC: MapTVC = segue.destination as? MapTVC {
            nextVC.userLatitude = latitudTextField.text!
            nextVC.userLongitude = longitudTextField.text!
        }
    }
    
}
