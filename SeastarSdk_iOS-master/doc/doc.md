# 1. target中的Linked Frameworks and Libraries:
添加如下framework：
* Bolts.framework
* FBSDKCoreKit.framework
* FBSDKShareKit.framework
* FBSDKLoginKit.framework
* AppsFlyerLib.framework

# 2. target中的Embedded Binaries:
添加如下framework:
* SeastarSdk.framework

# 3. target中的Build Settings:
设置 Always Embed Swift Standard Libraries 为 Yes.

# 4. target中的Info:
* Custom iOS Target Properties:
    * 添加Key: App Transport Security Settings, Type: Dictionary<br/>添加子项：
        * Key: Allow Arbitrary Loads, Type: Boolean, Value: YES
        * Key: Allow Arbitrary Loads in Web Content, Type: Boolean, Value: YES
    * 添加Key: LSApplicationQueriesSchemes, Type: Array<br/>添加子项：
        * Type: String, Value: fbapi
        * Type: String, Value: fbapi20130214
        * Type: String, Value: fbapi20130410
        * Type: String, Value: fbapi20130702
        * Type: String, Value: fbapi20131010
        * Type: String, Value: fbapi20131219
        * Type: String, Value: fbapi20140410
        * Type: String, Value: fbapi20140116
        * Type: String, Value: fbapi20150313
        * Type: String, Value: fbapi20150629
        * Type: String, Value: fbauth
        * Type: String, Value: fbauth2
        * Type: String, Value: fb-messenger-api20140430
    * 添加Key: FacebookDisplayname, Type: String, Value: fb后台配置的App名称
    * 添加Key: FacebookAppID, Type: String, Value: fb后台的appId
    * 添加Key: AppConfig, Type: Dictionary<br/>添加子项:
        * Key: AppId, Type: Number, Value: 分配的应用ID
        * Key: AppKey, Type: String, Value: 分配的客户端密钥
        * Key: ServerUrl, Type: String, Value: https://52.77.192.179
    * 添加Key: AppsFlyerID, Type: String, Value: appsflyer的id
    * 添加Key: AppsFlyerKey, Type: String, Value: appsflyer的key
    * 添加Key: GocpaAppId, Type: String, Value: Gocpa的AppId
    * 添加Key: GocpaAdvertiserId, Type: String, Value: Gocpa的AdvertiserId
* URL Types:<br/>
    添加一项，identifier: None, Icon: None, Role: Editor, URL Schemes: fb + fb分配的appid

# 5. 国际化:
* 新建Strings File类型文件, 命名为Localizable.
* 选中Project navigator下的Localizable.strings, 然后选中File Inspector, 点击Localization下的Localize按钮，勾选Base.
* 选中project下的info标签, 点击Localizations下的＋按钮，选择Chinese (Traditional), 在弹出的窗口中只选中Localizable.strings文件。
* 展开Project navigator下的Localizable.strings.
* 选中Localizable.strings (Base), 粘贴如下内容:<br/>
    ```Objective-C

    "Guest" = "Guest";
    "Seastar" = "Seastar Account ";
    "Facebook" = "Facebook";
    "Login" = "Sign in";
    "Forget" = "Forgot Password";
    "Register" = "Register";
    "LoginFalse" = "Sign in False";
    "PleaseEnterTheCorrectAdmin" = "Please enter the username with 6 to 10 letters and numbers.The beginning must be letter.";
    "PleaseEnterTheCorrectPassword" = "Please enter the password with 8 to 16 letters and numbers";
    "PleaseEnterTheCorrectEmail" = "Please enter the correct email address";
    "AccountOrPasswordError" = "Account Or Password Error";
    "AccountDoesNotExist" = "Account Does Not Exist";
    "YouHaveBeenBanned" = "You Have Been Banned";
    "AccountAlreadyExists" = "Account Already Exist";
    "LoginSuccess" = "Sign in Success";
    "RegisterFalse" = "Regsiter False";
    "FindSuccess" = "Retrieve Success";
    "Findfalse" = "Findfalse";
    "FindPassword" = "Retrieve Password";
    "NoticeLabel" = "Password will send to mailbox. If you have any questions, please send email to vrseastar@vrseastar.com";
    "SelectLoginType" = "Sign in With";
    "PleaseInputAccount" = "   Enter username(6 to 10)";
    "PleaseInputPassword" = "   Enter password(8 to 16)";
    "PleaseInputSeastarAccount" = "   Enter username(6 to 10)";
    "PleaseInputEmail(Option)" = "   Enter email address";
    "ChangeAccount" = "Use Other Account";

    ```
*  选中Localizable.strings (Chinese (Traditional)), 粘贴如下内容:<br/>
    ```Objective-C

    "Guest" = "遊客";
    "Seastar" = "海星帳號";
    "Facebook" = "Facebook";
    "Login" = "登入";
    "Forget" = "忘記密碼";
    "Register" = "註冊帳號";
    "LoginFalse" = "登入失敗";
    "PleaseEnterTheCorrectAdmin" = "請輸入字母開頭，由數字和字母組成的6至16位帳號";
    "PleaseEnterTheCorrectPassword" = "請輸入數字和字母組成的8至16位密碼";
    "PleaseEnterTheCorrectEmail" = "请输入正确的邮箱格式";
    "AccountOrPasswordError" = "賬號或密码错误";
    "AccountDoesNotExist" = "該賬號不存在";
    "YouHaveBeenBanned" = "該賬號已被禁用";
    "AccountAlreadyExists" = "該賬號已被佔用";
    "LoginSuccess" = "歡迎回來!";
    "RegisterFalse" = "帳號已被佔用，請重新輸入";
    "FindSuccess" = "找回成功，請到綁定信箱查看密碼";
    "Findfalse" = "該帳號未綁定信箱";
    "FindPassword" = "密碼找回";
    "NoticeLabel" = "若遺忘帳號密碼，請聯絡客服信箱：cs.jjsg.cs@gmail.com";
    "SelectLoginType" = "請選擇登入方式";
    "PleaseInputAccount" = "請輸入帳號";
    "PleaseInputPassword" = "請輸入密碼";
    "PleaseInputSeastarAccount" = "請輸入海星帳號";
    "PleaseInputEmail(Option)" = "請輸入信箱(可選)";
    "ChangeAccount" = "切換帳號";

    ```

