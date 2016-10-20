//
//  Facebook.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/28.
//
//

import Foundation

/*
Login权限：
 默认公开权限是：public_profile email user_friends
 public_profile权限内容（允许访问用户公开档案的各版块中所列的信息）：
    id
    name
    first_name
    last_name
    age_range
    link
    gender(访问限制：查询的用户是应用用户；查询的用户正在使用应用，且是应用用户的好友；查询的用户正在使用应用，虽然他并非应用用户的好友，但应用在调用中包含应用访问口令或者带有 appsecret_proof 参数)
    locale(访问限制：查询的用户是应用用户；查询的用户正在使用应用，且是应用用户的好友；查询的用户正在使用应用，虽然他并非应用用户的好友，但应用在调用中包含应用访问口令或者带有 appsecret_proof 参数)
    picture
    timezone(查询的用户即提出请求的用户可以访问)
    updated_time(查询的用户即提出请求的用户可以访问)
    verified
 
 user_friends权限内容（允许访问也在使用您的应用的好友清单。这些好友可在用户对象的好友连线找到）：
    注：要让某用户显示在另外一名用户的好友列表中，这两名用户都必须同意与您的应用分享他们的好友列表，且未在登录流程中拒绝授予该权限。此外，还必须在登录流程中向这两名用户请求授予 user_friends 权限。
 
 
其他权限说明：
 publish_actions：允许代表应用用户发布帖子、开放图谱操作、成就、分数和其他活动。因为该权限可让您代表用户发布内容，所以请阅读开放平台政策，确保自己理解如何正确使用该权限。
 动态发布对话框、请求对话框或“发送”对话框不需要此权限。
 “发送”对话框：用户可使用“发送”对话框向特定好友私密发送内容。他们可以选择将链接作为 Facebook 消息私密分享。
 请求对话框：游戏请求为玩家提供邀请好友玩游戏的机制。玩家可以向一个或多个好友发送请求，请求应始终包含游戏行动号召按钮。接收方可以是现有玩家，也可以是新玩家。
 动态发布对话框：在应用中添加动态发布对话框后，可方便用户将单条动态发布到自己的时间线。通过这种方式发布的内容包括应用管理的说明和内容分享者的个人评论。
 
 publish_pages：能以用户所管理的任何主页的身份发帖、评论和赞。
 
 user_posts：允许访问用户的时间线帖子。
 
 user_photos：允许访问用户上传的或圈出该用户的照片。
 
 
图谱API：
 获取个人主页信息，提供社交元素。
 获取用户信息，例如赞或照片。
 发布帖子（包括视频或照片）到 Facebook。
 发布开放图谱动态到 Facebook。
 
 
 FBSDKShareDialog不用申请权限，分享的内容也可能被fb修改。FBSDKShareAPI需要申请publish_actions，不会被修改内容。
 
分享内容有三种；
 以链接分享的形式分享代表游戏内容（例如：级别、成就等）的轻量级动态。
 分享照片和视频媒体，例如：玩家基地的截图或视频回放。
 发布内容丰富且架构完善的自定义动态，例如：关于完成某个游戏关卡或赢得游戏战斗的动态。
实施分享的方式有二种：
 1.对话框分享(使用fb提供的默认对话框分享)：
 分享对话框适用于网页、iOS 和 Android，让用户能够使用与 Facebook 一致的用户界面分享内容。此外，使用分享对话框还无需实施 Facebook 登录，这让开发者的实施过程变得更简单。
 2.图谱API 分享（需要自己开发分享内容展示窗口，需要开启图谱api设置，需要审核权限）：
 图谱 API 可用于分享链接和自定义开放图谱动态。这种方法还适用于所有平台。使用此 API，您就可以构建自己的用户界面，从而更有力地控制分享体验，但使用此 API 还必须实施 Facebook 登录。
链接分享:
 1.为确保链接在动态消息中展示效果良好，您可以使用开放图谱 (OG) 元数据优化链接。通过 OG 元数据，您可以确定主图片、标题和说明，Facebook 在动态消息中展示链接时会使用到这些内容。
 2.链接目的地。移动平台链接目的地最好设置成应用商店的链接。
照片和视频分享；
 1.可以直接使用图片视频分享，优势：相关内容会在动态消息中以完整的尺寸显示、视频内容会在电脑和移动设备上自动播放；劣势：由于照片/视频体验是针对查看内容而优化的，所以这类动态不会直接吸引太多玩家前往您的游戏。
 2.可以用链接分享。向链接的元数据添加开放图谱视频标签，Facebook 就会在动态消息中显示视频内容。视频不会自动播放。
extra:
 1.如果有特殊分享需求，必须使用图谱API来分享。
 2.分享链接OG设置参考：https://developers.facebook.com/docs/sharing/webmasters。
 3.图谱API使用参考：https://developers.facebook.com/docs/sharing/opengraph。
 
 
 
游戏请求:
 1.游戏请求为玩家提供邀请好友玩游戏的机制。玩家可以向一个或多个好友发送请求，请求应始终包含游戏行动号召按钮。接收方可以是现有玩家，也可以是新玩家。
   游戏请求可用于吸引新玩家或重新吸引现有玩家。请求可在两种情况下发送：
   接收方是发送方的好友且尚未验证游戏。这种情况适合使用邀请。
   接收方是发送方的好友且之前已验证游戏。这种情况适合使用回合制游戏通知、赠送礼物和寻求帮助。
   请求会在fb应用和fb页面内显示，可以自己定制请求页面。
 2.在游戏启动时应该使用图谱api获取所有请求，然后删除请求
*/

