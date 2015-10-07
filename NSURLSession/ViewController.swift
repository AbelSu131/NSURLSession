/*
过去通过 NSURLConnection.sendSynchronousRequest()方法能同步请求数据。
从iOS9起，苹果建议废除 NSURLConnection，使用 NSURLSession 代替 NSURLConnection。
如果想要NSURLSession也能够同步请求，即数据获取后才继续执行下面的代码，使用信号、信号量就可以实现。

*/
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //创建NSURL对象
        let urlString:String = "http://www.baidu.com"
        let url:NSURL! = NSURL(string: urlString)
        
        //创建请求对象
        let request:NSURLRequest = NSURLRequest(URL:url)
        
        let session = NSURLSession.sharedSession()
        
        let semaphore = dispatch_semaphore_create(0)
        
        let dataTask = session.dataTaskWithRequest(request,
            completionHandler: {(data,response,error) -> Void in
                if error != nil{
                    print(error?.code)
                    print(error?.description)
                }else{
                    let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print (str)
                }
                dispatch_semaphore_signal(semaphore)
        })as NSURLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER)
        print("数据加载完毕")
        
        //继续执行其他代码。。。。。

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

