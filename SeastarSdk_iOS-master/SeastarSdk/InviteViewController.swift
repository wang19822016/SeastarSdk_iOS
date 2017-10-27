//
//  InviteViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/4/7.
//
//

import UIKit

class InviteViewController: BaseViewController {
    
    static let current = InviteViewController();
    let backColor = UIColor(red: 233.0/255.0, green: 235.0/255.0, blue: 238.0/255.0, alpha: 1.0);
    let cellColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0);
    let blueColor = UIColor(red: 66.0/255.0, green: 103.0/255.0, blue: 178.0/255.0, alpha: 1.0);
    var nameArray = [String]();
    var urlArray = [String]();
    var idArray = [String]();
    var selectedArray = [Bool]();
    var inviteArray = [String]();
    
    //var myCell:CustomCollectionViewCell?;
    var imageArray = [UIImage?]();
    //MARK:barView
    
    @IBOutlet var barView: UIView!
    @IBAction func backBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    //MARK:leftView
    
    @IBOutlet var inviteFriendBtn: UIButton!
    @IBOutlet var blindFriendBtn: UIButton!
    @IBOutlet var leftView: UIView!
    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    
    @IBAction func inviteFriendClick(_ sender: Any) {
        inviteFriendBtn.isSelected = true;
        blindFriendBtn.isSelected = false;
        secondView.frame = CGRect(x: firstView.frame.origin.x, y: firstView.frame.size.height + firstView.frame.origin.y, width: firstView.frame.size.width, height: firstView.frame.size.height);
    }
    
    @IBAction func blindFriendClick(_ sender: Any) {
        blindFriendBtn.isSelected = true;
        inviteFriendBtn.isSelected = false;
        secondView.frame = firstView.frame;
    }
    @IBAction func GameWebClick(_ sender: Any) {
        let url = URL(string: Global.current.mainPageUrl);
        if UIApplication.shared.canOpenURL(url!){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!);
            };
        }else{
            print("URL不可用");
        }
    }
    
    @IBAction func shareNow(_ sender: Any) {
        Facebook.current.share(viewController: self, contentURL: Global.current.contentURL, contentTitle: Global.current.contentTitle, imageURL: Global.current.imageURL, contentDescription: Global.current.contentDescription) { (shareBool) in
            print(shareBool);
            Global.current.shareSuccess!(shareBool);
        }
    }
    
    
    //MARK:firstView
    
    @IBOutlet var firstView: UIView!
    
    @IBOutlet var selectedAllButton: UIButton!
    
    @IBAction func selectAllClick(_ sender: Any) {
        selectedAllButton.isSelected = !selectedAllButton.isSelected;
        if selectedAllButton.isSelected{
            inviteArray = idArray;
            for i in 0..<selectedArray.count{
                selectedArray[i] = true;
            }
        }else{
            inviteArray.removeAll();
            for i in 0..<selectedArray.count{
                selectedArray[i] = false;
            }
        }
        myCollectionView.reloadData();
    }
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    @IBAction func sendInvite(_ sender: Any) {
        Facebook.current.doGameRequestWithArray(requestMessage: "邀請好友", requestTitle: "邀請", friendArray: inviteArray) { (bool) in
        }
    }
    
    
    //MARK:secondView
    
    @IBOutlet var secondView: UIView!
    
    @IBOutlet var urlInfoLabel: UILabel!
    
    @IBAction func copyButtonClick(_ sender: Any) {
        UIPasteboard.general.string = urlInfoLabel.text;
    }
    
    var facebookLogin:Bool = false;
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if facebookLogin == false{
            facebookLogin = true;
            Facebook.current.login(viewController: self, success: { (_, _) in
                self.initUserInfo();
                self.initFriendInfo();
            }) {
                self.dismiss(animated: true, completion: nil);
            }
        }
    }
    
    override func initView() {
        //        secondView.frame = CGRect(x: firstView.frame.origin.x, y: firstView.frame.size.height + firstView.frame.origin.y, width: firstView.frame.size.width, height: firstView.frame.size.height);
        secondView.frame = CGRect(x: firstView.frame.origin.x, y: 800, width: firstView.frame.size.width, height: firstView.frame.size.height);
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        
        urlInfoLabel.text = Global.current.bindUrl;
        leftView.backgroundColor = backColor;
        firstView.backgroundColor = backColor;
        secondView.backgroundColor = backColor;
        myCollectionView.backgroundColor = backColor;
        myCollectionView.register(CustomCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "myCell");
        barView.backgroundColor = blueColor;
        inviteFriendBtn.isSelected = true;
    }
    
    func initUserInfo(){
        Facebook.current.getMeInfo(success: { (data) in
            let dic:Dictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any];
            let pictureDic = dic["picture"] as! [String:Any];
            let dataDic = pictureDic["data"] as! [String:Any];
            let url = dataDic["url"] as! String?;
            let imageData = try? Data(contentsOf: URL(string: url!)!);
            self.UserImage.image = UIImage(data: imageData!);
            self.userName.text = dic["name"] as! String?;
        }) {
            
        }
    }
    
    func initFriendInfo(){
        startCustomView();
        Facebook.current.getInvitableFriendInfo(height: 50, width: 50, limit: 50, success: { (data) in
            let dic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)as! [String:Any];
            print("\(dic)");
            let friendArray = dic["data"] as! [Any];
            for friendInfo in friendArray{
                let friendDic = friendInfo as! [String:Any];
                let name = friendDic["name"] as! String;
                self.nameArray.append(name);
                
                let id = friendDic["id"] as! String;
                self.idArray.append(id);
                
                let picture = friendDic["picture"] as! [String:Any];
                let data = picture["data"] as! [String:Any];
                let url = data["url"] as! String;
                
                self.urlArray.append(url);
                self.imageArray.append(nil);
                self.selectedArray.append(false);
            }
            for i in 0..<self.urlArray.count{
                MyNetwork.current.downImage(urlStr: self.urlArray[i], success: { (image) in
                    self.imageArray[i] = image;
                    for image in self.imageArray{
                        if image == nil{
                            return
                        }
                    }
                    self.myCollectionView.reloadData();
                })
            }
            self.stopCustomView();
            self.myCollectionView.reloadData();
        }) {
        }
    }
}

