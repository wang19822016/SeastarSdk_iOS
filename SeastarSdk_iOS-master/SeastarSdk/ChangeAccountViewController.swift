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
    
    @IBOutlet var currentUser: UILabel!
    
    @IBOutlet var downButton: UIButton!
    
    var tableView = UITableView();
    
    var appear = Bool();
    
    
    @IBOutlet var myView: UIView!
    
    @IBOutlet var comboBox: ComboBox!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var changeBtn: UIButton!
    
    private var options: [UserModel] = []
    
    var currentUserModel = UserModel();
    
    var ChangeAccountloginSuccess:((_ usermodel:UserModel)->Void)?
    
    var ChangeAccountloginFailure:(()->Void)?
    
    var accountIndex:Int = 0;
    
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        ChangeAccountloginSuccess!(currentUserModel);
        currentUserModel.saveAsCurrentUser();
        dismiss(animated: true, completion: nil);
    }
    
    override func initView() {
        loginBtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        loginBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        let title = NSMutableAttributedString(string: NSLocalizedString("ChangeAccount", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSUnderlineStyleAttributeName, value: num, range: titleRange);
        changeBtn.setAttributedTitle(title, for: UIControlState.normal);
        changeBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        initMyView();
        initTableView();
    }
    
    var optionsArray: [Any] = []
    
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
        currentUserModel = UserModel.loadAllUsers()[0];
        UserImage.image = returnImage(myIndex: 0)
        currentUser.text = returnUser(myIndex: 0);
    }
    
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: myView.frame.origin.x, y: myView.frame.origin.y + myView.frame.size.height, width: myView.frame.size.width, height: 2.5 * myView.frame.size.height));
        tableView.delegate = self;
        tableView.dataSource = self;
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
    
    func deleteUser(_ sender: UIButton) {
        optionsArray.remove(at: sender.tag);
        tableView.reloadData();
        if(optionsArray.count == 0){
            currentUser.text = "";
            upBack();
            
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
        let str = "cell";
        var cell = tableView.dequeueReusableCell(withIdentifier: str);
        if(!(cell != nil)){
            cell = UITableViewCell(style: .default, reuseIdentifier: str);
        }
        cell?.textLabel?.text = returnUser(myIndex: indexPath.row);
        cell?.imageView?.image = returnImage(myIndex: indexPath.row);
        let button = UIButton(type: .system);
        button.frame = CGRect(x: 224, y: 7, width: 30, height: 30);
        button.setBackgroundImage(returnCancel(), for: .normal);
        button.tag = indexPath.row;
        button.addTarget(self, action: #selector(deleteUser(_:)), for: .touchUpInside);
//        cell?.accessoryView = button;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserImage.image = returnImage(myIndex: indexPath.row);
        currentUser.text = returnUser(myIndex: indexPath.row);
        currentUserModel = (optionsArray[indexPath.row] as! (String,String,UserModel)).2
        upBack();
    }
}
