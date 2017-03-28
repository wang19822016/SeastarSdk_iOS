//
//  DropDownMenu.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/26.
//
//

import Foundation
import UIKit

protocol ComboBoxDelegate: class {
    func selectOption(didChoose index: Int)
    func deleteOption(didChoose index: Int)
}

@IBDesignable class ComboBox : UIView, UITableViewDataSource, UITableViewDelegate{
    
    // 元件水平间隔
    fileprivate static let HORIZONTAL_GAP: CGFloat = 3
    // 上下边间距
    fileprivate static let TOP_BOTTOM_MARIGN: CGFloat = 3
    // 左右边间距
    fileprivate static let LEFT_RIGHT_MARIGN: CGFloat = 3
    
    class CustomTableViewCell: UITableViewCell {
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setUp()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setUp()
        }
        
        func setUp() {
            preservesSuperviewLayoutMargins = false
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero;
        }
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            
            // 上下间隔3pt，离左侧5pt，宽高相等
            var posX = ComboBox.LEFT_RIGHT_MARIGN
            let posY = ComboBox.TOP_BOTTOM_MARIGN
            var width = self.frame.size.height - 2 * ComboBox.TOP_BOTTOM_MARIGN
            let height = self.frame.size.height - 2 * ComboBox.TOP_BOTTOM_MARIGN
            
            imageView?.frame = CGRect(x: posX, y: posY, width: width, height: height)
            
            // 上下间隔3pt, 间隔head 3pt
            posX = posX + width + ComboBox.HORIZONTAL_GAP
            width = self.frame.size.width - posX - ComboBox.HORIZONTAL_GAP - ComboBox.LEFT_RIGHT_MARIGN - (self.frame.size.height - 2 * ComboBox.TOP_BOTTOM_MARIGN)
            //width = self.frame.size.width - posX - ComboBox.HORIZONTAL_GAP - (self.frame.size.height - 2 * ComboBox.TOP_BOTTOM_MARIGN);
            textLabel?.frame = CGRect(x: posX, y: posY, width: width, height: height)
            
