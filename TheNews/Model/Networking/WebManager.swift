//
//  WebManager.swift
//  TheNews
//
//  Created by MD SAZID HASAN DIP on 29/8/20.
//  Copyright © 2020 MD SAZID HASAN DIP. All rights reserved.
//

import Foundation

struct WebManager {
  let webUrl = "https://newsapi.org/v2/everything?q=bitcoin&from=2020-07-29&sortBy=publishedAt&apiKey=7ebb24c0a01e421397037001866fda15"
  
var parsedArticles = [WebDataModel]()
  
  func  fetchUrl(){
      
      performRequest(with: webUrl)
  }
  
  
  
  func performRequest(with urlString: String){
      
      //1.Create a URL
      if  let url = URL(string: urlString){
          //2. Create a URL Session
          let session = URLSession(configuration: .default)
          //3. Give the session a task
          
          let task = session.dataTask(with: url) { (data, response, error) in
              
              if error != nil {
                
                print(error as Any)
                  return
              }
              
              if let safeData = data {
                  let dataString = String(data: safeData, encoding: .utf8)
               print(dataString!)
            //   let parsedArticle =   self.parseJSON(safeData)
                 
                    //  print(parsedArticle)
               let parsedArticles = self.parseJSON(safeData)
            
                print(parsedArticles.count)
                  
                     print("worked")
                  
//                for i in 0..<parsedArticles.count {
//
//
//                    self.saveArticle(author: parsedArticles[i].author ?? "",
//                                content: parsedArticles[i].content ?? "",
//                                description: parsedArticles[i].description ?? "",
//                                publishedAt: parsedArticles[i].publishedAt ?? "",
//                                title: parsedArticles[i].title ?? "",
//                                url: parsedArticles[i].url ?? "",
//                                urlToImage: parsedArticles[i].urlToImage ?? "")
//
//
//                }
                  
                  ///print(safeData.debugDescription)
              }
              
              
          }
          
          //4. Start The Task
          task.resume()
      }
      
  }
    
    func parseJSON(_ webData: Data) ->
    [WebDataModel]{
           
           let decoder = JSONDecoder()
           do {
            var tempArticles = [WebDataModel]()
               let decodedData =   try decoder.decode(WebDataCodable.self, from: webData)
            let status = decodedData.status
            let articles = decodedData.articles
            //print(status)
            //let articles = decodedData.articles
            for article in articles {
                //print("= = = = = = = = \(article.content)")
                let singleArticle = WebDataModel(author: article.author, title: article.title, description: article.description, url: article.url, urlToImage: article.urlToImage, publishedAt: article.publishedAt, content: article.content)
                
                tempArticles.append(singleArticle)
                //print(singleArticle)
            }
               
           
        
            return tempArticles
               
           }catch{
            
            print(error)
            return []
            
           }
       }
       
    
    

    

  
}



class Api: NSObject {
    
    static let shared = Api()

    func call(url: URL, httpMethodType: String, completion: @escaping(_ response: URLResponse?, _ data: Data?, _ error: Error?)-> Void) {
        
        let sessionConfig = URLSessionConfiguration.default

        sessionConfig.timeoutIntervalForResource = 100.0


        let session = URLSession(configuration: sessionConfig)

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "\(httpMethodType)"

        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            completion(response, data, error)
        })
        task.resume()
    }
}
