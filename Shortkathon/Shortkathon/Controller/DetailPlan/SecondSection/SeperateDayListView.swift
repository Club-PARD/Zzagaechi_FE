import UIKit


class SeperateDayListView : UIView {
    //MARK: - property
    //        var data: [String] = []
    var data: [String] = ["레퍼런스 찾아보기","디자인 제작", "교수님께 피드백 받고 수정", "교수님께 피드백 받고 수정", "교수님께 피드백 받고 수정", "교수님께 피드백 받고 수정"]
    //
    var messageLabel : UILabel = {
        let label = UILabel()
        label.text = "요일을 선택하고 세분화 목록을 여기로 드래그 하세요!"
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size:  12)
        return label
    }()
    
    
    let seperateListTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
        setUI()
        setTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func updateUI(){
        // 데이터가 빈 값이면 label, 있으면 tableView
        if data.isEmpty{
            messageLabel.isHidden = false
            seperateListTableView.isHidden = true
        } else {
            messageLabel.isHidden = true
            seperateListTableView.isHidden = false
        }
        
    }
    
    func setUI(){
        [messageLabel,seperateListTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            seperateListTableView.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            seperateListTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            seperateListTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9),
            seperateListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
    
    func setTable(){
        seperateListTableView.delegate = self
        seperateListTableView.dataSource = self
        seperateListTableView.register(SeperateDayListTableViewCell.self, forCellReuseIdentifier: "SecondSectionCell")
    }
}

//MARK: - tableview extension
extension SeperateDayListView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSectionCell" , for: indexPath) as? SeperateDayListTableViewCell else {return UITableViewCell()}
        cell.backgroundColor = .clear
        cell.taskLabel.text = data[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    
}
