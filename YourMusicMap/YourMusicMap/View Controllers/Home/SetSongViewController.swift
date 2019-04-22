//
//  SetSongViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit
import MediaPlayer
import GoogleMaps
import AVFoundation

import GooglePlaces

class SetSongViewController: BaseViewController,TopBarDelegate,PlaceSearchTextFieldDelegate,GMSMapViewDelegate{

    @IBOutlet weak var viewSearch : UIView!
    @IBOutlet weak var viewSongName : UIView!
    @IBOutlet weak var viewSongUrl : UIView!
    @IBOutlet weak var btnAddSong : UIView!
    @IBOutlet weak var viewGoogleMap : GMSMapView!
    @IBOutlet weak var txtSearch : MVPlaceSearchTextField!
    @IBOutlet weak var txtSongName : UITextField!
    @IBOutlet weak var txtSongUrl : UITextField!
    @IBOutlet weak var imgMarker : UIImageView!
    @IBOutlet weak var lblAddress : UILabel!
    var locationManager = CLLocationManager()
    var coordinates = CLLocationCoordinate2D()
    var player: AVAudioPlayer!
    var audioSong =  MPMediaItem() //MPMediaItemCollection()

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.search()
        self.txtSearch.placeSearchDelegate = self
        self.txtSearch.strApiKey = GoogleMap.API_KEY
        self.txtSearch.superViewOfList = self.view
        self.txtSearch.maximumNumberOfAutoCompleteRows     = 8
        self.txtSearch.autoCompleteShouldHideOnSelection = true
        self.txtSearch.autoCompleteTableCellTextColor = UIColor.black
        
        
        self.setBorderColor(view: self.viewSongName, color: AppColors.darkBlue, width: 1)
        self.viewSongName.layer.cornerRadius = 5
        self.viewGoogleMap.delegate = self
        self.coordinates = (self.locationManager.location?.coordinate)!
        self.viewGoogleMap.camera = GMSCameraPosition.camera(withTarget: (locationManager.location?.coordinate)!, zoom: 15)
       // self.lblAddress.layer.cornerRadius = 10
        self.lblAddress.layer.borderColor = UIColor.white.cgColor
        self.lblAddress.layer.borderWidth = 2
        self.viewSearch.layer.cornerRadius = 10
        self.viewSongUrl.layer.cornerRadius = 5
        self.setBorderColor(view: self.viewSongUrl, color: AppColors.darkBlue, width: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.btnMenu.isHidden = true
            container.btnBack.isHidden = false
            container.lblTitle.text = "Set Song"
        }
    }
    
    func actionCallBackMoveBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionCallBackEdit(){
        
    }
    
    //MARK:- Actions
    //Selecting song from mobile
    @IBAction func actionSelectSong(_ sender:Any){
        self.selectSong()
    }
    
    //Adding song on Map
    @IBAction func actionAddSong(_ sender:Any){
        if(self.txtSongName.text == "" || self.txtSongUrl.text == ""){
             self.showAlertVIew(message: "Please select a song", title: "Required")
        }else{
           self.UploadSong()
        }
    }
    @IBAction func actionSearch(_ sender : UITextField){
//
    }
    
}
//
extension SetSongViewController {
    func placeSearchResponse(forSelectedPlace responseDict: NSMutableDictionary!) {
         print("SELECTED ADDRESS :%@", responseDict)
        let lat = (((responseDict?["result"] as? [AnyHashable : Any])?["geometry"] as? [AnyHashable : Any])?["location"] as? [AnyHashable : Any])?["lat"] as? AnyHashable
        let long = (((responseDict?["result"] as? [AnyHashable : Any])?["geometry"] as? [AnyHashable : Any])?["location"] as? [AnyHashable : Any])?["lng"] as? AnyHashable
        let camera = GMSCameraPosition.camera(withLatitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees, zoom: 15.0)
        self.viewGoogleMap.camera = camera
    }
    
    func placeSearchWillShowResult() {
        
    }
    
    func placeSearchWillHideResult() {
        
    }
    
    func placeSearchResultCell(_ cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
    }
    
    
  
    
}
//MARK:- TextField Delegates
extension SetSongViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- Audio Picker Delegates
extension SetSongViewController :MPMediaPickerControllerDelegate{
    func selectSong(){
        // self.typeForSelect = "Audio"
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        self.present(mediaPicker, animated: true, completion: nil)
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("you picked: \(mediaItemCollection)")
        let item = mediaItemCollection.items[0] as? MPMediaItem ?? MPMediaItem()
        let url: URL? = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        self.txtSongUrl.text = "\(url!)"
        print(self.txtSongUrl.text)
        self.audioSong = item
        print(audioSong)
        
//        exportiTunesSong(assetURL: url!)
//        {
//            (response) in
//            print(response ?? "responce")
//        }
        
        let songTitle: String = item.value(forProperty: MPMediaItemPropertyTitle) as! String
        self.txtSongName.text = songTitle
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Handle the user's selection.
extension SetSongViewController {

    //MARK:- Get Address from LatLong
    
    func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        self.coordinates = coordinate
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            if let address = response?.firstResult() {
                let lines = address
                self.lblAddress.text = address.lines![0]
                
                print(lines)
                
            }
        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAddressFromGeocodeCoordinate(coordinate: mapView.camera.target)
    }
}
//MARK:- Upload Profile Pic
extension SetSongViewController{
    func UploadSong()  {
        let request = createRegistrationRequst()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = SongService()
            service.uploadSong(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        self.navigationController?.popViewController(animated: true)
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
        request.audioKey = "file"
        request.audioPath = self.audioSong.assetURL!
        request.id = "\(Global.shared.login.id)"
        request.lat = self.coordinates.latitude
        request.long = self.coordinates.longitude
        request.name = self.txtSongName.text!
        return request
        
    }
    
    
}
