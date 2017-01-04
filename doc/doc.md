# 1. target中的Linked Frameworks and Libraries:
添加如下framework：
* Bolts.framework
* FBSDLCoreKit.framework
* FBSDKShareKit.framework
* FBSDKLoginKit.framework

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
    "RegsiterFalse" = "Regsiter False";
    "FindSuccess" = "Retrieve Success";
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

    "Guest" = "Guest";
    "Seastar" = "海星";
    "Facebook" = "Facebook";
    "Login" = "登入";
    "Forget" = "忘記密碼";
    "Register" = "註冊賬號";
    "LoginFalse" = "登入失敗";
    "PleaseEnterTheCorrectAdmin" = "请输入6-10用户名字母开头";
    "PleaseEnterTheCorrectPassword" = "请输入8-16密码";
    "PleaseEnterTheCorrectEmail" = "请输入正确的邮箱格式";
    "AccountOrPasswordError" = "帐号或密码错误";
    "AccountDoesNotExist" = "帐号不存在";
    "YouHaveBeenBanned" = "您已经被封号";
    "AccountAlreadyExists" = "帐号已经被注册";
    "LoginSuccess" = "登入成功";
    "RegsiterFalse" = "註冊失敗";
    "FindSuccess" = "找回成功";
    "FindPassword" = "密碼找回";
    "NoticeLabel" = "密碼將被發送到該賬戶綁定的信箱,如有疑問請聯繫客服信箱:vrseastar@vrseastar.com";
    "SelectLoginType" = "請選擇登入方式";
    "PleaseInputAccount" = "請輸入賬號";
    "PleaseInputPassword" = "請輸入密碼";
    "PleaseInputSeastarAccount" = "請輸入海星賬號";
    "PleaseInputEmail(Option)" = "請輸入信箱(可選)";
    "ChangeAccount" = "切換賬號";
    
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