extension InviteViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nameArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var myCell = CustomCollectionViewCell();
        myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CustomCollectionViewCell;
        myCell.imageView.image = self.imageArray[indexPath.row]
        myCell.label.text = self.nameArray[indexPath.row];
        myCell.button.setBackgroundImage(self.returnNormalImage(), for: .normal);
        myCell.button.setBackgroundImage(self.returnSelectedImage(), for: .selected);
        myCell.button.tag = indexPath.row;
        if selectedArray[indexPath.row]{
            myCell.button.isSelected = true;
        }else{
            myCell.button.isSelected = false;
        }
        myCell.button.addTarget(self, action: #selector(self.btnClick(sender:)), for: UIControlEvents.touchUpInside);
        myCell.backgroundColor = self.cellColor;
        return myCell;
    }
    
    
    func initBundleImage(ImageStr:String)->String{
        let bundle = Bundle(for: SeastarSdk.classForCoder());
        let fileStr = bundle.path(forResource: ImageStr, ofType: "png");
        return fileStr!;
    }
    
    func returnNormalImage()->UIImage{
        return UIImage(named:initBundleImage(ImageStr: "invite_Facebook Messenger-black"))!;
    }
    
    func returnSelectedImage()->UIImage{
        return UIImage(named:initBundleImage(ImageStr: "invite_"))!;
    }
    
    @objc func btnClick(sender:UIButton){
        if sender.isSelected{
            selectedArray[sender.tag] = false;
            for i in 0 ..< inviteArray.count{
                if inviteArray[i] == idArray[sender.tag]{
                    inviteArray.remove(at: i);
                    break;
                }
            }
        }else{
            selectedArray[sender.tag] = true;
            inviteArray.append(idArray[sender.tag]);
        }
        sender.isSelected = !sender.isSelected;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 150, height: 40);
        return size;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
}
