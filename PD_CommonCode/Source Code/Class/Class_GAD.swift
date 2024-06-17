//
//import Foundation
//import GoogleMobileAds
//import Alamofire
//import UserMessagingPlatform
//import FirebaseRemoteConfig
//
//class ClassGAD : NSObject{
//    //MARK: - PUBLIC VARIABLE'S
//    static let shared:ClassGAD = ClassGAD()
//    
//    //MARK: - PRIVATE VARIABLE'S
//    private struct GADIds{
//        static var GAD_AppOpen = ""
//        static var GAD_Banner = ""
//        static var GAD_Interstitial = ""
//        static var GAD_Native = ""
//        static var GAD_Rewarded = ""
//        static var GAD_RewardedInterstitial = ""
//    }
//    
//    private var isInternetConnected:Bool
//    {
//        return NetworkReachabilityManager()?.isReachable ?? false
//    }
//    
//    var isIdSheetEmpty = false
//    
//    private var gadAppOpenAd: GADAppOpenAd?
//    private var gadAppOpenAdRequested = false
//    
//    private var gadInterstitialAd: GADInterstitialAd?
//    private var gadInterstitialAdRequested = false
//    private var gadInterstitialAdDismissed:(() -> Void)?
//    
////    private var gadRewardedAd: GADRewardedAd?
////    private var gadRewardedAdRequested = false
////    private var gadRewardedAdDismissed:((Bool) -> Void)?
//    
//    private var gadRewardedInterstitialAd: GADRewardedInterstitialAd?
//    private var gadRewardedInterstitialAdRequested = false
//    private var gadRewardedInterstitialAdDismissed:((Bool) -> Void)?
//    
//    private var gadNativAdLoader: GADAdLoader!
//    private var gadNativeAdRequested = false
//    private var gadNativeAd: GADNativeAd?
//    private var gadNativAdLoadSuccess:((GADNativeAd?) -> Void)?
//    
//    private var gadBannerView: GADBannerView!
//    private var gadBannerAdRequested = false
//    private var gadBannerAdLoadSuccess:((GADBannerView?) -> Void)?
//    private var gadBannerAdSpcSizeLoadSuccess:((GADBannerView?) -> Void)?
//    
//    private var gadCusSizeBannerView: GADBannerView!
//    
//    private var remoteConfig = RemoteConfig.remoteConfig()
//}
//
////MARK: - PUBLIC FUNCTION'S
//extension ClassGAD{
//    //MARK: ad init function for appdelegate
//    func initGAD(){
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        addTestDevice()
//        startMonitoring()
//        requestConsentInfoUpdate()
//    }
//    
//    //MARK: Load All ad first time
//    func loadAllAd(){
//        
//        loadGADInterstitialAD() //GADInterstitialAD
//        loadGADAppOpenAd() //GADAppOpenAd
////        loadGADRewardedAd() //GADRewardedAd
//        loadGADRewardedInterstitialAd { adLoad in}
//        loadGADNativAd() //GADNativeAd
//        loadGadBannerAd() //GADBannerAd
//    }
//}
//
////MARK: - PRIVATE FUNCTION'S
//extension ClassGAD{
//    
//    // Print all error in
//    private func printLog(_ data:Any){
//    #if DEBUG
//        print("ClassGAD :- ",data)
//    #else
//    #endif
//    }
//    
//    // GADInterstitialAd dismiss or not present
//    private func gadFullScreenPresentingAdDismiss(_ ad: GADFullScreenPresentingAd){
//        if ad.isKind(of: GADInterstitialAd.self){
//            gadInterstitialAd = nil
//            gadInterstitialAdDismissed?()
//            loadGADInterstitialAD()
//        }else if ad.isKind(of: GADAppOpenAd.self){
//            gadAppOpenAd = nil
//            loadGADAppOpenAd()
//        }else if ad.isKind(of: GADRewardedInterstitialAd.self){
//            gadRewardedInterstitialAd = nil
//            gadRewardedInterstitialAdDismissed?(true)
//            gadRewardedInterstitialAdDismissed = nil
//            loadGADRewardedInterstitialAd { adLoad in}
//        }/*else if ad.isKind(of: GADRewardedAd.self){
//            gadRewardedAd = nil
//            gadRewardedAdDismissed?(true)
//            loadGADRewardedAd()
//        }*/
//    }
//    
//    // Monitoring internet connectivity
//    private func startMonitoring() {
//        let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
//        reachabilityManager?.startListening()
//        
//        reachabilityManager?.listener = { _ in
//            let netStatus = reachabilityManager?.isReachable ?? false
//            NotificationCenter.default.post(name: .networkStatusChange, object: nil, userInfo: ["status":netStatus])
//            if netStatus && GADIds.GAD_AppOpen.isEmpty{
////                self.getAdIdsFromSheet()
//                self.getAdIdsFromRemoteConfig()
//            }
//            if netStatus{
//                self.loadAllAd()
//                CoredataManager.manager.addConnectionHistory()
//            }
//        }
//    }
//    
//    // Add test device
//    private func addTestDevice(){
//        var arrTestDevice:[String] = ["00008110-000154313CC0401E"]
//        if let simulatorID = kGADSimulatorID as? String{arrTestDevice.append(simulatorID)}
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = arrTestDevice
//    }
//    
//    // Get Ad id's from sheet
//    /*private func getAdIdsFromSheet(){
//        // G Sheet :- https://docs.google.com/spreadsheets/d/1PDtTnVVZnW6-EW6wM6SNilojQsHQH21w_hIj2Cdqleo/edit#gid=0
//        let tmpUrl = "https://sheets.googleapis.com/v4/spreadsheets/1PDtTnVVZnW6-EW6wM6SNilojQsHQH21w_hIj2Cdqleo/values/Sheet1!B3:Z4?key=AIzaSyBa8lxt2dSjV5aw9RkU0uh38h6jYCI9mm8"
//        
//        isIdSheetEmpty = true
//        
//        if let sheetDataApi = URL(string: tmpUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""){
//            var request = URLRequest(url: sheetDataApi)
//            request.httpMethod = "GET"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            Alamofire.request(sheetDataApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseString)-> Void in
//                
//                if let dicRes = responseString.value as? [String:Any],let allValues = dicRes["values"] as? [[String]],allValues.count > 1{
//                    
//                    let arrAdType = allValues[0]
//                    let arrAdID = allValues[1]
//                    
//                    if let fIndex_InterstitialAd = arrAdType.firstIndex(where: {$0.lowercased() == "interstitial video"}),arrAdID.count > fIndex_InterstitialAd{
//                        GADIds.GAD_Interstitial = arrAdID[fIndex_InterstitialAd]
//                    }
//                    
//                    if let fIndex_NativeAd = arrAdType.firstIndex(where: {$0.lowercased() == "native advanced"}),arrAdID.count > fIndex_NativeAd{
//                        GADIds.GAD_Native = arrAdID[fIndex_NativeAd]
//                    }
//                    
//                    if let fIndex_BannerAd = arrAdType.firstIndex(where: {$0.lowercased() == "banner"}),arrAdID.count > fIndex_BannerAd{
//                        GADIds.GAD_Banner = arrAdID[fIndex_BannerAd]
//                    }
//                    
//                    if let fIndex_AppOpenAd = arrAdType.firstIndex(where: {$0.lowercased() == "app open"}),arrAdID.count > fIndex_AppOpenAd{
//                        GADIds.GAD_AppOpen = arrAdID[fIndex_AppOpenAd]
//                    }
//                    
//                    if let fIndex_RewardedAd = arrAdType.firstIndex(where: {$0.lowercased() == "rewarded"}),arrAdID.count > fIndex_RewardedAd{
//                        GADIds.GAD_Rewarded = arrAdID[fIndex_RewardedAd]
//                    }
//                    
//                    if let fIndex_RewardedIntAd = arrAdType.firstIndex(where: {$0.lowercased() == "rewarded interstitial"}),arrAdID.count > fIndex_RewardedIntAd{
//                        GADIds.GAD_RewardedInterstitial = arrAdID[fIndex_RewardedIntAd]
//                    }
//                    
//                    if let fIndex_Review = arrAdType.firstIndex(where: {$0.contains("Review Dialog")}),arrAdID.count > fIndex_Review{
//                        CommonConst.appReviewAlert = Int(arrAdID[fIndex_Review]) ?? 0 == 1
//                    }
//                    
//                    NotificationCenter.default.post(name: .googleAdIdGet, object: nil)
//                    self.loadAllAd()
//                    
//                    self.isIdSheetEmpty = false
//                }
//            }
//        }else{
//            CustomToast.toastMessage(message: "Something went wrong.Please try again.")
//        }
//    }*/
//    
//    private func requestConsentInfoUpdate(){
//        let parameters = UMPRequestParameters()
//        parameters.tagForUnderAgeOfConsent = false
//        
//        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
//            with: parameters,
//            completionHandler: { [self] error in
//                
//                // The consent information has updated.
//                if error != nil {
//                    printLog("-----> requestConsentInfoUpdate ERROR :- \(error!.localizedDescription)")
//                } else {
//                    let formStatus = UMPConsentInformation.sharedInstance.formStatus
//                    if formStatus == UMPFormStatus.available {
//                        loadUMPConsentForm()
//                    }
//                }
//            })
//    }
//    
//    private func loadUMPConsentForm() {
//        UMPConsentForm.load { [self] (form, loadError) in
//            if let form = form,
//               let topVC = UIApplication.shared.getTopViewController(),
//               UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
//                form.present(from: topVC) { err in
//                    if let err = err{
//                        printLog("-----> form present ERROR :- \(err.localizedDescription)")
//                        return
//                    }
//                }
//                return
//            }
//        }
//    }
//}
//
////MARK: - GADAppOpen's METHOD
//extension ClassGAD{
//    
//    private func getAdIdsFromRemoteConfig(){
//        remoteConfig.fetch(withExpirationDuration: 0) {[self] (status, error) in
//            guard error == nil else { return }
//            remoteConfig.activate()
//            
//            if let str_InterstitialAd = remoteConfig.configValue(forKey: "interstitialAdID").stringValue,!str_InterstitialAd.isEmpty{
//                GADIds.GAD_Interstitial = str_InterstitialAd
//            }
//            
//            if let str_NativeAd = remoteConfig.configValue(forKey: "nativeAdID").stringValue,!str_NativeAd.isEmpty{
//                GADIds.GAD_Native = str_NativeAd
//            }
//            
//            if let str_BannerAd = remoteConfig.configValue(forKey: "bannerAdID").stringValue,!str_BannerAd.isEmpty{
//                GADIds.GAD_Banner = str_BannerAd
//            }
//            
//            if let str_AppOpenAd = remoteConfig.configValue(forKey: "appOpenAdID").stringValue,!str_AppOpenAd.isEmpty{
//                GADIds.GAD_AppOpen = str_AppOpenAd
//            }
//            
//            if let str_RewardedAd = remoteConfig.configValue(forKey: "rewardedAdID").stringValue,!str_RewardedAd.isEmpty{
//                GADIds.GAD_Rewarded = str_RewardedAd
//            }
//            
//            if let str_RewardedIntAd = remoteConfig.configValue(forKey: "rewardedInterstitialAdID").stringValue,!str_RewardedIntAd.isEmpty{
//                GADIds.GAD_RewardedInterstitial = str_RewardedIntAd
//            }
//                                                                   
//            if let str_Review = remoteConfig.configValue(forKey: "Review_Dialog").stringValue,!str_Review.isEmpty{
//                CommonConst.appReviewAlert = Int(str_Review) ?? 0 == 1
//            }
//            
//            NotificationCenter.default.post(name: .googleAdIdGet, object: nil)
//            self.loadAllAd()
//            
//            self.isIdSheetEmpty = false
//        }
//    }
//}
//
////MARK: - GADAppOpen's METHOD
//extension ClassGAD{
//    
//    // load GADAppOpenAd
//    private func loadGADAppOpenAd(){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadAppOpenAd = nil
//            return
//        }
//        
//        
//        if gadAppOpenAd == nil && isInternetConnected && !GADIds.GAD_AppOpen.isEmpty && !gadAppOpenAdRequested{
//            gadAppOpenAdRequested = true
//            
//            GADAppOpenAd.load(withAdUnitID: GADIds.GAD_AppOpen, request: GADRequest(), orientation: .portraitUpsideDown) { [self] (openAd, err) in
//                gadAppOpenAdRequested = false
//                
//                if let error = err {
//                    gadAppOpenAd = nil
//                    printLog("ERROR :- GADAppOpenAd load error: \(error.localizedDescription)")
//                    return
//                }
//                printLog("SUCCESS :- GADAppOpenAd load ")
//                gadAppOpenAd = openAd
//                gadAppOpenAd?.fullScreenContentDelegate = self
//            }
//        }
//    }
//    
//    // Present GADAppOpenAd
//    func presentGADAppOpenAd(isPresent:((Bool) -> Void)? = nil){
//        if let topVC = UIApplication.shared.getTopViewController(),gadAppOpenAd != nil,!CommonConst.isPurchasedRemoveAds{
//            DispatchQueue.main.async() {
//                self.gadAppOpenAd!.present(fromRootViewController: topVC)
//                isPresent?(true)
//            }
//        }
//    }
//    
//}
//
////MARK: - GADInterstitialAD's METHOD
//extension ClassGAD:GADFullScreenContentDelegate{
//    
//    // load GADInterstitialAd
//    private func loadGADInterstitialAD(){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadInterstitialAd = nil
//            return
//        }
//        
//        
//        if gadInterstitialAd == nil && isInternetConnected && !GADIds.GAD_Interstitial.isEmpty && !gadInterstitialAdRequested{
//            gadInterstitialAdRequested = true
//            
//            GADInterstitialAd.load(withAdUnitID:GADIds.GAD_Interstitial,request: GADRequest(),completionHandler: { [self] ad, error in
//                gadInterstitialAdRequested = false
//                
//                if let error = error {
//                    gadInterstitialAd = nil
//                    printLog("ERROR :- GADInterstitialAd load error: \(error.localizedDescription)")
//                    return
//                }
//                
//                printLog("SUCCESS :- GADInterstitialAd load ")
//                gadInterstitialAd = ad
//                gadInterstitialAd?.fullScreenContentDelegate = self
//            })
//        }
//    }
//    
//    // Present GADInterstitialAd
//    func presentGADInterstitialAD(adisDismissed:@escaping (() -> Void)){
//        gadInterstitialAdDismissed = adisDismissed
//        
//        if let topVC = UIApplication.shared.getTopViewController(),gadInterstitialAd != nil,!CommonConst.isPurchasedRemoveAds{
//            gadInterstitialAd!.present(fromRootViewController: topVC)
//        }else{
//            gadInterstitialAdDismissed?()
//        }
//    }
//    
//    internal func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        gadFullScreenPresentingAdDismiss(ad)
//    }
//    
//    internal func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        printLog("ERROR :- GADInterstitialAd present error: \(error.localizedDescription)")
//        gadFullScreenPresentingAdDismiss(ad)
//    }
//}
//
////MARK: - GADNAtive's METHOD
//extension ClassGAD:GADNativeAdDelegate,GADNativeAdLoaderDelegate{
//    // load GADNativeAd
//    private func loadGADNativAd(){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadNativeAd = nil
//            return
//        }
//        
//        
//        if gadNativeAd == nil && isInternetConnected  && !GADIds.GAD_Native.isEmpty && !gadNativeAdRequested{
//            gadNativeAdRequested = true
//            
//            let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
//            multipleAdsOptions.numberOfAds = 1
//            
//            let videoOption = GADVideoOptions()
//            videoOption.customControlsRequested = true
//            
//            gadNativAdLoader = GADAdLoader(adUnitID: GADIds.GAD_Native,
//                                       rootViewController: UIApplication.shared.getTopViewController() ?? UIViewController(),
//                                       adTypes: [.native],
//                                       options: [multipleAdsOptions,videoOption])
//            gadNativAdLoader.delegate = self
//            gadNativAdLoader.load(GADRequest())
//        }
//    }
//    
//    // get loaded native ad
//    func getGADNativeAd(ad:((GADNativeAd?) -> Void)? = nil){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadNativeAd = nil
//            ad?(nil)
//            return
//        }
//        
//        if let gadNativeAd = gadNativeAd{
//            ad?(gadNativeAd)
//        }else{
//            gadNativAdLoadSuccess = ad
//            loadGADNativAd()
//        }
//    }
//    
//    // show native ad
//    func showGADNativeAd(ad:GADNativeAd?,viewNativAd:UIView,btnRemoveAds:((UIButton) -> Void)?){
//        viewNativAd.isHidden = true
//        
//        // Create and place ad in view hierarchy.
//        if let nativeAd = ad,let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil), let nativeAdView = nibObjects.first as? GADNativeAdView{
//            
//            // add nativadview
//            viewNativAd.addSubview(nativeAdView)
//            nativeAdView.translatesAutoresizingMaskIntoConstraints = false
//            
//            let viewDictionary = ["_nativeAdView": nativeAdView]
//            viewNativAd.superview!.addConstraints(
//              NSLayoutConstraint.constraints(
//                withVisualFormat: "H:|[_nativeAdView]|",
//                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
//            )
//            viewNativAd.superview!.addConstraints(
//              NSLayoutConstraint.constraints(
//                withVisualFormat: "V:|[_nativeAdView]|",
//                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
//            )
//            
//            
//            // Title
//            (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
//            nativeAdView.headlineView?.isHidden = nativeAd.headline == nil
//            
//            // Advertiser
//            (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
//            nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
//            
//            // Icon
//            (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
//            nativeAdView.iconView?.isHidden = nativeAd.icon == nil
//            
//            // Star
//            (nativeAdView.starRatingView as? UIImageView)?.image = getStarImgForNativAd(from: nativeAd.starRating)
//            nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
//            
//            // show star if advertiser && starRating are nil
//            if nativeAd.advertiser == nil && nativeAd.starRating == nil{
//                (nativeAdView.starRatingView as? UIImageView)?.image = getStarImgForNativAd(from: 1)
//                nativeAdView.starRatingView?.isHidden = false
//            }
//            
//            // Body
//            (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
//            nativeAdView.bodyView?.isHidden = nativeAd.body == nil
//            
//            // Media
//            nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
//            
//            // callToActionView
//            nativeAdView.callToActionView?.isUserInteractionEnabled = false
//            (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction ?? "Install", for: .normal)
//            
//            // RemoveAds Button
//            if let btnIndex = nativeAdView.subviews.firstIndex(where: {$0.tag == 456}),let btnRemoveAd = (nativeAdView.subviews[btnIndex] as? UIButton){
//                btnRemoveAds?(btnRemoveAd)
//                btnRemoveAd.isUserInteractionEnabled = true
//            }
//            
//            nativeAdView.nativeAd = nativeAd
//            nativeAdView.backgroundColor = .white
//            
//            viewNativAd.isHidden = false
//        }
//    }
//    
//    // Show Native Ad Star
//    private func getStarImgForNativAd(from starRating: NSDecimalNumber?) -> UIImage? {
//      guard let rating = starRating?.doubleValue else {
//        return nil
//      }
//      if rating >= 5 {
//        return UIImage(named: "ic_stars_5")
//      } else if rating >= 4.5 {
//        return UIImage(named: "ic_stars_4_5")
//      } else if rating >= 4 {
//        return UIImage(named: "ic_stars_4")
//      } else if rating >= 3.5 {
//        return UIImage(named: "ic_stars_3_5")
//      } else {
//        return nil
//      }
//    }
//    
//    // Nativ adLoader Receive Ad
//    internal func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
//        printLog("SUCCESS :- GADNativeAd load ")
//        gadNativeAdRequested = false
//        gadNativeAd = nativeAd
//        gadNativeAd!.delegate = self
//        gadNativAdLoadSuccess?(gadNativeAd)
//        gadNativAdLoadSuccess = nil
//    }
//    
//    // Nativ adLoader didfail to Receive ad
//    internal func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
//        gadNativeAdRequested = false
//        gadNativeAd = nil
//        printLog("ERROR :- GADNativeAd load error: \(error.localizedDescription)")
//    }
//    
//    // The native ad was clicked on.
//    internal func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
//        gadNativeAd = nil
//        gadNativAdLoadSuccess?(nil)
//        loadGADNativAd()
//    }
//    
//    //reset banner ad after added in screen
//    func resetNativeAd(){
//        gadNativeAd = nil
//        loadGADNativAd()
//    }
//}
//
////MARK: - GADBanner Ad's METHOD
//extension ClassGAD:GADBannerViewDelegate{
//    // load GADNativeAd
//    private func loadGadBannerAd(){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadBannerView = nil
//            return
//        }
//        
//        if CommonConst.isInternetConnected && !GADIds.GAD_Banner.isEmpty && gadBannerView == nil && !gadBannerAdRequested{
//            gadBannerAdRequested = true
//            
//            let adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 50))
//            gadBannerView = GADBannerView(adSize: adSize)
//            gadBannerView.adUnitID = GADIds.GAD_Banner
//            gadBannerView.rootViewController = UIApplication.shared.getTopViewController() ?? UIViewController()
//            gadBannerView.delegate = self
//            gadBannerView.load(GADRequest())
//        }
//    }
//    
//    // special size banner
//    func loadGadBannerAd(size:CGSize,ad:((GADBannerView?) -> Void)? = nil){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            ad?(nil)
//            return
//        }
//        
//        if CommonConst.isInternetConnected && !GADIds.GAD_Banner.isEmpty{
//            let adSize = GADAdSizeFromCGSize(size)
//            gadCusSizeBannerView = GADBannerView(adSize: adSize)
//            gadCusSizeBannerView.adUnitID = GADIds.GAD_Banner
//            gadCusSizeBannerView.rootViewController = UIApplication.shared.getTopViewController() ?? UIViewController()
//            gadCusSizeBannerView.delegate = self
//            gadCusSizeBannerView.load(GADRequest())
//            gadBannerAdSpcSizeLoadSuccess = ad
//        }else{
//            ad?(nil)
//        }
//    }
//    
//    // get loaded native ad
//    func getGADBannerAd(ad:((GADBannerView?) -> Void)? = nil){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadBannerView = nil
//            ad?(nil)
//            return
//        }
//        
//        if let gadBannerView = gadBannerView{
//            ad?(gadBannerView)
//        }else{
//            gadBannerAdLoadSuccess = ad
//            loadGadBannerAd()
//        }
//    }
//    
//    // banner ad recive success
//    internal func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//        printLog("SUCCESS :- GADBannerView load ")
//        
//        if gadBannerAdSpcSizeLoadSuccess != nil{
//            gadBannerAdSpcSizeLoadSuccess?(bannerView)
//            gadBannerAdSpcSizeLoadSuccess = nil
//            return
//        }
//        
//        gadBannerAdRequested = false
//        bannerView.backgroundColor = .white
//        gadBannerView = bannerView
//        gadBannerAdLoadSuccess?(gadBannerView)
//        gadBannerAdLoadSuccess = nil
//    }
//
//    // banner ad recive fail
//    internal func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        gadBannerAdRequested = false
//        if gadBannerAdSpcSizeLoadSuccess != nil{
//            gadCusSizeBannerView = nil
//        }else{
//            gadBannerView = nil
//        }
//        printLog("ERROR :- GADBannerView load error: \(error.localizedDescription)")
//    }
//    
//    //reset banner ad after added in screen
//    func resetBannerAd(){
//        gadBannerView = nil
//        loadGadBannerAd()
//    }
//}
//
//
////MARK: - GADRewardedAd's METHOD
///*extension ClassGAD{
//    
//    // load GADRewardedAd
//    private func loadGADRewardedAd(){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            gadRewardedAd = nil
//            return
//        }
//        
//        if gadRewardedAd == nil && isInternetConnected && !GADIds.GAD_Rewarded.isEmpty && !gadRewardedAdRequested{
//            gadRewardedAdRequested = true
//            
//            GADRewardedAd.load(withAdUnitID:GADIds.GAD_Rewarded,request: GADRequest(),completionHandler: { [self] ad, error in
//                gadRewardedAdRequested = false
//                
//                if let error = error {
//                    gadRewardedAd = nil
//                    printLog("ERROR :- GADRewardedAd load error: \(error.localizedDescription)")
//                    return
//                }
//                
//                printLog("SUCCESS :- GADRewardedAd load ")
//                gadRewardedAd = ad
//                gadRewardedAd?.fullScreenContentDelegate = self
//            })
//        }
//    }
//    
//    // Present GADInterstitialAd
//    func presentGADRewardedAd(userReward:@escaping(() -> Void),adisDismissed:@escaping ((Bool) -> Void)){
//        gadRewardedAdDismissed = adisDismissed
//        
////        if let topVC = UIApplication.shared.getTopViewController(),gadRewardedAd != nil,!CommonConst.isPurchasedRemoveAds{
//        if let topVC = UIApplication.shared.getTopViewController(),gadRewardedAd != nil{
//            gadRewardedAd!.present(fromRootViewController: topVC) {
//                // user reward success
//                self.printLog("SUCCESS :- GADRewardedAd reward success")
//                userReward()
//            }
//        }else{
//            gadRewardedAdDismissed?(false)
//        }
//    }
//}*/
//
////MARK: - GADRewardedInterstitialAd's METHOD
//extension ClassGAD{
//    
//    // load GADRewardedAd
//    private func loadGADRewardedInterstitialAd(adisLoad:@escaping ((Bool) -> Void)){
//        
//        if CommonConst.isPurchasedRemoveAds{
//            adisLoad(false)
//            return
//        }
//        
//        if gadRewardedInterstitialAd == nil && isInternetConnected && !GADIds.GAD_RewardedInterstitial.isEmpty && !gadRewardedInterstitialAdRequested{
//            gadRewardedInterstitialAdRequested = true
//            
//            GADRewardedInterstitialAd.load(withAdUnitID:GADIds.GAD_RewardedInterstitial,request: GADRequest(),completionHandler: { [self] ad, error in
//                gadRewardedInterstitialAdRequested = false
//                
//                if let error = error {
//                    gadRewardedInterstitialAd = nil
//                    printLog("ERROR :- GADRewardedInterstitialAd load error: \(error.localizedDescription)")
//                    adisLoad(false)
//                    return
//                }
//                
//                printLog("SUCCESS :- GADRewardedInterstitialAd load ")
//                gadRewardedInterstitialAd = ad
//                gadRewardedInterstitialAd?.fullScreenContentDelegate = self
//                adisLoad(true)
//            })
//        }else{
//            adisLoad(false)
//        }
//    }
//    
//    // check ad is ready or not
//    func checkGADRewardedInterstitialAd(userReward:@escaping(() -> Void),adisDismissed:@escaping ((Bool) -> Void)){
//        if gadRewardedInterstitialAd != nil{
//            self.presentGADRewardedInterstitialAd {
//                userReward()
//            } adisDismissed: { isAdDismiss in
//                adisDismissed(isAdDismiss)
//            }
//        }else{
//            self.loadGADRewardedInterstitialAd { isAsLoad in
//                if isAsLoad{
//                    self.presentGADRewardedInterstitialAd {
//                        userReward()
//                    } adisDismissed: { isAdDismiss in
//                        adisDismissed(isAdDismiss)
//                    }
//                }else{
//                    adisDismissed(false)
//                }
//            }
//        }
//    }
//    
//    // Present GADInterstitialAd
//    private func presentGADRewardedInterstitialAd(userReward:@escaping(() -> Void),adisDismissed:@escaping ((Bool) -> Void)){
//        gadRewardedInterstitialAdDismissed = adisDismissed
//        
////        if let topVC = UIApplication.shared.getTopViewController(),gadRewardedAd != nil,!CommonConst.isPurchasedRemoveAds{
//        if let topVC = UIApplication.shared.getTopViewController(),gadRewardedInterstitialAd != nil{
//            gadRewardedInterstitialAd!.present(fromRootViewController: topVC) {
//                // user reward success
//                self.printLog("SUCCESS :- GADRewardedInterstitialAd reward success")
//                userReward()
//            }
//        }else{
//            gadRewardedInterstitialAdDismissed?(false)
//        }
//    }
//}
//
