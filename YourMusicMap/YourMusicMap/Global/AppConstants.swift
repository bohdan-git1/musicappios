import Foundation
import UIKit
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X_All = (UIDevice.current.userInterfaceIdiom == .phone && (ScreenSize.SCREEN_MAX_LENGTH == 812 || ScreenSize.SCREEN_MAX_LENGTH == 896))
    static let IS_IPHONE_X = (UIDevice.current.userInterfaceIdiom == .phone && (ScreenSize.SCREEN_MAX_LENGTH == 812))
    static let IS_IPHONE_X_MAX = (UIDevice.current.userInterfaceIdiom == .phone && (ScreenSize.SCREEN_MAX_LENGTH == 896))
}

var TOP_BAR_HEIGHT:CGFloat = 54
var BOTTOM_BAR_HEIGHT:CGFloat = 54

let GOOGLE_API_KEY = "24924961608-ckqauq2fl5sbopc7u4f3mofkok2tan2h.apps.googleusercontent.com"

let CUSTOMER_ALREADY_REGISTERED = "Customer Email / Phone is Already Registered."
let STRING_SUCCESS = ""
let STRING_UNEXPECTED_ERROR = ""
let TIMEOUT_MESSAGE = "Request Time out"
let ERROR_NO_NETWORK = "Internet connection is currently unavailable."
let FILL_ALL_FIELDS_MESSAGE = "Please fill all fields"
let PLEASE_SELECT_FILTER_MESSAGE = "Please select filters"
let PLEASE_SELECT_RECIPIENT = "Please select recipient"
let ACCESS_LOCATION_MESSAGE = "Please enable location permissions in settings."
let ACCESS_LOCATION_ALERT = "Location Permission Required"

let LOGOUT_TITLE = "Logout Successful"
let LOGOUT_MESSAGE = "You have signed out Successfully from the My LUMS App."
let LOGIN_TITLE = "Login Successful"
let LOGIN_MESSAGE = "You have signed in Successfully to the My LUMS App."
let ACCEPT_REQUEST = "You have accepted this job,So please keep open this application until you reached at the location"
let ARRIVED_AT_LOCATION = "Great! You arrived at location. Please press job Complete when you complete your job"

let FAILED_MESSAGE = "Failed Please Try Again!"
let ENTER_EMAIL_MESSAGE = "Please enter email"
let ENTER_MESSAGE = "Please enter message"
let MEMBER_REGISTERED_MESSAGE = "Member Registerd Successfully"
let VALID_PHONE_MESSAGE = "Please enter valid phone number"
let VALID_EMAIL_MESSAGE = "Please enter valid email"
let VALID_EMAIL_AND_ROLL_NO_MESSAGE = "Please verify email and roll no"
let VALID_CNIC_MESSAGE = "Please enter valid CNIC"
let VALID_PASSWORD_LENGTH = "Please enter password of minimum 6 digit length"
let VALID_PASSWORD_MESSAGE = "Password and confirm password must be same"
let VALID_PINCODE_MESSAGE = "Pincode and confirm pincode must be same"
let VALID_LOCATION_MESSAGE = "Please select both Locations"
let VALID_TERMS_AND_CONDITION_MESSAGE = "Please check terms and conditions"
let PROFILE_UPDATED_MESSAGE = "Profile Updated Successfuly"
let MESSAGE = "Message"
let EMAIL_VERIFICATION_MESSAGE = "Your email address does not match our database. Kindly try again or contact"
let ROLL_NO_VERIFICATION_MESSAGE = "Your roll number does not match our database. Kindly try again or contact"

let EMAIL_REGULAR_EXPRESSION = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let COPIED_TO_CLIP_BOARD = "Copied to Clip Board"
let SHARE_TEXT = "Let me recommend you this application\n\n https://itunes.apple.com/pk/app/mylums/id959379869?mt=8/"

let PRIVACY_POLICY_URL = "http://lums.creative-dots.com/privacy-policy"
let TERMS_AND_CONDITION_URL = "http://lums.creative-dots.com/terms-and-conditions"
let REQUESTING_SERVICE = "Get Locky is requesting abraham. You have selected MISC for the job type, So pricing will determined by mutual agreement between you and locky. Other vise you have to pay minimum visit charges."
let JOB_COMPLETE_MESSAGE = "Thank you for choosing Get Locky for the services. Your job has been completed please pay $30 for services"

let KEEP_SAVE_MENU_KEY = "saveMenu"
let USER_LOGIN_DATA = "UserLoginData"
let LOGIN_KEY = "login"
let TOKEN_KEY = "token"
let FCM_TYPE = "200"


let PRINT_API_RESPONSE = false

let URL_GET_ALUMNI_LIST             = "alumni/all"


//let BASE_LOGIN_URL                      = "https://61bda9f0bb1ff7a80248aa5b5e030808:f8523ccebb724999a1b48eb27eb903f9@nafees-of-mirpur.myshopify.com/account/login?mobile=yes"





let BASE_URL = "http://mashghol.com/yourmusicmap/public/api/"

//let URL_GET_ALL_CUSTOMERS               = "customers.json"
//let URL_GET_ALL_PRODUCTS                = "products.json"
//let URL_GET_ALL_CATEGORIES              = "custom_collections.json"
//let URL_GET_ALL_ORDERS                  = "orders.json?customer_id="
//let URL_PLACE_ORDER                     = "orders.json"






let URL_UPLOAD_SONG = "add_song_on_location"
let URL_LOGIN = "login"
let URL_Signup = "signup"
let URL_CREATE_ACCOUNT = "create_customer"


let kFacebookURL = "fb://"
let kTwitterURL = "twitter://"
let kInstagramURL = "instagram://app"



struct AppColors
{
    static let darkBlue = UIColor(red: 46/255, green: 116/255, blue: 198/255, alpha: 1.0)
    //static let orange = UIColor(red: 255/255, green: 139/255, blue: 0/255, alpha: 1)
    //static let borderGray = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.7)
}
