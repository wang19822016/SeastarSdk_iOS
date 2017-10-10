//
//  RewardedVideo.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/9/29.
//
//

import UIKit
import FBAudienceNetwork

class RewardedVideo: NSObject {
    
    typealias ShowVideo = (Bool)->Void
    var showSuccess: ShowVideo? = nil
    
    static let current = RewardedVideo();
    var rewardedVideoAd = FBRewardedVideoAd()
    var placementID:String?
    
    func loadRewardedVideo(loadSuccess:@escaping(Bool)->Void){
        rewardedVideoAd = FBRewardedVideoAd(placementID: placementID!);
        rewardedVideoAd.delegate = self;
        rewardedVideoAd.load();
        showSuccess = loadSuccess;
    }
    
    func showRewardedVideo(){
        rewardedVideoAd.show(fromRootViewController: Global.current.rootViewController!, animated: true);
    }
}

extension RewardedVideo:FBRewardedVideoAdDelegate{
    /**
     Sent after an ad has been clicked by the person.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdDidClick(_ rewardedVideoAd: FBRewardedVideoAd){

    }
    
    
    /**
     Sent when an ad has been successfully loaded.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdDidLoad(_ rewardedVideoAd: FBRewardedVideoAd){
        showRewardedVideo();
    }
    
    
    /**
     Sent after an FBRewardedVideoAd object has been dismissed from the screen, returning control
     to your application.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdDidClose(_ rewardedVideoAd: FBRewardedVideoAd){
    }
    
    
    /**
     Sent immediately before an FBRewardedVideoAd object will be dismissed from the screen.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdWillClose(_ rewardedVideoAd: FBRewardedVideoAd){
    }
    
    
    /**
     Sent after an FBRewardedVideoAd fails to load the ad.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     - Parameter error: An error object containing details of the error.
     */
    public func rewardedVideoAd(_ rewardedVideoAd: FBRewardedVideoAd, didFailWithError error: Error){
        if showSuccess != nil{
            showSuccess!(false);
            showSuccess = nil;
        }
    }
    
    
    /**
     Sent after the FBRewardedVideoAd object has finished playing the video successfully.
     Reward the user on this callback.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdComplete(_ rewardedVideoAd: FBRewardedVideoAd){
        if showSuccess != nil{
        showSuccess!(true);
            showSuccess = nil;
        }
    }
    
    
    /**
     Sent immediately before the impression of an FBRewardedVideoAd object will be logged.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdWillLogImpression(_ rewardedVideoAd: FBRewardedVideoAd){
    }
    
    
    /**
     Sent if server call to publisher's reward endpoint returned HTTP status code 200.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: FBRewardedVideoAd){
    }
    
    
    /**
     Sent if server call to publisher's reward endpoint did not return HTTP status code 200
     or if the endpoint timed out.
     
     - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
     */
    public func rewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: FBRewardedVideoAd){
        if showSuccess != nil{
            showSuccess!(false);
            showSuccess = nil;
        }
    }

}
