//
//  ViewController.swift
//  Combine-NetworkCall
//
//  Created by HarishSupriya on 2023-08-15.
//

import UIKit
import Combine

class ViewController: UIViewController {
    //Mark:-  Declaring a property called cancellables to store our Combine subscriptions. This prevents memory leaks by automatically canceling subscriptions when they're no longer needed.
    var cancellables = Set<AnyCancellable>()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            posts()
            
        }
    func posts(){
        // Simulate a network request using Combine
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        
        //Mark:- a network request using dataTaskPublisher from URLSession.using tryMap to check the response status code and then decode the received data into a Post object. The sink operator handles the completion and received value, while store(in:) adds the subscription to our cancellables set.
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Post.self, decoder: JSONDecoder())
        //Mark :- sink closure,the switch on the completion to handle .finished or .failure. For a successful result, the receiveValue closure handles the received Post object.
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request finished")
                case .failure(let error):
                    print("Request failed: \(error)")
                }
            } receiveValue: { post in
                print("Received post: \(post.title)")
            }
            .store(in: &cancellables)
    }

}

