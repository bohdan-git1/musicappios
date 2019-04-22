//
//  UploadImageViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 22/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class UploadImageViewController: BaseViewController,TopBarDelegate {
  
    

    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var btnUpload : UIButton!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        self.btnUpload.layer.cornerRadius = 5
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile!.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.topBarHeight.constant = TOP_BAR_HEIGHT
            container.lblTitle.text = "Profile"
            container.delegate = self
            container.btnMenu.isHidden = true
            container.btnBack.isHidden = false
            container.btnEdit.isHidden = true
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.optionToSelectImage()
    }
    func actionCallBackMoveBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionCallBackEdit() {
        
    }
   

}
//Mark:- Image Picker
extension UploadImageViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imgProfile?.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func optionToSelectImage(){
        // self.btnEdit.setTitleColor(UIColor.white, for: .normal)
        self.imgProfile!.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.imgProfile
            alert.popoverPresentationController?.sourceRect = self.imgProfile!.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: Messages.No_Camera, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK:- Upload Profile Pic
extension UploadImageViewController{
    func uploadImage()  {
        let request = createRegistrationRequst()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = ImageService()
            service.uploadImage(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        //                        if let model = responseMessage.data as? ImageViewModel{
                        //                            self.imageDetail = model
                        //                            print(self.imageDetail)
                        //                            if let del = self.delegate{
                        //                                del.actionPopupCallBackReloadCollectionView(image: self.imageDetail)
                        //                            }
                        //  self.dismiss(animated: true, completion: nil)//popViewController(animated: true)
                        
                        //  }
                        
                        
                    case .Failure:
                        self.showAlertVIew(message: responseMessage.message, title: "")
                        
                    default:
                        print(responseMessage.message)
                        
                    }
                }
                
            })
        }
        
    }
    func createRegistrationRequst() -> RequestMessage {
        let request = RequestMessage()
        request.imageKey = "file"
        request.image = self.imgProfile.image!
        request.advance = "\(Global.shared.login.id)"
        return request
        
    }
    
    
}
