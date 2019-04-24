//
//  HomeViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON


class HomeViewController: BaseViewController,TopBarDelegate {
   
    @IBOutlet weak var viewGoogleMap : GMSMapView!
    @IBOutlet weak var btnSetSong : UIButton!
    @IBOutlet weak var btnListenSong : UIButton!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var currentLocation : CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    var polyline : GMSPolyline?
    var moveToLocation : Bool = false
    
    
    override func viewDidLoad() {
        cameraMoveToLocation(toLocation: self.locationManager.location?.coordinate)
        //self.lblMarkerTitle.numberOfLines = 0
        locationManager.delegate = self
        self.btnSetSong.layer.cornerRadius = 8
        self.btnListenSong.layer.cornerRadius = 8
        self.viewGoogleMap.delegate = self
        self.viewGoogleMap.isMyLocationEnabled = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.btnMenu.isHidden = false
            container.btnBack.isHidden = true
            container.btnEdit.isHidden = true
            container.lblTitle.text = "Set Song"
        }
        self.GetSongsList()
    }
    func actionCallBackMoveBack() {
        
    }
    func actionCallBackEdit(){
        
    }
    

    
    //MARK:- Actions
   
    @IBAction func actionSetSong(_ sender:Any){
       let storyboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SetSongViewController) as? SetSongViewController
        vc?.locationManager = self.locationManager
       // vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    //Adding song on Map
    @IBAction func actionListenSong(_ sender:Any){
        if let container = self.mainContainer{
            container.showSongList()
        }
    }
    @IBAction func actionCurrentLocation(_ sender:Any){
        self.cameraMoveToLocation(toLocation: self.currentLocation)
    }


}
//MARK:- User Location Delegates
 extension HomeViewController: CLLocationManagerDelegate,GMSMapViewDelegate{
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                
                let alertController = UIAlertController(title: ACCESS_LOCATION_ALERT, message: ACCESS_LOCATION_MESSAGE, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                    }
                    self.cameraMoveToLocation(toLocation: self.locationManager.location?.coordinate)
                    self.locationManager.startUpdatingLocation()
                    self.currentLocation = self.locationManager.location?.coordinate
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.delegate = self
                cameraMoveToLocation(toLocation: locationManager.location?.coordinate)
                self.locationManager.startUpdatingLocation()
                self.currentLocation = self.locationManager.location?.coordinate
                break
            case .notDetermined:
                break
            }
        }
        
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if(self.moveToLocation){

            }else{
            let location = locationManager.location?.coordinate
            self.currentLocation = location
                cameraMoveToLocation(toLocation: location)
                self.moveToLocation = true
            }
        }
    
        func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {

            if toLocation != nil {
                self.viewGoogleMap.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 12)
                // showMarkers()
            }
        }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        drawMap(marker: marker)
        return true
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
    //MARK:- Draw Route
    func drawMap (marker:GMSMarker)
    {
        
        let origin = "\(self.currentLocation!.latitude),\(self.currentLocation!.longitude)"
        let destination = "\(marker.layer.latitude),\(marker.layer.longitude)"
        print(destination)
        print(origin)
        let str = String(format:"https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(GoogleMap.API_KEY)")
        GCD.async(.Main){
            self.startActivityWithMessage(msg: "")
        }
        
        Alamofire.request(str).responseJSON { (responseObject) -> Void in
            GCD.async(.Main){
                self.stopActivity()
            let resJson = JSON(responseObject.result.value!)
            print(resJson)
            
            if(resJson["status"].rawString()! == "ZERO_RESULTS")
            {
                
            }
            else if(resJson["status"].rawString()! == "NOT_FOUND")
            {
                
            }
            else{
                
                let routes : NSArray = resJson["routes"].rawValue as! NSArray
                print(routes)
                self.viewGoogleMap.clear()
                self.showMarkers()
                //self.viewGoogleMap.clear()
                let position = CLLocationCoordinate2D(latitude:self.currentLocation!.latitude, longitude:self.currentLocation!.longitude)
                
                let marker = GMSMarker(position: position)
                marker.icon = UIImage(named: "iconMarker")
                marker.map = self.viewGoogleMap
                
                let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                print(pathv)
                let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                print(paths)
                let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                
                let position2 = CLLocationCoordinate2D(latitude:marker.layer.latitude, longitude:marker.layer.longitude)
                let polyLine = GMSPolyline(path: newPath)
                polyLine.strokeWidth = 5
                polyLine.strokeColor = UIColor.blue
                polyLine.map = self.viewGoogleMap
                
                let bounds = GMSCoordinateBounds(coordinate:position , coordinate: position2)
                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 300, left: 370, bottom: 300, right: 70))
                
//                self.viewGoogleMap.camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude, zoom: 40)
                self.viewGoogleMap!.moveCamera(update)
                self.viewGoogleMap.animate(toZoom: 13)
                
                
            }
            }
            
        }
    }
}
//MARK:- Get Orders Api
extension HomeViewController{
 
    
    func GetSongsList()  {
        let request = RegistrationRequst()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = SongService()
            service.getSongs(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        if let list = responseMessage.data as? SongListViewModel{
                            Global.shared.songList = list
                            self.showMarkers()
                        }
                        
                    case .Failure:
                        self.showAlertVIew(message: responseMessage.message, title: "")
                        
                    default:
                        print(responseMessage.message)
                        
                    }
                }
                
            })
        }
        
    }
    func RegistrationRequst() -> RequestMessage {
        let request = RequestMessage()
        request.id = "\(Global.shared.login.id)"
        print(request.id)
        return request
        
    }
    
    
}

