//
//  ViewController.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import UIKit

class GameArena: UIViewController, LogoDelegate {

    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var viewButtonsContainer: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //TODO:Ideally use dependency injection
    let viewModel = GameViewModel(gameLevel: 1)
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTxt.delegate = self
        viewModel.logoDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
        loadData()
        layoutButtons()
    }
    
    func loadData() {
        if let logo = viewModel.getLogo() {
            print(logo.name)
            //1. Dowload the image and attach to the imageview
            spinner.startAnimating()
            downloadImage(url: logo.imgURL, handler: { [weak self] data in
                self?.spinner.stopAnimating()
                self?.logoImageview.image = UIImage(data: data) ?? nil
                self?.arrangeLetters()
                self?.viewModel.startTimer()
            })
        }
        title = "Score: \(Score.shared.getScore())"
    }
    
    func downloadImage(url : String, handler : ((Data) -> ())? ) {
        let url = URL(string: url)!
        DispatchQueue.global().async {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                       handler?(data)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func arrangeLetters() {
        let letters = viewModel.getLetters()
        for index in 0 ..< buttons.count {
            let button = buttons[index]
            button.setTitle(String(letters[index%letters.count]), for: .normal)
        }
    }
    
    func shouldDisplayNext() {
        answerTxt.text = ""
        loadData()
    }
    
    func restartGame() {
        viewModel.clearGameData()
        answerTxt.text = ""
        title = ""
        logoImageview.image = nil
        viewButtonsContainer.subviews.forEach({ $0.removeFromSuperview() })
        buttons.removeAll()
    }
    
    func didGameEnd(score : Int) {
        restartGame()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResultVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func layoutButtons() {
        let numberOfButtonsOnALine = 5
        let space = 5
        let totalWidth = viewButtonsContainer.frame.size.width
        let totalHeight = viewButtonsContainer.frame.size.height
        let spaceRequired = space * (numberOfButtonsOnALine + 1)
        let buttonSize = (Int(totalWidth) - spaceRequired)/numberOfButtonsOnALine
        let buttonHeight = (Int(totalHeight) - spaceRequired)/numberOfButtonsOnALine
        
        var buttonsLayed = 0
        var rowNumber = 0
        let totalButtons = 20
        for index in 0 ..< totalButtons {
            let button = UIButton.init(frame: CGRect.init(x: space + (index % numberOfButtonsOnALine) * (buttonSize + space),
                                                          y: space + rowNumber * (buttonHeight + space),
                                                          width: buttonSize,
                                                          height: buttonHeight))
            button.tag = index
            button.setTitle("\(index)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.black.cgColor
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            viewButtonsContainer.addSubview(button)
            buttons.append(button)
            
            buttonsLayed += 1
            if buttonsLayed >= numberOfButtonsOnALine {
                buttonsLayed = 0
                rowNumber += 1
            }
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        answerTxt.text = ( answerTxt.text ?? "" ) + ( sender.title(for: .normal) ?? "" )
        viewModel.verifyIfLogoIdentified(string: answerTxt.text ?? "")
    }
}

extension GameArena : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            viewModel.verifyIfLogoIdentified(string: answerTxt.text ?? "")
        }
        return true
    }
}
