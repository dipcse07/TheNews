//
//  ViewController.swift
//  TheNews
//
//  Created by MD SAZID HASAN DIP on 29/8/20.
//  Copyright © 2020 MD SAZID HASAN DIP. All rights reserved.
//

import UIKit
import CoreData
import Darwin
var articleInfo: ArticleInfo!
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var counterStack: UIStackView!
    @IBOutlet weak var topHeaderViewHeight: NSLayoutConstraint!
    
    
    var articles = [Article]() //core data
     // Article elements
    
    let NEWS_API = "https://newsapi.org/v2/everything?q=bitcoin&from=2020-07-29&sortBy=publishedAt&apiKey=7ebb24c0a01e421397037001866fda15"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        setViews()
        loadArticleFromLocal()
        
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setStatusBar(backgroundColor: .lightGray)
    }
    


    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
    }
    
    func setViews() {
        UIView.animate(withDuration: 1) {
            self.counterStack.frame = CGRect(x: 20, y: 20, width: 150, height: 42)
        }
        



    }
    
    

    
    func loadArticleFromLocal() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            articles = try context.fetch(fetchRequest) as! [Article]
            if articles.count == 0 {
//                let webManager = WebManager()
//                webManager.fetchUrl()

                loadData()
            }
            else {

                self.tableView.reloadData()
                //incrementLabel(to: articles.count, duration: 2.0)

            }
        } catch {
            print("Error while fetching the image")
        }
    }
    
    func loadData() {
        Api.shared.call(url: URL(string: NEWS_API)!, httpMethodType: "GET") { (response, data, error) in
            
            if error == nil {
                let dataString = String(data: data!, encoding: .utf8)
                print(dataString!)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid http status code!")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    if let newsData = try? JSONDecoder().decode(WebDataCodable.self, from: data!) {
                        
                        let parsedArticles = newsData.articles

                        for i in 0..<parsedArticles.count {
                            let sourceName = parsedArticles[i].source?.name ?? ""
                            self.loadImages(articles: parsedArticles, index: i, sourceName: sourceName)
                            //usleep(sleepTime)
                        }

                    }
                }
                else {
                    print("Loading error")
                }
            }
        }
    }
    
    
    func loadImages(articles: [Articles], index: Int, sourceName: String) {
        Api.shared.call(url: URL(string: articles[index].urlToImage!)!, httpMethodType: "GET") { (response, data, error) in
            
            if error == nil {
                let image = UIImage(data: data!)!

                self.saveArticle(
                    sourceName: sourceName,
                    author: articles[index].author ?? "",
                            content: articles[index].content ?? "",
                            description: articles[index].description ?? "",
                            publishedAt: articles[index].publishedAt ?? "",
                            title: articles[index].title ?? "",
                            url: articles[index].url ?? "",
                            urlToImage: articles[index].urlToImage ?? "",
                            image: image.jpegData(compressionQuality: 0.5)!)

                if index == articles.count-1 {
                    DispatchQueue.main.async {
                        //self.saveContext()
                        self.loadArticleFromLocal()
                    }

                }
            }
            else {
                print(error?.localizedDescription as Any)
                self.saveArticle(sourceName: sourceName,
                    author: articles[index].author ?? "",
                            content: articles[index].content ?? "",
                            description: articles[index].description ?? "",
                            publishedAt: articles[index].publishedAt ?? "",
                            title: articles[index].title ?? "",
                            url: articles[index].url ?? "",
                            urlToImage: articles[index].urlToImage ?? "",
                            image: UIImage(named: "noimage")!.jpegData(compressionQuality: 0.5)!)

                if index == articles.count-1 {
                    DispatchQueue.main.async {
                        //self.saveContext()
                        self.loadArticleFromLocal()
                    }

                }
            }
            
        }
    }
    
    
    
    func saveArticle(sourceName: String, author: String, content: String, description: String, publishedAt: String,title: String, url: String, urlToImage: String, image: Data){
        
        //let instance = NSEntityDescription.insertNewObject(forEntityName: "Article", into: context)
        
        let instance = Article(context: context)
//        instance.setValue(sourceName, forKey: "sourceName")
//        instance.setValue(author, forKey: "author")
//        instance.setValue(content, forKey: "content")
//        instance.setValue(description, forKey: "descrp")
//        instance.setValue(publishedAt, forKey: "publishedAt")
//        instance.setValue(title, forKey: "title")
//        instance.setValue(url, forKey: "url")
//        instance.setValue(urlToImage, forKey: "urlToImage")
//        instance.setValue(image, forKey: "image")
        instance.sourceName = sourceName
        instance.author = author
        instance.content = content
        instance.descrp = description
        instance.publishedAt = publishedAt
        instance.title = title
        instance.url = url
        instance.urlToImage = urlToImage
        instance.image = image
        saveContext()
        
    }
    func saveContext() {
        do{
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        //context.reset()
    }
    
//    func incrementLabel(to endValue: Int, duration: Double) {
//        //let duration: Double = 2.0 //seconds
//        DispatchQueue.global().async {
//            for i in 0 ..< (endValue + 1) {
//                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
//                usleep(sleepTime)
//                DispatchQueue.main.async {
//                    self.counterLabel.text = "\(i)"
//                }
//            }
//        }
//    }


    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 1 {
            self.topHeaderViewHeight.constant = 74.0
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
        else {
            self.topHeaderViewHeight.constant = 150.0
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("Now at top")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeVC2DetailsVC" {
            let vc = storyboard?.instantiateViewController(identifier: "DetailsVC") as! DetailsVC
            //vc.articleInfo = articleInfo
        }
    }
    

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell2") as! ArticleCell
        
        //print(articles[indexPath.row].sourceName)
        cell.sourceName.text = articles[indexPath.row].sourceName
        cell.newsTitle.text = articles[indexPath.row].title
        //cell.author.text = articles[indexPath.row].author
        let published = articles[indexPath.row].publishedAt!
        cell.publishedDate.setTitle(customDateFormatter(dateString: published), for: .normal)
        
        //cell.descrp.text = articles[indexPath.row].descrp
        //cell.content.text = articles[indexPath.row].content

        cell.cellImage.layer.cornerRadius = 10
        //print("= = = = = \(articles[indexPath.row].urlToImage ?? "")")
        //cell.articleImage.imageFromServerURL(urlString: "\(articles[indexPath.row].urlToImage ?? "")", PlaceHolderImage: UIImage.init(named: "noimage")!)
        cell.cellImage.image = UIImage(data: articles[indexPath.row].image!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        articleInfo = ArticleInfo(author: articles[indexPath.row].author ?? "",
                                  title: articles[indexPath.row].title ?? "",
                                  descrp: articles[indexPath.row].descrp ?? "",
                                  url: articles[indexPath.row].url ?? "",
                                  urlToImage: articles[indexPath.row].urlToImage ?? "",
                                  publishedAt: articles[indexPath.row].publishedAt ?? "",
                                  content: articles[indexPath.row].content ?? "",
                                  sourceName: articles[indexPath.row].sourceName ?? "",
                                  image: articles[indexPath.row].image!)
         performSegue(withIdentifier: "HomeVC2DetailsVC", sender: self)
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let lastIndexPath = tableView.indexPathsForVisibleRows?.last{
            if lastIndexPath.row <= indexPath.row{
                cell.center.y = cell.center.y + cell.frame.height / 2
                cell.alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                    cell.center.y = cell.center.y - cell.frame.height / 2
                    cell.alpha = 1
                }, completion: nil)
            }
        }
        

