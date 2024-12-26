import UIKit


class SeperateTaskView : UIView {
    //MARK: - property
    var task : [String] = [""]
    let seperateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size:   20)
        label.text = "세분화"
        return label
    }()
    
    let questionButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "QuestionImage"), for: .normal)
        return button
    }()
    
    let seperateTaskTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.allowsSelection = false
        view.showsVerticalScrollIndicator = false

        return view
    }()
    
    let plusTaskButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlusImage"), for: .normal)
        
        return button
    }()
    
    let tipImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Tips")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isHidden = true
        return image
    }()
    
    
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTable()
        setUI()
        tipButtonAction()
        
        plusTaskButton.addTarget(self, action:  #selector(plusAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        [seperateLabel,questionButton,seperateTaskTableView,plusTaskButton,tipImage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            seperateLabel.topAnchor.constraint(equalTo: self.topAnchor ,constant: 18),
            seperateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 19),
            
            questionButton.topAnchor.constraint(equalTo: self.topAnchor ,constant: 18),
            questionButton.leadingAnchor.constraint(equalTo: seperateLabel.trailingAnchor, constant:   1),
            questionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -254),
            
            tipImage.leadingAnchor.constraint(equalTo: questionButton.trailingAnchor),
            tipImage.bottomAnchor.constraint(equalTo: questionButton.topAnchor, constant: 2),
            tipImage.widthAnchor.constraint(equalToConstant: 191),
            tipImage.heightAnchor.constraint(equalToConstant: 40),
            
            seperateTaskTableView.topAnchor.constraint(equalTo: seperateLabel.bottomAnchor , constant: 21),
            seperateTaskTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            seperateTaskTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9),
            seperateTaskTableView.heightAnchor.constraint(equalToConstant: 200),
            
            plusTaskButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusTaskButton.topAnchor.constraint(equalTo: seperateTaskTableView.bottomAnchor, constant: 6.5 )
        ])
    }
    
    func setTable(){
        seperateTaskTableView.delegate = self
        seperateTaskTableView.dataSource = self
        seperateTaskTableView.register(SeperateTaskViewTableCell.self, forCellReuseIdentifier: "ThirdTableCell")
        seperateTaskTableView.isUserInteractionEnabled = true

    }
    
    func tipButtonAction() {
        questionButton.addTarget(self, action: #selector(questionButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func questionButtonTapped() {
        tipImage.isHidden = false
    }
    
    @objc private func handleBackgroundTap() {
        tipImage.isHidden = true
        print(task)
        self.endEditing(true)
    }
    
    @objc private func plusAction(){
        task.append("")
        print(task)
        seperateTaskTableView.reloadData()
    }
}


//MARK: - TableView Extension
extension SeperateTaskView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableCell", for: indexPath) as? SeperateTaskViewTableCell else {
            
            return UITableViewCell()
        }
        
        cell.taskTextField.text = task[indexPath.row]
        cell.taskTextField.tag = indexPath.row
        cell.taskTextField.delegate = self
        
        // 셀과 텍스트필드의 사용자 상호작용 활성화
        cell.isUserInteractionEnabled = true
        cell.taskTextField.isUserInteractionEnabled = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}


//MARK: - textField extension
extension SeperateTaskView : UITextFieldDelegate {
    //textFiled 편집되었을떄 호출
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트필드 편집 시작할 때 호출
        print("텍스트필드 편집 시작")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        task[textField.tag] = textField.text ?? ""
    }
    
    // Enter 눌렀을때 return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
       
       // 스와이프 스타일 설정
       func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .delete
       }
       
       // 삭제 액션 처리
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // 데이터 소스에서 항목 삭제
               task.remove(at: indexPath.row)
               
               // TableView에서 행 삭제
               tableView.deleteRows(at: [indexPath], with: .fade)
               
               // task 배열이 비어있으면 빈 문자열 추가
               if task.isEmpty {
                   task.append("")
                   tableView.reloadData()
               }
           }
       }
       
       // (선택사항) 삭제 버튼 텍스트 커스텀
       func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
           return "삭제"
       }
}
