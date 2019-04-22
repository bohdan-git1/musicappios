import Foundation
//import SDWebImage

class Global {
    class var shared : Global {
        
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    var disableMenuGesture:Bool? = false
    var login = LoginViewModel()
    
  }

