//
//  ChangeAccountViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/11/4.
//
//

import UIKit

class ChangeAccountViewController: BaseViewController{
    
    @IBOutlet var CenterView: UIView!
    @IBOutlet var UserImage: UIImageView!
    
    @IBOutlet var backGroundImage: UIImageView!
    @IBOutlet var currentUser: UILabel!
    
    @IBOutlet var downButton: UIButton!
    
    var tableView = UITableView();
    
    var appear = Bool();
    
    
    @IBOutlet var myView: UIView!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var changeBtn: UIButton!
    
    private var options: [UserModel] = []
    
    var optionsArray: [Any] = []
    var currentUserModel = UserModel();
    
    var accountIndex:Int = 0;
    
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        self.loginSuccess(user: currentUserModel);
        currentUserModel.saveAsCurrentUser();
        BossClient.current.login(userId: String(currentUserModel.userId));
    }
    
    override func initView() {
        makeBounds(backGroundImage.layer);
        loginBtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        loginBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        let title = NSMutableAttributedString(string: NSLocalizedString("ChangeAccount", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSAttributedStringKey.underlineStyle, value: num, range: titleRange);
        changeBtn.setAttributedTitle(title, for: UIControlState.normal);
        changeBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        initMyView();
        initTableView();
    }
    
    
    func initMyView(){
        appear = false;
        options = UserModel.loadAllUsers()
        for user in options {
            if user.loginType == 1 {
                let tuples = ("guest",user.userName,user);
                optionsArray.append(tuples);
            } else if user.loginType == 4 {
                let tuples = ("facebook",user.userName,user);
                optionsArray.append(tuples);
            } else if user.loginType == 0{
                let tuples = ("seastar",user.userName,user);
                optionsArray.append(tuples);
            }
        }
        
        if options.count > 0{
        currentUserModel = UserModel.loadAllUsers()[0];
        UserImage.image = returnImage(myIndex: 0)
        currentUser.text = returnUser(myIndex: 0);
        }
    }
    
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: myView.frame.origin.x, y: myView.frame.origin.y + myView.frame.size.height, width: myView.frame.size.width, height: 2.5 * myView.frame.size.height));
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(CustomTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell");
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.bounces = false;
    }
    @IBAction func downButtonClick(_ sender: Any) {
        if optionsArray.count == 0{
            return;
        }else{
            if(!appear){
                clickUp();
            }else{
                upBack();
            }
        }
    }
    
    @objc func deleteUser(_ sender: UIButton) {
        let userModel = (optionsArray[sender.tag] as! (String,String,UserModel)).2
        userModel.remove();
        var currentModel = UserModel();
        if currentModel.loadCurrentUser(){
            if currentModel.userId == userModel.userId{
                currentModel.removeCurrentUser()
            }
        }
        optionsArray.remove(at: sender.tag);
        tableView.reloadData();
        if(optionsArray.count == 0){
            self.appear = false;
            self.downButton.transform = CGAffineTransform(rotationAngle: 0.0)
            self.tableView.removeFromSuperview();
            
            let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
            let vc: MainLoginViewController = storyboard.instantiateInitialViewController()! as! MainLoginViewController
            vc.showBackButton = true;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    func clickUp(){
        UIView.animate(withDuration: 0.3) { 
            self.appear = true;
            self.downButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.CenterView.addSubview(self.tableView);
        }
    }
    
    func upBack(){
        UIView.animate(withDuration: 0.3, animations: {
            self.appear = false;
            self.downButton.transform = CGAffineTransform(rotationAngle: 0.0)
            self.tableView.removeFromSuperview();
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        upBack();
    }
    
    
    func returnImage(myIndex:Int)->UIImage{
        let image = UIImage(named:initBundleImage(ImageStr: (optionsArray[myIndex] as! (String,String,UserModel)).0));
        return image!;
    }
    
    func returnUser(myIndex:Int)->String{
        return (optionsArray[myIndex] as! (String,String,UserModel)).1
    }
    
    func initBundleImage(ImageStr:String)->String{
        let bundle = Bundle(for: SeastarSdk.classForCoder());
        let fileStr = bundle.path(forResource: ImageStr, ofType: "png");
        return fileStr!;
    }
    func returnCancel()->UIImage{
        return UIImage(named:initBundleImage(ImageStr: "cancel"))!;
    }
}

extension ChangeAccountViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CustomTableViewCell();
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell;
        cell.textLabel?.text = returnUser(myIndex: indexPath.row);
        cell.imageView?.image = returnImage(myIndex: indexPath.row);
        let button = UIButton(type: .system);
        button.frame = CGRect(x: 224, y: 7, width: 30, height: 30);
        button.setBackgroundImage(returnCancel(), for: .normal);
        button.tag = indexPath.row;
        button.addTarget(self, action: #selector(deleteUser(_:)), for: .touchUpInside);
        cell.accessoryView = button;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserImage.image = returnImage(myIndex: indexPath.row);
        currentUser.text = returnUser(myIndex: indexPath.row);
        currentUserModel = (optionsArray[indexPath.row] as! (String,String,UserModel)).2
        upBack();
    }
}