# 6. 添加运行时方法：


```Objective-C

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //sdk的初始化  landscape  横屏传true  竖屏传false
    [[SeastarSdk current]initializeWithViewController:_window.rootViewController landscape:true];
    //facebook的初始化
    [[SeastarSdk current]application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //跳转第三方登录时调用的方法
    [[SeastarSdk current]application:application open:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[SeastarSdk current]applicationDidBecomeActive:application];
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
[[SeastarSdk current]application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
-(void)applicationDidEnterBackground:(UIApplication *)application{
[[SeastarSdk current]applicationDidEnterBackground:application];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
[[SeastarSdk current]applicationWillEnterForeground:application];
}
```

# 7. 登录:
```Objective-C

//登陆方法 成功返回  userID  和 Session 失败没有返回值
[[SeastarSdk current]loginWithLoginSuccess:^(NSInteger userID, NSString * _Nonnull session) {
        // 登录成功, 返回帐号ID和session，可以用session去服务器端验证帐号有效性
    } loginFailure:^{

    }];

```

# 8. 登出:
```Objective-C

[[SeastarSdk current]logout];

```

# 9. 支付:
```Objective-C

[[SeastarSdk current]purchaseWithProductId:@"商品ID" roleId:@"游戏内角色ID" serverId:@"充值服务器ID" extra:@"附加数据" paySuccess:^(NSString * _Nonnull order, NSString * _Nonnull productIdentifier) {
        // 成功后将本次支付的流水号和商品ID返回
    } payFailure:^(NSString * _Nonnull productIdentifier) {
        NSLog(@"%@",productIdentifier);
    }];

```

# 10. 检查掉单：
```Objective-C

// 需要在登录后调用本方法来重新提交掉单。
[[SeastarSdk current]checkLeakPurchase];

```

# 11. 切换帐号:
```Objective-C

[[SeastarSdk current]changeAccountWithLoginSuccess:^(NSInteger userID, NSString * _Nonnull Session) {
        // 切换成功，返回帐号ID和session，可以用session去服务器端验证帐号有效性
    } loginFailure:^{

    }];

```

# 12. appsflyer统计接口
```Objective-C

// 升级接口
[[SeastarSdk current]trackLevelAchievedWithLevel:@"当前等级" score:@"当前经验，可以默认为0"];

// 支付接口
[[SeastarSdk current]trackPurchaseWithSku:@"商品ID" skuType:@"商品类型，如月卡、普通商品等，可以自定义" price:商品价格 currency:@"充值货币，可以默认为USD，price按照USD算"];

// 角色注册接口
[[SeastarSdk current]trackRegistration];

// 角色登录接口
[[SeastarSdk current]trackLogin];

```

# 13. facebook 分享接口
```Objective-C

// 分享图片
// imageUri: 图片URI，需要在网站上生成一个url，分享时uri就是这个url
// caption 分享标题
[[SeastarSdk current]shareFbWithViewController:self imageURL:@"图片地址" imageCaption:@"标题" caller:^(BOOL caller) {}];

// 分享链接
// contentURL: 分享的链接，如果是商店内app应用地址，用户不能添加分享文字，分享内容中生成一个商店截图,
//      如果是自己制作的网页，需要按照fb要求添加fb的tag，此时用户可以添加自己的分享文字。
// contentTitle: 分享标题
// imageURL: 分享内容中显示的图片的地址，可以不添加，在contentURL为商店应用页面链接时不起作用
// contentDescription: 默认的分享文字
[[SeastarSdk current]shareFbWithViewController:self contentURL:@"链接" contentTitle:@"标题" imageURL:@"分享图片地址" contentDescription:@"分享文字" caller:^(BOOL caller) {}];

// 游戏邀请
// title: 邀请标题
// message: 邀请信息内容
// 会弹出窗口，选中邀请的好友
[[SeastarSdk current]doFbGameRequestWithRequestMessage:@"邀请内容" requestTitle:@"标题" caller:^(BOOL caller) {}];

// 删除邀请信息
// 每次启动时调用，可以删除邀请信息
[[SeastarSdk current]deleteFbGameRequest];

```

# 14. facebook信息接口
```Objective-C

// 以下接口返回一个json串，从其中可以解析出数据

// 获取好友信息
// height: 头像高度
// width: 头像宽度
// limit: 每次获得的好友条数
[[SeastarSdk current]getFbFriendInfoWithHeight:20 width:20 limit:20 success:^(NSString * _Nonnull str) {} failure:^{}];

// 获取下一批好友信息
[[SeastarSdk current]getNextFbFriendInfoWithSuccess:^(NSString * _Nonnull str) {} failure:^{}];

// 获取上一批好友信息
[[SeastarSdk current]getPrevFbFriendInfoWithSuccess:^(NSString * _Nonnull str) {} failure:^{}];

// 获得个人信息
[[SeastarSdk current]getFbMeInfoWithSuccess:^(NSString * _Nonnull str) {NSLog(@"%@", str);} failure:^{}];

```
# 14. facebook广告变现接口
```
[[SeastarSdk current]loadRewardedVideoAdWithLoadRewardedVideoSuccess:^(BOOL success) {
}];
```