            // 上下间隔3pt，间隔左侧3pt，间隔右侧5pt，宽高相等
            posX = posX + width + ComboBox.HORIZONTAL_GAP
            width = self.frame.size.height - ComboBox.TOP_BOTTOM_MARIGN
            accessoryView?.frame = CGRect(x: posX, y: posY, width: width, height: height)
        }
    }
    
    //-----------------控件---------------
    // 底部背景
    fileprivate var background: UIImageView!
    // 左侧头像
    fileprivate var head: UIImageView!
    // 中间文本框
    fileprivate var content: UITextField!
    // 右侧按钮
    fileprivate var dropDown: UIButton!
    // 下拉列表
    fileprivate var tableView: UITableView!
    
    //------------控件属性------------------
    //输入框和下拉列表项中文本颜色
    @IBInspectable var textColor: UIColor? {
        didSet {
            content.textColor = textColor
        }
    }
    
    //输入框和下拉列表项中字体
    var font: UIFont? {
        didSet {
            content.font = font
        }
    }
    
    //允许用户编辑,默认允许
    @IBInspectable var editable: Bool = true {
        didSet {
            content.isEnabled = editable
        }
    }

    //下拉按钮图片
    @IBInspectable var dropDownImage: UIImage? {
        didSet {
            dropDown.setImage(dropDownImage, for: .normal)
            dropDown.setImage(dropDownImage, for: .highlighted)
        }
    }
    
    // 背景
    @IBInspectable var backgroundImage: UIImage? {
        didSet {
            //let iTop: CGFloat = 1
            //let iBottom: CGFloat = 1
            //let iLeft: CGFloat = 1
            //let iRight: CGFloat = 1
            //let insets = UIEdgeInsets(top: iTop, left: iLeft, bottom: iBottom, right: iRight)
            //let iImage = backgroundImage?.resizableImage(withCapInsets: insets, resizingMode: UIImageResizingMode.stretch)
            background.image = backgroundImage
        }
    }
    
    //tableCellView上button使用的图片
    @IBInspectable var optionImage: UIImage?
    
    // 文本框占位字符串
    var placeholder: String = "" {
        didSet {
            content.placeholder = placeholder
        }
    }
    
    //是否显示边框，默认显示
    var showBorder: Bool = true {
        didSet {
            if showBorder {
                layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 0.5
                layer.masksToBounds = true
                layer.cornerRadius = 2.5
            } else {
                layer.borderColor = UIColor.clear.cgColor
                layer.masksToBounds = false
                layer.cornerRadius = 0
                layer.borderWidth = 0
            }
        }
    }
    
    weak var delegate: ComboBoxDelegate?
    
    // 数据
    var options:[Any] = [] {
        didSet {
            if options.count > 0 {
                currentRow = 0
                head.image = UIImage(named:initBundleImage(ImageStr: (options[0] as! (String,String)).0));
                content.text = (options[0] as! (String,String)).1
                tableView.reloadData()
            }
        }
    }

    var optionsString:[UIImage] = [];
    // 其他属性
    // 当前在文本框内显示的是哪一行
    fileprivate var currentRow: Int = 0
    fileprivate var isShown: Bool = false
    fileprivate var originWidth: CGFloat = 0
    fileprivate var originHeight: CGFloat = 0
    
    var currentContentText: String {
        return content.text ?? ""
    }
    
    // init中不能使用frame，这个时候可能还没有数值
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func initBundleImage(ImageStr:String)->String{
        let bundle = Bundle(for: SeastarSdk.classForCoder());
        let fileStr = bundle.path(forResource: ImageStr, ofType: "png");
        return fileStr!;
    }
    
    func setUp() {
        // 背景
        background = UIImageView(frame: CGRect.zero)
        addSubview(background)
        
         //头像
        head = UIImageView(frame: CGRect.zero)
        addSubview(head)
        
        // 名称
        content = UITextField(frame: CGRect.zero)
//        content.delegate = self
        addSubview(content)
        
        // 下拉按钮
        dropDown = UIButton(type: .custom)
        dropDown.addTarget(self, action: #selector(showOrHide), for: .touchUpInside)
        addSubview(dropDown)
        
        // 选项tableview
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        //tableView.showsVerticalScrollIndicator = false
        //tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.5
        
        self.showBorder = true
        self.textColor = UIColor.darkGray
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    func showOrHide() {
        if isShown {
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.dropDown.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
                self.tableView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height - 0.5,
                                              width: self.frame.size.width, height: 0)
            }) { finished in
                if finished {
                    self.dropDown.transform = CGAffineTransform(rotationAngle: 0.0)
                    self.isShown = false
                }
            }
        } else {
            content.resignFirstResponder()
            tableView.reloadData()
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.dropDown.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                self.tableView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height - 0.5,
                                              width: self.frame.size.width, height: CGFloat(3) * self.frame.size.height)
            }) { finished in
                if finished {
                    self.isShown = true
                }
            }
        }
    }
    
    override func layoutSubviews() {
        // 此处可以设置大小，能获取frame
        super.layoutSubviews()
        
        // 在做动画是宽高可能是0，所以这么处理下
        if self.frame.size.width > 0 {
            originWidth = self.frame.size.width
        }
        if self.frame.size.height > 0 {
            originHeight = self.frame.size.height
        }
        let rowWidth = originWidth
        let rowHeight = originHeight
        
        background.frame = CGRect(x: 0.3, y: 0.3, width: rowWidth - 0.6, height: rowHeight - 0.6)
        
        // 上下间隔3pt，离左侧5pt，宽高相等
        var posX = ComboBox.LEFT_RIGHT_MARIGN
        let posY = ComboBox.TOP_BOTTOM_MARIGN
        var width = rowHeight - 2 * ComboBox.TOP_BOTTOM_MARIGN
        let height = rowHeight - 2 * ComboBox.TOP_BOTTOM_MARIGN
        //head.frame = CGRect(x: posX, y: posY, width: width, height: height)
        
        // 上下间隔3pt, 间隔head 3pt
        //posX = posX + width + ComboBox.HORIZONTAL_GAP
        //width = rowWidth - posX - ComboBox.HORIZONTAL_GAP - ComboBox.LEFT_RIGHT_MARIGN - (rowHeight - 2 * ComboBox.TOP_BOTTOM_MARIGN)
        width = rowWidth - posX - ComboBox.HORIZONTAL_GAP - (rowHeight - 2 * ComboBox.TOP_BOTTOM_MARIGN)
        content.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // 上下间隔3pt，间隔左侧3pt，间隔右侧5pt，宽高相等
        posX = posX + width + ComboBox.HORIZONTAL_GAP
        width = rowHeight - ComboBox.TOP_BOTTOM_MARIGN
        dropDown.frame = CGRect(x: posX, y: posY, width: width, height: height)
        
        if self.superview != nil && tableView.superview == nil {
            tableView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height - 0.5,
                                 width: self.frame.width, height: 0)
            self.superview?.addSubview(tableView)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomTableViewCell
        if cell == nil {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.textLabel?.text = (options[indexPath.row] as! (String,String)).1
            cell?.textLabel?.font = font
            cell?.textLabel?.textColor = textColor
            
            let button = UIButton(frame: CGRect(x: 0, y: 0,
                                                width: self.frame.size.height - ComboBox.TOP_BOTTOM_MARIGN,
                                                height: self.frame.size.height - ComboBox.TOP_BOTTOM_MARIGN))
            button.tag = indexPath.row;
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            button.setImage(optionImage, for: .normal)
            button.setImage(optionImage, for: .highlighted)
            cell?.accessoryView = button
            
//            cell?.imageView!.image = options[indexPath.row].0
        } else {
            cell?.textLabel?.text = (options[indexPath.row] as! (String,String)).1
            cell?.imageView!.image = UIImage(named:initBundleImage(ImageStr: (options[indexPath.row] as! (String,String)).0));
        }
        
        return cell!
    }
    
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.frame.size.height
//    }
    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        content.text = (options[indexPath.row] as! (String,String)).1
