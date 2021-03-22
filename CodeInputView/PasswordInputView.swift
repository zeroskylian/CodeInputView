//
//  PasswordInputView.swift
//  Animation
//
//  Created by 廉鑫博 on 2019/6/20.
//  Copyright © 2019 廉鑫博. All rights reserved.
//
import UIKit

class PasswordInputView: UIView {
    
    private let inputv:UITextField = UITextField()
    
    private var chars:[String]
    
    private let maxCount:Int
    
    private var collectionView:UICollectionView
    
    override var backgroundColor: UIColor? {
        willSet{
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    required init(origin:CGPoint,itemSize: CGSize,itemCount:Int, insets:UIEdgeInsets = UIEdgeInsets.zero, spacing:CGFloat) {
        maxCount = itemCount
        chars = Array(repeating: "", count: itemCount)
        let frame = CGRect(x: origin.x, y: origin.y, width: itemSize.width * CGFloat(itemCount) + insets.left + insets.right + spacing * CGFloat(itemCount - 1), height: itemSize.height + insets.top + insets.bottom)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.sectionInset = insets
        layout.minimumInteritemSpacing = spacing
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: layout)
        collectionView.register(PasswordInputItem.self, forCellWithReuseIdentifier: "PasswordInputItem")
        collectionView.backgroundColor = UIColor.white
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        inputv.keyboardType = .decimalPad
        inputv.addTarget(self, action: #selector(textfieldTextDidChange(textfield:)), for: .editingChanged)
        addSubview(inputv)
        
        backgroundColor = UIColor.lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapAction() {
        inputv.becomeFirstResponder()
    }
    
    @objc private func textfieldTextDidChange(textfield:UITextField){
        if var string = textfield.text {
            if string.count > maxCount {
                string = String(string.prefix(maxCount))
                textfield.text = string
            }
            var stringArray = string.map {String($0)}
            if stringArray.count < maxCount
            {
                stringArray = stringArray + Array(repeating: "", count: maxCount - stringArray.count )
            }
            let res = zip(stringArray, chars).map {$0.0 == $0.1}
            if let index = res.firstIndex(of: false){
                chars = stringArray
                UIView.setAnimationsEnabled(false)
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                }) { (res) in
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PasswordInputView :UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let baseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PasswordInputItem", for: indexPath)
        guard let cell = baseCell as? PasswordInputItem else {
            fatalError("Failed to dequeue a cell with identifier")
        }
        cell.text = chars[indexPath.row]
        return cell
    }
}

class PasswordInputItem: UICollectionViewCell {
    
    let textLabel:UILabel = UILabel()
    
    let lineLayer:CALayer = CALayer()
    
    var text:String = "" {
        willSet{
            if newValue.count == 0{
                clearText()
            }else
            {
                textLabel.text = newValue
                lineLayer.isHidden = false
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBase() {
        contentView.addSubview(textLabel)
        contentView.layer.addSublayer(lineLayer)
        
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 2)
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 60)
        textLabel.textColor = UIColor.green
        
        lineLayer.frame = CGRect(x: 0, y: frame.height - 2, width: 60, height: 2)
        lineLayer.backgroundColor = UIColor.green.cgColor
        lineLayer.isHidden = true
    }
    
    func clearText() {
        textLabel.text = ""
        lineLayer.isHidden = true
    }
}
