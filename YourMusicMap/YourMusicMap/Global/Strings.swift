
import Foundation


//struct ApplicationColor {
//    static let DarkBrownColor = UIColor(red: 175/255, green: 17/255, blue: 0, alpha: 1)
//    static let DarkGrayColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
//    static let LightGrayColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
//}

let TERMS_AND_CONDITION = "I agree to the Temrs & Conditions of User Agreement & Privacy Policy"
struct Menu {
    static let MENU_LIST = [["title":"Home","image":"iconHome"],["title":"Songs","image":"iconSongs"],["title":" Log Out","image":"iconLogout"]]
}


struct ControllerIdentifier {
    static let LoginViewController = "LoginViewController"
    static let SignUpViewController = "SignUpViewController"
    static let SWRevealViewController = "SWRevealViewController"
    static let HomeNavigationController = "HomeNavigationController"
    static let SetSongViewController = "SetSongViewController"
    static let ProfileNavigationController = "ProfileNavigationController"
    static let UploadImageViewController = "UploadImageViewController"

}
struct StoryboardName {
    static let Main = "Main"
    static let Registration = "Registration"
    
    
}
struct  NIBName {
   
}

struct  CellIdentifier {
    static let SideMenuTableViewCell = "SideMenuTableViewCell"
    static let SideMenuProfileTableViewCell = "SideMenuProfileTableViewCell"
    
}

struct GoogleMap{
    static let API_KEY = "AIzaSyDqnJ4wFLv1fP2_E3rDkpvFg8G9gVCh9h0"
}
struct NavigationTitles {
  
}
struct AlertViewTitle {
    static let Google = "Google"
    static let FaliedSocialLogin = "Unable to Login"
}
struct SocialLogin {
    static let FacebookProfileParams = ["fields": "id, email, first_name, gender, last_name, location, hometown, picture.type(large)"]
}


struct WebUrls {
    
}




struct CameraService {
    static let title = "Camera Service Off"
    static let message = "Turn on Camera in Settings > Privacy to allow Nafees to determine your Camera"
}

struct LocationService {
    static let ServiceOff = "Location Service Off"
    static let AllowLocationMessage = "Turn on Location in Settings > Privacy to allow My LUMS to determine your Location"
    static let Settings = "Settings"
}
struct Messages{
    static let Fill_All_Fields = "Fill all Fields"
    static let Valid_Email = "Please Enter a Valid Email"
    static let Location_Title = "Location Permission Required"
    static let Location_Message = "Please enable location permissions in settings."
    static let No_Camera = "You don't have camera"
    static let Terms_Condition = "Please select terms and conditions"
    static let Password_Not_Match = "Password does not match"
}
