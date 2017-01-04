# 1. Linked Frameworks and Libraries:
添加如下framework：
* Bolts.framework
* FBSDLCoreKit.framework
* FBSDKShareKit.framework
* FBSDKLoginKit.framework

# 2. Embedded Binaries:
添加如下framework:
* SeastarSdk.framework

# 3. Build Settings:
设置 Always Embed Swift Standard Libraries 为 Yes.

# 4. info:
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

# 5. 添加运行时方法：
<code>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {<br/>
    //sdk的初始化  landscape  横屏传true  竖屏传false<br/>
    [[SeastarSdk current]initializeWithViewController:_window.rootViewController landscape:true];<br/>
    //facebook的初始化<br/>
    [[SeastarSdk current]application:application didFinishLaunchingWithOptions:launchOptions];<br/>
    return YES;<br/>
}<br/>
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{<br/>
    //跳转第三方登录时调用的方法<br/>
    [[SeastarSdk current]application:application open:url sourceApplication:sourceApplication annotation:annotation];<br/>
    return YES;<br/>
}<br/>
- (void)applicationDidBecomeActive:(UIApplication *)application {<br/>
    [[SeastarSdk current]applicationDidBecomeActive:application];<br/>
}<br/>
</code>