/**
 
 在Info.plist文件中添加如下代码，需要替换{your-app-id}
 <key>CFBundleURLTypes</key>
 <array>
 <dict>
 <key>CFBundleURLSchemes</key>
 <array>
 <string>fb{your-app-id}</string>
 </array>
 </dict>
 </array>
 <key>FacebookAppID</key>
 <string>{your-app-id}</string>
 <key>FacebookDisplayName</key>
 <string>{your-app-name}</string>
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>fbapi</string>
 <string>fb-messenger-api</string>
 <string>fbauth2</string>
 <string>fbshareextension</string>
 </array>
 
 */

class Facebook : NSObject, FBSDKSharingDelegate, FBSDKGameRequestDialogDelegate, FBSDKAppInviteDialogDelegate {
  
    typealias FBCB = (Bool)->Void
    
    var shareCaller: FBCB? = nil
    var gameRequestCaller: FBCB? = nil
    var inviteCaller: FBCB? = nil
    var nextFriendInfoPage: String? = nil
    var prevFriendInfoPage: String? = nil
    

    static let current = Facebook()
    
    var loginManager: FBSDKLoginManager {
        return FBSDKLoginManager()
    }
    
    func login(viewController: UIViewController, success:@escaping (String, String)->(), failure:@escaping ()->()) {
        if FBSDKAccessToken.current() != nil {
            // 已经登录状态，不需要再登录
            Log("FB Login has token")
            success(FBSDKAccessToken.current().userID, FBSDKAccessToken.current().tokenString)
        } else {
            
            
            getReadPermissions(viewController: viewController, success: { () in
                success(FBSDKAccessToken.current().userID, FBSDKAccessToken.current().tokenString)
                }, failure: { () in
                failure()
            })
        }
    }
    
