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
import BraintreeDropIn
import Braintree

import GooglePlaces

protocol SetSongDelegate : NSObjectProtocol {
    func actionCallBackUpdateMap(message:String)
}

class SetSongViewController: BaseViewController,TopBarDelegate,PlaceSearchTextFieldDelegate,GMSMapViewDelegate{
    
    @IBOutlet weak var viewSearch    : UIView!
    @IBOutlet weak var viewSongName  : UIView!
    @IBOutlet weak var viewSongUrl   : UIView!
    @IBOutlet weak var btnAddSong    : UIButton!
    @IBOutlet weak var viewGoogleMap : GMSMapView!
    @IBOutlet weak var txtSearch     : MVPlaceSearchTextField!
    @IBOutlet weak var txtSongName   : UITextField!
    @IBOutlet weak var txtSongUrl    : UITextField!
    @IBOutlet weak var imgMarker     : UIImageView!
    @IBOutlet weak var lblAddress    : UILabel!
    @IBOutlet weak var lblAvalible   : UILabel!
    
    var locationManager              = CLLocationManager()
    var coordinates                  = CLLocationCoordinate2D()
    var player                       : AVAudioPlayer!
    var audioSong                    =  MPMediaItem() //MPMediaItemCollection()
    var songUrl                      : URL?
    var isTrackAvalible              : Bool = false
    var avalibleSong                 = SongViewModel()
    let apiClient                    = BTAPIClient(authorization: clientToken)
    var nonse                        = ""
    var delegate                     : SetSongDelegate!
    var isSongsUrl                   : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.search()
        //Auto Complete
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
        self.lblAddress.layer.borderColor = UIColor.white.cgColor
        self.lblAddress.layer.borderWidth = 2
        self.viewSearch.layer.cornerRadius = 10
        self.btnAddSong.layer.cornerRadius = 8
        self.viewSongUrl.layer.cornerRadius = 5
        self.setBorderColor(view: self.viewSongUrl, color: AppColors.darkBlue, width: 1)
        self.showMarkers()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.btnMenu.isHidden = true
            container.btnBack.isHidden = false
            container.lblTitle.text = "Set Song"
        }
        getAddressFromGeocodeCoordinate(coordinate: self.locationManager.location!.coordinate)
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
            if(self.isTrackAvalible){
                self.GetClientAccessToken()
            }else{
                if(isSongsUrl){
                    
                }else{
                   self.songUrl = URL(string: self.txtSongUrl!.text!)!
                }
                self.UploadSong()
            }
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
        
        self.dismiss(animated: true, completion: nil)
        
        print("you picked: \(mediaItemCollection)")
        let item = mediaItemCollection.items[0]
        let assetUrl: URL? = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        if(assetUrl == nil){return}
        self.txtSongUrl.text = "\(assetUrl!)"
        print(self.txtSongUrl.text)
        self.audioSong = item
        print(audioSong)
        
        let songTitle: String = item.value(forProperty: MPMediaItemPropertyTitle) as! String
        self.txtSongName.text = songTitle
        self.exportAssetUrl(assetURL: assetUrl!, title: "/" + songTitle)
        
    }
    func exportAssetUrl(assetURL:URL, title:String)  {
        let ext = TSLibraryImport.extension(forAssetURL: assetURL)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        var outUrl = URL(fileURLWithPath: documentDirectory.appending(title))
        outUrl = outUrl.appendingPathExtension(ext!)
        let tsImport = TSLibraryImport()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        tsImport.importAsset(assetURL, to: outUrl) { (objImport) in
            GCD.async(.Main) {
                self.stopActivity()
            }
            if(objImport!.error == nil){
                self.songUrl = outUrl
                self.isSongsUrl = true
            }
            print(objImport!)
        }
    }
    
}
//MARK:- Brain tree payment method

extension SetSongViewController{
    func postNonceToServer(paymentMethodNonce: String) {
        // Update URL with your server
        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                //                 result.paymentOptionType.rawValue
                self.nonse = result.paymentMethod!.nonce
                self.makeTrackTransactionApi()
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
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
                self.lblAddress.text = "\n \(address.lines![0]) \n"
                self.txtSearch.text = self.lblAddress.text
                
                print(lines)
                
            }
            self.checkTrackAvalible()
        }
    }
    func showMarkers(){
        for song in Global.shared.songList.songList{
            let position = CLLocationCoordinate2D(latitude: Double(song.lat) ?? 0.0, longitude: Double(song.lng) ?? 0.0)
            let marker = GMSMarker(position: position)
            marker.title = song.title
            marker.icon = UIImage(named:"iconMarker")
            marker.map = self.viewGoogleMap
            
        }
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAddressFromGeocodeCoordinate(coordinate: mapView.camera.target)
    }
}
//MARK:- Upload Song
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
                        let alertController = UIAlertController(title: "", message: responseMessage.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
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
        request.audiokey = "file"
        request.audioPath = self.songUrl!//self.audioSong.assetURL!
        request.id = "\(Global.shared.login.id)"
        request.lat = self.coordinates.latitude
        request.long = self.coordinates.longitude
        request.name = self.txtSongName.text!
        return request
        
    }
    
    
}
//MARK:- Upload Profile Pic
extension SetSongViewController{
    func checkTrackAvalible()  {
        let request = createAvalibleRequest()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = SongService()
            service.CheckTrackAvalible(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        if let list = responseMessage.data as? SongViewModel{
                            self.avalibleSong = list
                            self.btnAddSong.setTitle("PAY USD \(self.avalibleSong.amount)", for: .normal)
                            self.lblAvalible.isHidden = false
                            self.isTrackAvalible = true
                        }
                        
                    case .Failure:
                        self.lblAvalible.isHidden = true
                        self.btnAddSong.setTitle("ADD SONG", for: .normal)
                        self.isTrackAvalible = false
                        // self.showAlertVIew(message: responseMessage.message, title: "")
                        
                    default:
                        print(responseMessage.message)
                        
                    }
                }
                
            })
        }
        
    }
    
    func createAvalibleRequest() -> RequestMessage {
        let request = RequestMessage()
        request.lat = self.coordinates.latitude
        request.long = self.coordinates.longitude
        return request
        
    }
    
}
//MARK:- Get Client Access Token
extension SetSongViewController{
    func GetClientAccessToken()  {
        let request = RequestMessage()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = PaymentService()
            service.getCleintAccessToken(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        self.showDropIn(clientTokenOrTokenizationKey: Global.shared.clientToken)
                        
                    case .Failure:
                        self.showAlertVIew(message: responseMessage.message, title: "")
                        
                    default:
                        print(responseMessage.message)
                        
                    }
                }
                
            })
        }
        
    }
}

//MARK:- Make Track Transaction Api
extension SetSongViewController{
    func makeTrackTransactionApi()  {
        let request = createTrack()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = SongService()
            service.MakeTrackTransaction(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        let alertController = UIAlertController(title: "", message: responseMessage.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        

                    case .Failure:
                        self.showAlertVIew(message: responseMessage.message, title: "")
                        
                    default:
                        print(responseMessage.message)
                        
                    }
                }
                
            })
        }
        
    }
    func createTrack() -> RequestMessage {
        let request = RequestMessage()
        request.audiokey = "file"
        request.audioPath = self.songUrl!//self.audioSong.assetURL!
        request.userID = Global.shared.login.id
        request.songID = "\(self.avalibleSong.id)"
        request.lat = self.coordinates.latitude
        request.long = self.coordinates.longitude
        request.name = self.txtSongName.text!
        request.nonse = self.nonse
        request.price = self.avalibleSong.amount
        return request
        
    }
    
    
}
