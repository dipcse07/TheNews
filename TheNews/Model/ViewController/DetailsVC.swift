//
//  DetailsVC.swift
//  TheNews
//
//  Created by MD SAZID HASAN DIP on 29/8/20.
//  Copyright © 2020 MD SAZID HASAN DIP. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //var articleInfo: ArticleInfo! // Article elements
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        
    }
    
    func setViews() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.setStatusBar(backgroundColor: .systemBackground)
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsViewCell1") as! DetailsViewCell
            
    
            
            cell.newsTitle.text = articleInfo.title
            cell.source.text = articleInfo.sourceName
            cell.dateStatus.text = customDateFormatter(dateString: articleInfo.publishedAt )
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsViewCell2") as! DetailsViewCell
            
            cell.descrp.text = articleInfo.descrp
            cell.coverImage.image = UIImage(data: articleInfo.image)
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsViewCell3") as! DetailsViewCell
            cell.fullContent.text = articleInfo.content
            return cell
        }
        
//        if indexPath.row == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsViewCell4") as! DetailsViewCell
//
//            return cell
//        }
        

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
