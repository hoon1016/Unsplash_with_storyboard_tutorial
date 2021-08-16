//
//  ViewController.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by 임재훈 on 2021/08/16.
//

import UIKit
import Toast_Swift

class HomeVC: UIViewController,UISearchBarDelegate,UIGestureRecognizerDelegate {

    
    @IBOutlet weak var searchfiletersegment: UISegmentedControl!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    @IBOutlet weak var searchbutten: UIButton!
    
    @IBOutlet weak var searchindicator: UIActivityIndicatorView!
    
    var keyboardDismissalTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    //MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("HomeVC - viewDidLoad() called")
        //ui 설정
        self.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchbar.becomeFirstResponder() // 포커싱 주기
        print("HomeVC - viewDidAppear() called")
    }
    
    // 화면이 넘어가기 전에 준비한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier : \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 뷰 컨트롤러를 가져온다.
            let nextVC = segue.destination as! UserListVC
            
            guard let userInputValue = self.searchbar.text else {return}
            
            nextVC.vcTitle = userInputValue + "🤯"
        
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            
            guard let photoInputValue = self.searchbar.text else {return}
            nextVC.vcTitle = photoInputValue + "🖼"
        
        default:
            print("default")
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        //키보드 올라가는 이벤트를 받는 처리
        //키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillDisappear() called")
        //키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    // MARK: - fileprivate methods
    fileprivate func config(){
        // ui 설정
        self.searchbutten.layer.cornerRadius = 10
        
        self.searchbar.searchBarStyle = .minimal
        
        self.searchbar.delegate = self
        
        self.keyboardDismissalTabGesture.delegate = self
        
        // 제스처 추가하기
        self.view.addGestureRecognizer(keyboardDismissalTabGesture)
        
    }
    
    fileprivate func pushVC(){
        
        var segueId : String = ""
        
        switch searchfiletersegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = "gotoPhotoCollectionVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "gotoUserListVC"
        default:
            print("default")
            segueId = "gotoPhotoCollectionVC"
        }
        
        // 화면이동
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    //MARK: - IBAction method
    
    @IBAction func onsearchbtnClicked(_ sender: UIButton) {
        print("HomeVC - onsearchbtnClicked() called() / \(searchfiletersegment.selectedSegmentIndex)")
        
        // 화면 이동
        pushVC()
    }
    @IBAction func searchfiletervaluechanged(_ sender: UISegmentedControl) {
//        print("HomeVC - searchfiletervaluechanged() - called / selectedindex: \(sender.selectedSegmentIndex)")
        
        var searchbarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchbarTitle = "사진 키워드"
        case 1:
            searchbarTitle = "사용자 이름"
        default:
            searchbarTitle = "사진 키워드"
        }
        self.searchbar.placeholder = searchbarTitle + " 입력"
        
        self.searchbar.becomeFirstResponder() // 포커싱 주기
        
        
        //self.searchbar.resignFirstResponder() // 포커싱 해제
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification){
        print("HomeVC - keyboardWillShowHandle() called")
        //키보드 사이즈 가져오기
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            print("keyboardSize.height: \(keyboardSize.height)")
            print("searchButten.frame.origin.y : \(searchbutten.frame.origin.y)")
            
            if(keyboardSize.height < searchbutten.frame.origin.y){
                print("키보드가 버튼을 덮었다.")
                let distance = keyboardSize.height - searchbutten.frame.origin.y
                self.view.frame.origin.y = distance + searchbutten.frame.height
            }
        }
        
        //self.view.frame.origin.y = -100
    }
    
    @objc func keyboardWillHideHandle(){
        print("HomeVC - keyboardWillHideHandle() called")
        self.view.frame.origin.y = 0
    }
    
    
    // MARK: - UISearchBar Delegate methods

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked() ")
        
        guard let userInputString = searchBar.text else {return}
        
        if userInputString.isEmpty {
            self.view.makeToast("📣 검색 키워드를 입력해주세요.", duration: 2.0, position: .center)
        }else{
            // 화면으로 이동
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() searchText : \(searchText)")
        // 사용자가 입력한 값이 없을때
        if (searchText.isEmpty){
            self.searchbutten.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                // 포커싱 해제
                self.searchbar.resignFirstResponder()
            })
        }else {
            self.searchbutten.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn : \(searchBar.text?.appending(text))")
        
        if (inputTextCount >= 12){
            // toast with a specific duration and position
            self.view.makeToast("💬12자 까지만 입력이 가능합니다.", duration: 2.0, position: .center)
        }
        
//        if inputTextCount <= 12 {
//            return true
//        }else{
//            return false
//        }
        return inputTextCount <= 12
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("HomeVC - gestureRecognizer shouldReceive() called")
        
        //터치로 들어온 뷰가 요놈이면
        if(touch.view?.isDescendant(of: searchfiletersegment) == true){
            print("세그먼트가 터치되었다.")
            return false
        }else if (touch.view?.isDescendant(of: searchbar) == true){
            print("서치바가 터치되었다.")
            return false
        }else{
            view.endEditing(true)
            print("화면이 터치되었다.")
            return true
        }
    }
    

}

