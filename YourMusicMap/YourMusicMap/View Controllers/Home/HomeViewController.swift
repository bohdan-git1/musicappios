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

class HomeViewController: BaseViewController,TopBarDelegate {
   
    @IBOutlet weak var viewGoogleMap : GMSMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var currentLocation : CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    var polyline : GMSPolyline?
    
    
    override func viewDidLoad() {
        cameraMoveToLocation(toLocation: self.locationManager.location?.coordinate)
        //self.lblMarkerTitle.numberOfLines = 0
        locationManager.delegate = self
        self.viewGoogleMap.delegate = self
        self.viewGoogleMap.settings.myLocationButton = true
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
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    //Adding song on Map
    @IBAction func actionListenSong(_ sender:Any){
        
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
                break
            case .notDetermined:
                break
            }
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locationManager.location?.coordinate
            self.currentLocation = location
            cameraMoveToLocation(toLocation: location)
        }
        
        func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
            
            if toLocation != nil {
                self.viewGoogleMap.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
                // showMarkers()
            }
        }
//        func showMarkers(){
//            for cordinate in Cordinates.CordinatList{
//                let position = CLLocationCoordinate2D(latitude:cordinate["lat"] as! CLLocationDegrees , longitude: cordinate["long"] as! CLLocationDegrees)
//                let marker = GMSMarker(position: position)
//                marker.title = cordinate["title"] as? String
//                marker.icon = UIImage(named: cordinate["image"] as! String)
//                marker.map = self.viewGoogleMap
//                self.viewGoogleMap.settings.myLocationButton = true
//
//            }
//        }
}

