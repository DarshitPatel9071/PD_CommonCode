//
//  String Extension.swift
//  Bibal
//
//  Created by Darshit Patel on 28/04/23.
//

import Foundation
import UIKit
import AVKit

//MARK: - ************* String *****************
extension String{
    
    // get expected height for string
    func getHeightForString(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    // get expected Width for string
    func getWidthForString(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    // Remove Extra Whit Space from leading and trailing
    func removeWhiteSpaceLeadingTralling() -> String{
        var newStr = self
        while newStr.first == " " {
            newStr = "\(newStr.dropFirst())"
        }
        
        while newStr.last == " " {
            newStr = "\(newStr.dropLast())"
        }
        
        return newStr
    }
    
    // open given url
    func openURL(){
        if let openUrl = URL(string: self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        {
            openUrl.openURL()
        }
    }
    
    // hex to string
    func toUIColor() -> UIColor {
        return UIColor.fromHEX(hex: self)
    }
    
    // text to speak
    func speakText(){
        let utterance = AVSpeechUtterance(string: self)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1
        utterance.rate = 0.4
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    // Generate QR Code
    func toQRCode(color:UIColor = .black) -> UIImage {
        if let data = self.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) {
            let size : CGSize = CGSize(width: 500, height: 500)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")!
            
            filter.setValue(data, forKey: "inputMessage")
            let filterFalseColor = CIFilter(name: "CIFalseColor")
            filterFalseColor?.setDefaults()
            filterFalseColor?.setValue(filter.outputImage, forKey: "inputImage")
            
            // convert method
            let cgColor: CGColor? = color.cgColor
            let qrColor: CIColor = CIColor(cgColor: cgColor!)
            let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
            filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")
            
            let qrcodeCIImage = filter.outputImage!
            
            if let image = filterFalseColor?.outputImage {
                let transform = CGAffineTransform(scaleX: 15.0, y: 15.0)
                return UIImage(ciImage: image.transformed(by: transform),scale: 1.0,orientation: UIImage.Orientation.up)
            } else {
                let cgImage = CIContext(options:nil).createCGImage(qrcodeCIImage, from: qrcodeCIImage.extent)
                UIGraphicsBeginImageContext(CGSize(width: size.width * UIScreen.main.scale, height:size.height * UIScreen.main.scale))
                let context = UIGraphicsGetCurrentContext()
                context!.interpolationQuality = .none
                
                context?.draw(cgImage!, in: CGRect(x: 0.0,y: 0.0,width: context!.boundingBoxOfClipPath.width,height: context!.boundingBoxOfClipPath.height))
                
                let preImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let qrCodeImage = UIImage(cgImage: (preImage?.cgImage!)!, scale: 1.0/UIScreen.main.scale, orientation: .downMirrored)
                
                return qrCodeImage
            }
        }
        return UIImage(named: "ic_CreateQR")!
    }
    
    // Copy Text
    func copyText(){
        UIPasteboard.general.string = self
        CustomToast.toastMessage(message: "Copied", duration: 2, type: .SUCCESS)
    }
}

//MARK: - ************* Common String Var *****************
extension String{
    
    static let str_Allow = "Allow"
    static let str_Enable = "Enable"
    static let str_Cancel = "Cancel"
    static let str_DontAllow = "Don't Allow"
    
    static let per_CommonTitle = "'\(AppInformation.AppName)' Would Like to Access %@ Permission"
    static let per_CommonDes = "Please allow permission from setting"
    static let per_NotificationTitle = "'\(AppInformation.AppName)' Would Like to Send You Notifications"
    static let per_NotificationDes = "Notifications may include alerts,sounds and icon badges. These can be configured in Settings."
    static let per_LocationDisbledTitle = "Turn On Location Services to Allow '\(AppInformation.AppName)' to Determine Your Location"
    static let per_LocationTitle = "Allow '\(AppInformation.AppName)' to use your location?"
    static let per_LocationDes = "App need to location for find nearby wifi connection's"
    static let per_AvDeviceTitle = "'\(AppInformation.AppName)' Would Like to Access the Camera"
    static let per_AvDeviceDes = "App need your camera for scan QR code"
    static let per_PHPhotoLibraryTitle = "'\(AppInformation.AppName)' Would Like to Access Your Photos"
    static let per_PHPhotoLibraryDes = "App need your photo library for scan QR code"
    
    
    static let msg_SomethingWrong = "Something went wrong, please try again"
    
    // Lottie JSON Animation
    static let customLoader = "loader_animation"
    
}
/*extension String{
    
    // Common String Const
    static let str_Share = "Share"
    static let str_Continue = "Continue"
    
    
    static let str_Yes = "YES"
    static let str_No = "NO"
    static let str_Ok = "OK"
    static let str_Connect = "Connect"
    static let str_Delete = "Delete"
    static let str_Change = "Change"
    
    static let str_AppReview = "Review Dialouge"
    static let str_AppShareText = "\(AppInformation.appName) :- \(AppInformation.shareAppLink)"
    
    
    // App Introduction Screen
    static let str_AppIntro_1_Title = "A Community-Based WiFi Password Sharing"
    static let str_AppIntro_2_Title = "Become WIFI UNLOCKER"
    static let str_AppIntro_3_Title = "Are You looking for Free WIFI Provider ?"
    
    static let str_AppIntro_1_Des = "App Allows Personal and brands to share their WiFi passwords with the public, and it allows users to find and connect to WiFi networks and may become your customer or follower"
    static let str_AppIntro_2_Des = "Add your WIFI's password for public use and create your brand awareness to uploading your brand banner with password data in community"
    static let str_AppIntro_3_Des = "Find free WIFI networks near your location, and follow Wi-Fi unlocker, meet and visit brand store to create big network"
    
    // In-App purchase
    static let str_RemoveAd = "Remove Ads"
    static let str_Des_RemoveAd = "Enjoy an ad-free experience while using our app!"
    
    // Ask Confirmation Alert
    static let str_Alert = "Alert!!"
    static let str_Success = "Success"
    static let str_AskWifi = "You have wifi network?"
    static let str_AreYouSure = "Are you sure."
    static let str_DeleteConnectionHistory = "You want to delete conection history?"
    static let str_DeletePasswordHistory = "You want to delete password history?"
    static let str_DeleteWifi = "You want to delete this WIFI?"
    static let str_WifiNotConnectedTitle = "Alert! No Wi-Fi hotspot connected"
    static let str_WifiNotConnectedDes = "Connect to the Wi-Fi hotspot and you will be able to add your Wifi"
    static let str_WifiRaiseSave = "Your Wifi Raise Requirement Data is Save..!!"
    static let str_WifiSave = "Your Wifi password Save..!!"
    
    // Private Browser
    static let str_Google = "Google"
    static let str_GoogleURL = "https://www.google.com"
    static let str_Yahoo = "Yahoo"
    static let str_YahooURL = "https://www.yahoo.com"
    static let str_Gmail = "Gmail"
    static let str_GmailURL = "https://www.gmail.com"
    static let str_Instagram = "Instagram"
    static let str_InstagramURL = "https://www.instagram.com"
    static let str_Facebook = "Facebook"
    static let str_FacebookURL = "https://www.facebook.com"
    static let str_Youtube = "Youtube"
    static let str_YoutubeURL = "https://www.youtube.com"
    
    // NetworkAnalyzer
    static let str_NoNetwork = "No Network"
    static let str_NetworkSignal = "Network Signal Strength (dBm)"
    static let str_WifiSignal = "WIFI Signal Strength (dBm)"
    static let str_MobileData = "Mobile Data"
    static let str_MobileSignal = "Mobile Data Signal Strength (dBm)"
    
    // Common Msg
    static let msg_InternetConnection = "Please check internet connection"
    
    static let msg_ServerError = "Internal server error"
    static let msg_PurchaseSuccess = "Purchase Successfully"
    static let msg_RestoreSuccess = "Your restore was successful"
    static let msg_TryAgain = "Please try again after some time"
    static let msg_PhotoSaved = "Photo saved successfully in gallery"
    static let msg_ConnectWifi = "Please connect device with wifi"
    
    static let msg_AccountCreated = "Registration was successful, please log-in"
    static let msg_LoginSuccess = "Logged In Successfully"
    static let msg_AccountDelete = "Your account is deleted successfully"
    static let msg_WifiDelete = "Your wifi deleted successfully"
    
    //Apple Map
    static let str_WifiDetail = "Wifi Detail"
    static let str_JoinWifi = "Join wifi"
    static let str_GetDirection = "Get Direction"
    
    // Community Home
    static let str_UnlockerTitle = "Become WIFI Unlocker"
    static let str_RequirmentTitle = "Raise WIFI Requirement"
    static let str_NearWifiTitle = "WIFI Near Me"
    
    static let str_UnlockerDes1 = "Share your WiFi password with the community and welcome new WiFi users to possibly boosting your business or sales."
    static let str_RequirmentDes1 = "When any member raises a WiFi requirement, all nearby users and WiFi Unlockers to share it with the person in need."
    static let str_NearWifiDes1 = "find the closest WiFi networks with options for password-protected, open"
    
    
    static let str_UnlockerDes2 = "It's a win-win users get free WiFi, and you get more visitors, possibly boosting your business or sales.\n\n(we are working on WIFI UNLOCKER Badge. It will be launch very Soon ) Connecting Communities: Share WiFi, Earn Recognition.\n\nIn today's world, sharing is caring. When it comes to WiFi, sharing your internet connection can make a big difference, not only for you but for others around you. Plus, when you generously share our real WiFi password in our community, you get a special badge called WiFi Unlocker to show your community spirit.\n\nWhy Share Your WiFi?\nSharing your WiFi is like being a good neighbor. It helps people around you stay connected to the internet. This can be a big help when they need to check emails, do schoolwork, or just chat with friends and familv. Sharing also makes vour community stronger. It's like savina, We're all in this together. It helps people get to know each other better and builds a sense of belonging.\n\nThe WiFi Unlocker Badge: A Way to Say Thanks.\n\nTo say thanks for sharing your WiFi, we've created the WiFi Unlocker badge. When you share your real WiFi password with others in our community, you'll get this badge. It shows that you're not just sharing WiFi; you're helping build a better, more connected community.\n\nWhy the WiFi Unlocker Badge Matters\n\nGetting the WiFi Unlocker badge comes with some cool benefits:\n\nRecognition: The badge shows that you're a helpful community member who cares about others.\n\nBuilding Community: Sharing WiFi helps make your community stronger by bringing people together.\n\nMore Visitors: Sharing WiFi can attract more people to your place, like a business or home. This can mean more customers or new friends.\n\nTrust and Friendship: When you share WiFi, you build trust and friendships with your neighbors and fellow community members.\n\nIn a nutshell, sharing vour WiFi is all about being kind and helping your community stay connected. When you share vour real WiFi password in our community, you don't just get better internet; you also earn the WiFi Unlocker badge to show you're a caring community memher so don't wait-ioin us in making stronger, more connected communities today! ( we are working on WIFI UNLOCKER Badge.)"
    
    static let str_RequirmentDes2 = "Raise WiFi Requirements: Strengthening Connectivity\nIntroducing the Raise WiFi Requirement feature an innovative way to enhance connectivity within our community. When any member raises a WiFi requirement, all nearby users and WiFi Unlockers will receive a notification. If vou have WiFi, vou'll have the opportunity to share it with the person in need.\n\nHow Raise WiFi Requirement Works\nImagine a scenario where someone urgently needs an internet connection. They raise a WiFi requirement within our community. Here's what happens next:\n\nNotification: All nearbv users and WiFi Unlockers receive a notification informing them of the WiFi requirement.\n\nOpportunitv to Share: If vou have a WiFi connection, vou'll have the chance to help. You can choose to share your WiFi with the person who raised the requirement.\n\nWhy Raise WiFi Requirement Matters\nThis feature benefits everyone in our community:\nImmediate Help: It allows communitv members to receive quick assistance when they need it the most\nStrengthened Bonds: Sharing WiFi in times of need fosters a sense of unitv and cooperation among community members.\n\nEnhanced Connectivitv: By collectively addressing WiFi requirements, we create a stronger and more reliable network for everyone.\nHow to Be Part of Raise WiFi\nRequirementnJoining this initiative is simple: Enable Notifications: Make sure vou have notifications enabled for our community app to receive Raise WiFi Requirement alerts.\n\nBe Ready to Share: If you have WiFi, be prepared to lend a helping hand when you receive a notification.\n\nIn summary, the Raise WiFi Requirement feature is all about coming together to support each other's connectivity needs. When a member raises a WiFi requirement, nearby users and WiFi Unlockers are alerted, giving you the chance to help your fellow community members stay connected. It's a powerful way to strengthen our bonds and create a more connected community."
    
    
    static let str_NearWifiDes2 = "Introducing the Nearest WiFi from Unlocker Community feature-a game-changer in the world of connectivity. With this feature, users can effortlessly find the closest WiFi networks with options for password-protected, open connections, or paid WiFi availabilitv. Here's a closer look at what this feature offers:\n\nSearch for Nearby WiFi Networks Whether you're on the move or looking for a reliable connection, our Nearest WiFi feature has you covered: Password-Protected WiFi: Find nearby networks that require a password for access. Open Connections: Discover open, public WiFi networks for easy and immediate access. Paid WiFi: Locate paid WiFi options for when you need a secure, high-speed connection.\n\nAccess Location Details\n Want to know more about a specific WiFi hotspot? No problem! This feature provides location details, so you can make an informed choice: Location Information: Get essential details about the WiFi network's location, making it easier to find. Messaging: Communicate directly with WiFi Unlockers to inauire about access or any specific requirements.\nOR Code Access: Use OR codes provided bv WiFi Unlockers to connect seamlesslv. Password Access: If a password is required, it's conveniently provided for you. Map Integration: Our map feature shows you the precise location of the WiFi network. making navigation a breeze. How to Use Nearest WiFi from Unlocker Community\nUnlocking the power of this feature is easy: Search and Select: Enter your criteria- password-protected, open, or paid WiFi-and browse the list of available networks. Access Location Details: Click on a WiFi network to view location details, messaging options, QR codes, and passwords (if needed).\n\nGO and Connect : Use the provided information to connect to the WiFi network of your choice quickly.\n\nIn summary, the Nearest WiFi from Unlocker Community feature puts connectivity in your hands. Whether you're looking for free WiFi, willing to pay for a premium connection, or just seeking the nearest hotspot, this feature has vou covered. With location details, messaging options, QR codes, and passwords all conveniently accessible, connecting to WiFi has never been easier. Say goodbye to connectivity hassles and hello to segmless WiFi access!"
    
    
    // Community Wifi Unlocker
    static let str_SharePasswordTitle = "Share Your Password"
    static let str_ShareOpenWifiTitle = "Share Open Wifi"
    static let str_SharePaidTitle = "Share Paid Wifi"
    
    static let str_SharePasswordDes1 = "Share your Wi-Fi password with others and get your free promotion rewarded.Share your Wi-Fi password and get Free Promotion As a Reward"
    static let str_ShareOpenWifiDes1 = "This means letting anyone use your WiFi without needing a password.It's like Businesses, like cafes, often do this to attract customers."
    static let str_SharePaidDes1 = "If you have a super-fast internet connection and want to earn from it? it's available, and where people can connect."
    
    static let str_SharePasswordDes2 = "Do you have a Wi-Fi network that you're not using all the time? If so, why not share it with others and get rewarded for it?\n\nWith our new app, you can share your Wi-Fi password with anyone in the world. When someone connects to your network, they'll see a banner with your branding on it. You can use this banner to promote your business, website, or anything else you like.\n\nTo get started, simply create an account and add your Wi-Fi network. You can then share the password with anyone you want. When someone connects to our network, thevIl see your banner and be able to learn more about you.\n\nHere are some of the benefits of sharing your Wi-Fi password:\n\nYou can help others get online for free. You can promote your business or website to a wider audience.\n You can earn rewards for sharing your password.\n So what are you waiting for? Add Your Branding Banner and Password of your WIFI today and start sharing your Wi-Fi password with the world!\n\nHow it works\n\nOpen Our app and Go wifi password sharing community.\n Share the password with Public use and Upload your branding banner.\n When someone connects to your network, they'll see your banner.\n You can get free promotion as a rewards for sharing your password.\n\nPrivacy\n\nWe take your privacy very seriously. We will never share our personal information with anyone without your consent.\n\nWhen you share your Wi-Fi password, we only collect the following information:\n\nThe name of your Wi-Fi network.\n The password for your Wi-Fi network.\n We use this information to track how manv people are connecting to your network and to send you rewards.\n\nTerms and conditions\n By using our app, you agree to our terms and conditions. You can read our terms and conditions also."
    
    static let str_ShareOpenWifiDes2 = "You can also add your own style to the WiFi by making it look unique and welcoming.\n\nWhy Share Open WiFi:\n\nSharing an open WiFi connection is a great way to create a welcoming and friendly atmosphere, especially in public places like cafes, restaurants, or waiting areas. Here's why it's a good idea:\n\nAttract More Visitors: By providing free and easy internet access, you can attract more people to vour business or space. This can lead to more customers and increased foot traffic. Community Building: It fosters a sense of community and goodwill. People appreciate free WiFi, and by offering it, you're helping those in your vicinity stay connected, which can create a positive image for your space. Convenience: It makes life easier for people who might need to check emails, browse the web, or use apps while they're at your place. They don't have to worry about data limits or hunting for a WiFi hotspot."
    
    static let str_SharePaidDes2 = "It's like running a mini internet service. You can make it more appealing by adding your own touch. like a cool banner and a friendly message to attract users. It can even help your business earn some extra income!\n\nWhy Share Paid WiFi Detail:\n Sharing information about paid WiFi services can also be beneficial for various reasons: Generate Income: If you have a high-speed internet connection, you can earn extra income by offering it as a paid service. This is especially useful if you run a business or provide services in an area with limited connectivity options.\n\nEnhanced Service: Offering a paid WiFi service can set you apart from competitors and enhance your customer experience. People are willing to pay for a reliable and fast internet connection.\n Control and Security: You can have more control over who uses your network, ensuring that it's only accessible to those who pav. This can help you manage network usage and maintain security.\n Customization: Just like with open WiFi, you can personalize our paid WiFi with a unique brand banner and a welcoming message to make it more appealing to users.\n In summary, sharing open WiFi is a friendlv gesture that attracts visitors and builds community spirit, while sharing paid WiFi details can help you earn income, provide a better service and maintain control over network access. Both options have their advantages, depending on your qoals and circumstances."
    
    
    static let info_WifiBanner = "Share your brand banner with visitors.upload your place image."
    static let info_WifiMessaegForUser = "Create enticing messages to attract WiFi users to your store, Like Some offer detail."
    static let info_WifiQR = "You can upload a QR code here for users; no need to physicallv place it on a wall, simply share it digitally."
    static let info_SpaceAtmosphere = "Please provide useful details about your space for users to understand it better."
    
    
    
    // Common validation Msg
    static let val_UserName = "Username contains 5 to 15 characters"
    static let val_WifiName = "Wifi Name contains 2 to 32 characters"
    static let val_WifiPassword = "Wifi password contains 8 to 15 characters"
    static let val_EmailAddress = "Please enter valid email address"
    static let val_WrongEmail = "Email address is wrong, please enter correct email address"
    static let val_Password = "Password must contain 8 to 15 characters with 1 lower case letter, 1 upper case letter, 1 numeric character, 1 special character"
    static let val_ConfirmPassword = "Both the password and confirm password must be matched"
    static let val_WrongPassword = "Password is wrong, please enter correct password"
    static let val_AgreeTerms = "Please agree to our terms of use and privacy policy"
    static let val_EnterText = "Please enter any text"
    static let val_WIFIQr = "Incorrect Qr Code! Please try again"
    static let val_SpaceAtmosphere = "Please select space atmosphere"
    
    
    // Common Permission
    

    

    
    
    // Userdefualt Key
    static let udKey_IsCommunityIntroDone = "udKey_IsCommunityIntroDone"
    static let udKey_IsRemoveAllAds = "isRemoveAllAds"
    static let udKey_LoginUserDetail = "loginUserDetail"
    static let udKey_IsShowRateUsAlert = "IsShowRateUsAlert"
    static let udKey_NotificationID = "NotificationID"
    static let udKey_IsOfflineModeOn = "IsOfflineModeOn"
    
    // NSNotification Name
    static let noti_AppWillEnterForeground = "AppWillEnterForeground"
    static let noti_NetworkStatusChange = "networkStatusChange"
    static let noti_GoogleAdIdGet = "googleAdIdGet"
    static let noti_PurchasedSuccess = "PurchasedSuccess"
    
    
    // Lottie JSON Animation
    static let lottie_Loader = "LoaderAnimation"
    static let lottie_Splash = "SplashAnimation"
}*/

//MARK: - ************* Common String Var *****************
extension String{
    func toDictionary() -> [String:Any]{
        if let data = self.data(using: .utf8) {
            do {
                let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return dic ?? [:]
            } catch {
                print("--> ERROR toJSON :- ",error.localizedDescription)
            }
        }
        return [:]
    }
    
    /*func fullLessText(isFull:Bool) -> NSAttributedString?{
        let fullTxt = self
        let arrFullTxt = self.components(separatedBy: " ")
        let lessCount = arrFullTxt.count > 10 ? 10 : arrFullTxt.count / 10
        let lessTxt = arrFullTxt[0..<lessCount].joined(separator: " ")
        
        let normalFont:[NSAttributedString.Key : Any] = [.foregroundColor:UIColor.black,
                                                        .font:CommonFont.getFont(font: .Poppins, withSize: 13)]
        
        let readMoreFont:[NSAttributedString.Key : Any] = [.foregroundColor:UIColor.blue,
                                                           .font:CommonFont.getFont(font: .Poppins, withSize: 13)]
        
        let attStr = NSMutableAttributedString(string: isFull ? fullTxt : lessTxt,attributes: normalFont)
        if !isFull{
            attStr.append(NSAttributedString(string: " Read more...",attributes: readMoreFont))
        }
        
        return attStr
    }*/
}