    func logout() {
        Log("FB Logout")
        if FBSDKAccessToken.current() != nil {
            loginManager.logOut()
            FBSDKAccessToken.setCurrent(nil)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 需要切换到Facebook应用或者Safari的应调用下面方法
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // 用户轻触邀请中的 Open/Play（打开/试玩）按钮或 Is Ready（准备就绪）安装通知时，将跳转至您的应用。此后将传入应用链接中定义的网址。
        if let parserUrl = BFURL(inboundURL: url, sourceApplication: sourceApplication!) {
            if let appLinkData = parserUrl.appLinkData {
                if appLinkData.count > 0 {
                    if let targetUrl = parserUrl.targetURL {
                        if let urlComponents = URLComponents(url: targetUrl, resolvingAgainstBaseURL: false) {
                            if let queryItems: [URLQueryItem] = urlComponents.queryItems {
                                for item : URLQueryItem in queryItems {
                                    Log("FB Invite link query item: \(item.name) \(item.value)")
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // 需要切换到Facebook应用或者Safari的应调用下面方法
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // 需要fb纪录应用激活事件的调用下面的方法
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    
    // contentURL要分享的链接
    // contentTitle表示链接中的内容的标题
    // imageURL 在帖子中显示的缩略图的网址
    // contentDescription内容描述
    // 注意：如果分享的是iTunes或GooglePlay商店链接，不会发布分享中指定的任何图片和说明，而是通过网络爬虫直接从商店爬到的应用信息。
    func share(viewController controller: UIViewController, contentURL url: String, contentTitle title: String,
               imageURL image: String, contentDescription description: String, caller:@escaping FBCB) {
        
        let contentURL = URL(string: url)
        let imageURL = URL(string: image)
        if contentURL != nil && imageURL != nil {
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = contentURL!
            content.contentTitle = title
            content.contentDescription = description
            content.imageURL = imageURL!
            
            let dialog: FBSDKShareDialog = FBSDKShareDialog()
            dialog.shareContent = content
            dialog.delegate = self
            dialog.fromViewController = controller
            if dialog.canShow() {
                shareCaller = caller
                
                dialog.show()
                return
            }
        }
        
        Log("FB Share Link fail, no url or no permissions")
        caller(false)
    }
    
    // 照片大小必须小于 12MB
    // 用户需要安装版本 7.0 或以上的原生 iOS 版 Facebook 应用
    func share(viewController controller: UIViewController, imageURL url: String, imageCaption caption: String, caller: @escaping FBCB) {
        // userGenerated指定图片是应用产生的
        let photo: FBSDKSharePhoto = FBSDKSharePhoto(imageURL: URL(string: url), userGenerated: true)
        photo.caption = caption
        
        let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
        
        let dialog: FBSDKShareDialog = FBSDKShareDialog()
        dialog.shareContent = content
        dialog.fromViewController = controller
        dialog.delegate = self
        if dialog.canShow() {
            shareCaller = caller
            
            dialog.show()
        } else {
            
            Log("FB Share Photo fail, no permissions")
            caller(false)
        }
    }
    
    // 使用 iOS SDK 提供的好友选择工具启动请求对话框
    func doGameRequest(requestMessage message: String, requestTitle title: String, caller: @escaping FBCB) {
        let gameRequestContent:FBSDKGameRequestContent = FBSDKGameRequestContent();
        gameRequestContent.message = message
        gameRequestContent.title = title
        
        let gameRequestDialog:FBSDKGameRequestDialog = FBSDKGameRequestDialog()
        gameRequestDialog.content = gameRequestContent
        gameRequestDialog.delegate = self
        if gameRequestDialog.canShow() {
            gameRequestDialog.show()
            
            gameRequestCaller = caller
        } else {
            
            Log("FB Game Request fail, no permissions")
            caller(false)
        }
    }
    
    /*
     {
     "data": [
     {
     "id": "REQUEST_OBJECT_ID",
     "application": {
     "name": "APP_DISPLAY_NAME",
     "namespace": "APP_NAMESPACE",
     "id": "APP_ID"
     },
     "to": {
     "name": "RECIPIENT_FULL_NAME",
     "id": "RECIPIENT_USER_ID"
     },
     "from": {
     "name": "SENDER_FULL_NAME",
     "id": "SENDER_USER_ID"
     },
     "message": "ATTACHED_MESSAGE",
     "created_time": "2014-01-17T16:39:00+0000"
     }
     ]
     }
    */
    // 读取接收方所有请求
    func deleteGameRequest() {
        
        if FBSDKAccessToken.current() != nil {
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/apprequests?access_token=\(FBSDKAccessToken.current())", parameters:[:])
            graphRequest.start { connection, data, error in
                if let result = data as? Data {
                    if let json = try? JSONSerialization.jsonObject(with: result, options: .allowFragments) {
                        if let rootDict = json as? [String : Any] {
                            if let invites = rootDict["data"] as? [[String : Any]] {
                                for invite in invites {
                                    if let appInfo = invite["application"] as? [String : Any] {
                                        if let inviteId = invite["id"] as? String, let appId = appInfo["id"] as? String,
                                            appId == FBSDKAccessToken.current().appID {
                                            // 删除请求id
                                            //DELETE https://graph.facebook.com/[{REQUEST_OBJECT_ID}_{USER_ID}]?access_token=[USER or APP ACCESS TOKEN]
                                            let removeRequest = FBSDKGraphRequest(graphPath: "\(inviteId)_\(FBSDKAccessToken.current().userID)?access_token=\(FBSDKAccessToken.current().tokenString)", parameters: [:], httpMethod: "DELETE")!
                                            removeRequest.start(completionHandler: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 应用邀请，邀请好友使用你的应用
    // 应用链接：接收人点击应用邀请页面的 install/play（安装/试玩）按钮时，所打开的应用链接。需要自己制作，在head中添加特定的数据。
    // 预览图片网址: 邀请中所用图片的网址。最好在同一个域名。建议的图片尺寸为 1,200 x 628 像素，高宽比 1.9:1。
    // https://developers.facebook.com/docs/app-invites
    func doAppInvite(viewController controller: UIViewController, appLinkURL linkURL:String, appInvitePreviewImageURL imageURL: String,
                     caller:@escaping (Bool)->Void) {
        let inviteContent = FBSDKAppInviteContent()
        inviteContent.appLinkURL = URL(string: linkURL)!
        inviteContent.appInvitePreviewImageURL = URL(string: imageURL)!
        let inviteDialog = FBSDKAppInviteDialog()
        inviteDialog.delegate = self
        if inviteDialog.canShow() {
            
            inviteCaller = caller
            
            inviteDialog.content = inviteContent
            inviteDialog.show()
        } else {
            caller(false)
        }
    }
    
    func getMeInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        if FBSDKAccessToken.current() != nil {
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": ["id", "name", "picture"]])
            graphRequest.start { connection, result, error in
                if let data = result as? Data, JSONSerialization.isValidJSONObject(data) {
                    let meInfo = String(data: data, encoding: .utf8)
                    Log("FB get me info: \(meInfo).")
                    success(meInfo!)
                } else {
                    Log("FB get me info fail.")
                    failure()
                }
            }
        } else {
            Log("FB not login")
            failure()
        }
    }
    
    func getFriendInfo(height:Int, width:Int, limit:Int, success:@escaping (String)->Void, failure:@escaping ()->Void) {
        if FBSDKAccessToken.current() != nil {
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends",
                                    parameters: ["fields": ["id", "name", "picture.height(\(height)).width(\(width))"], "limit": "\(limit)"])
            graphRequest.start {connection, result, error in
                
                if let data = result as? Data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                    let rootDict = json as? [String : Any] {
                        success(String(data: data, encoding: .utf8)!)
                            
                        if let paging = rootDict["paging"] as? [String : String] {
                            self.nextFriendInfoPage = paging["next"]
                            self.prevFriendInfoPage = paging["previous"]
                        }
                            
                    return
                }
                
                failure()
            }
        }
    }
    
    func getNextFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        if nextFriendInfoPage == nil {
            failure()
        } else {
            Network.get(url: nextFriendInfoPage!, params: [:], success: { result in
                
                if let json = try? JSONSerialization.jsonObject(with: result.data(using: .utf8)!, options: .allowFragments),
                    let rootDict = json as? [String : Any] {
                        success(result)
                        
                        if let paging = rootDict["paging"] as? [String : String] {
                            self.nextFriendInfoPage = paging["next"]
                            self.prevFriendInfoPage = paging["previous"]
                        }
                        
                        return
                }
                failure()
                }, failure: { () in
                    failure()
            })
        }
    }
    
    func getPrevFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        if prevFriendInfoPage == nil {
            failure()
        } else {
            Network.get(url: prevFriendInfoPage!, params: [:], success: { result in
                if let json = try? JSONSerialization.jsonObject(with: result.data(using: .utf8)!, options: .allowFragments),
                    let rootDict = json as? [String : Any] {
                        success(result)
                        
                        if let paging = rootDict["paging"] as? [String : String] {
                            self.nextFriendInfoPage = paging["next"]
                            self.prevFriendInfoPage = paging["previous"]
                        }
                        
                        return
                    }
                
                failure()
                }, failure: { () in
                    failure()
            })
        }
    }


    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        if shareCaller != nil {
            shareCaller!(false)
            shareCaller = nil
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        if shareCaller != nil {
            shareCaller!(false)
            shareCaller = nil
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        if shareCaller != nil {
            shareCaller!(true)
            shareCaller = nil
        }
    }
    
    func gameRequestDialog(_ gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        Log("FB GameRequest success.")
        if gameRequestCaller != nil {
            gameRequestCaller!(true)
            gameRequestCaller = nil
        }
    }
    
    func gameRequestDialog(_ gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: Error!) {
        Log("FB GameRequest fail: \(error)")
        if gameRequestCaller != nil {
            gameRequestCaller!(false)
            gameRequestCaller = nil
        }
    }
    
    func gameRequestDialogDidCancel(_ gameRequestDialog: FBSDKGameRequestDialog!) {
        Log("FB GameRequest fail: cancel.")
        if gameRequestCaller != nil {
            gameRequestCaller!(false)
            gameRequestCaller = nil
        }
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        Log("FB Invate success.")
        if inviteCaller != nil {
            inviteCaller!(true)
            inviteCaller = nil
        }
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        Log("FB Invite fail")
        if inviteCaller != nil {
            inviteCaller!(false)
            inviteCaller = nil
        }
    }

    
    // 请求免审核权限
    func getReadPermissions(viewController controller: UIViewController, success: @escaping ()->Void, failure: @escaping ()->Void) {
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: controller) { result, error in
                                if error != nil {
                                    Log("FB read permission login fail: \(error).")
                                    failure()
                                } else {
                                    if let rs = result {
                                        if rs.isCancelled {
                                            Log("FB read permission login cancel.")
                                            failure()
                                        } else {
                                            Log("FB read permission login success.")
                                            success()
                                        }
                                    } else {
                                        Log("FB read permission login fail, result is nil")
                                        failure()
                                    }
                            }
                }
    }
    
    // 请求需要审核的权限
    func getPublishPermissions(viewController controller: UIViewController, success: @escaping ()->Void, failure: @escaping ()->Void) {
        if FBSDKAccessToken.current() != nil && FBSDKAccessToken.current()!.hasGranted("publish_actions") {
            success()
            return
        }
        
        loginManager.logIn(withPublishPermissions: ["publish_actions", "public_profile", "email", "user_friends"], from: controller) { result, error in
                            if error != nil {
                                Log("FB publish permission login fail: \(error).")
                                failure()
                            } else {
                                if let rs = result {
                                    if rs.isCancelled {
                                        Log("FB publish permission login cancel.")
                                        failure()
                                    } else {
                                        Log("FB publish permission login success.")
                                        success()
                                    }
                                } else {
                                    Log("FB publish permission login fail, result is nil")
                                    failure()
                                }
                            }
                        }
    }
    
}
