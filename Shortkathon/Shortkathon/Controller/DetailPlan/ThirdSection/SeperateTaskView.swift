import UIKit


class SeperateTaskView : UIView {
    //MARK: - property
    var task : [String] = []
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
        return view
    }()
    
    let plusTaskButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlusImage"), for: .normal)
        return button
    }()
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTable()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        [seperateLabel,questionButton,seperateTaskTableView,plusTaskButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            seperateLabel.topAnchor.constraint(equalTo: self.topAnchor ,constant: 18),
            seperateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 19),
            
            questionButton.topAnchor.constraint(equalTo: self.bottomAnchor ,constant: 18),
            questionButton.leadingAnchor.constraint(equalTo: seperateLabel.trailingAnchor, constant:   1),
            questionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -254)
            
            
            
        ])
    }
    
    func setTable(){
        seperateTaskTableView.delegate = self
        seperateTaskTableView.dataSource = self
        seperateTaskTableView.register(SeperateTaskViewTableCell.self, forCellReuseIdentifier: "ThirdTableCell")
        
    }
    
    
}


//MARK: - TableView Extension
extension SeperateTaskView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableCell", for: indexPath) as? SeperateTaskViewTableCell else {return UITableViewCell()}
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return task.count
    }
    
    
}