//        cell.frame.origin.x = -cell.frame.width
//        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
//            cell.frame.origin.x = 0
//        }, completion: nil)
    }
    
    
}

extension UIImageView {

    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

       if self.image == nil{
             self.image = PlaceHolderImage
       }

       URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

           if error != nil {
               print(error ?? "No Error")
               return
           }
           DispatchQueue.main.async(execute: { () -> Void in
               let image = UIImage(data: data!)
               self.image = image
           })

       }).resume()
   }}

func customDateFormatter(dateString: String) -> String{
    var formattedDate = ""
    let format = "yyyy-MM-dd'T'HH:mm:ssZ"
    let dateFormatterGet = DateFormatter()
    //dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatterGet.dateFormat = format

    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd MMM yyyy" //MMMM = February, MM= 02, MMM= Feb
    var daten: Date?
    if let date = dateFormatterGet.date(from: dateString) {
        daten = date
        formattedDate = dateFormatterPrint.string(from: date)
        //return formattedDate
        
    } else {
       print("There was an error decoding the string")
    }
    
    let today = Date()
    let difference = Calendar.current.dateComponents([.day], from: today, to: daten!).day!

    if difference == 0 {
        return "Today"
    }
    else if difference == 1 {
        return "Yesterday"
    }
    
    return formattedDate
}



extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