//        head.image = UIImage(named:initBundleImage(ImageStr: (options[indexPath.row] as! (String,String)).0));
//        currentRow = indexPath.row
//        
//        self.delegate?.selectOption(didChoose: indexPath.row)
//        showOrHide()
//    }
    
    public func buttonPressed(_ sender: UIButton) {
//        if let cell = sender.superview as? CustomTableViewCell {
//            if let indexPath = tableView.indexPath(for: cell) {
//                if currentRow == indexPath.row {
//                    // 如果当前显示的行被删除，需要选择一行重新显示，如果没有数据了，直接清除所有
//                    if currentRow == options.count - 1 {
//                        // 删除的最后一行，则选择上一行
//                        if currentRow != 0 {
//                            // 如果还有数据
//                            currentRow = currentRow - 1
//                            
//                            head.image = UIImage(named:initBundleImage(ImageStr: (options[indexPath.row] as! (String,String)).0))
//                            content.text = (options[currentRow] as! (String,String)).1
//                        } else {
//                            // 已经没有数据了
//                            head.image = nil
//                            content.text = nil
//                        }
//                    } else {
//                        // 不是删除的最后一行，则使用下一个来显示，currentRow不必移动
//                        
//                        head.image = UIImage(named:initBundleImage(ImageStr: (options[indexPath.row] as! (String,String)).0))
//                        content.text = (options[currentRow + 1] as! (String,String)).1
//                    }
//                }
//                options.remove(at: indexPath.row)
//                
//                self.delegate?.deleteOption(didChoose: indexPath.row)
//            }
//        }
        options.remove(at: sender.tag);
        tableView.reloadData();
    }
}
