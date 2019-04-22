import Foundation

enum MenuType:String {
    case Category = "category"
    case Products = "products"
    case BundleOffer = "bundleOffer"
}

enum Gender:String{
    case MALE = "Male"
    case FEMALE = "Female"
}

enum PrefferedLanguage: String{
    case English = "English"
    case Arabic = "Arabic"
    
}
enum ColorType: String {
    case blue = "BB0F20"
    case textColor = "555555"
}
enum Tabs: String{
    case Notification = "Notifications"
    case NewsFeeds = "News Feeds"
    case Browser = "Browser"
    case CheckVote = "Check Vote"
}
enum ProductType : String{
    case Cake = "cake"
    case Burger = "burger"
    case Pizza = "pizza"
}
enum NotificationType:String {
    case Message = "message"
    case Notification = "notification"
    case Tinder = "tinder"
    case Event = "event"
    case Discount = "discount"
}
enum TabsStatus:String {
    case CheckedIn = "Checked in"
    case Going = "Going"
    case Interested = "Interested"
    case Default = "Default"
    case NotInterested = "NotInterested"
    case CheckIn = "CheckIn"
}
enum MessageType:String {
    case UnRead = "unread"
    case Archive = "archive"
    case Read = "read"
}
