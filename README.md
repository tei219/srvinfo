srvinfo
=======
server information gatherer for (alomost all) Windows Server.

required
---
* [dsquery.exe](https://www.google.co.jp/search?q=dsquery.exe) | [info](http://technet.microsoft.com/en-us/library/cc732952%28v=ws.10%29.aspx)
* [dsget.exe](https://www.google.co.jp/search?q=dsget.exe) | [info](http://technet.microsoft.com/en-us/library/cc755162%28v=ws.10%29.aspx)
* systeminfo.exe | [info](http://technet.microsoft.com/en-us/library/bb491007.aspx)  
* [psexec.exe](https://www.google.co.jp/search?q=psexec.exe) | [info](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx)  

to collect information
---
* diskmapinfo   | get disk drive map(disk, partition, size, driveletter)
* envinfo       | get server environmental variables
* ipconfiginfo  | get result of 'ipconfig /all'
* iprouteinfo   | get result of 'route print'
* msinfo        | get microsoft information description using 'msinfo32'
* psinfo        | get current process list
* serviceinfo   | get service list
* sqlsvrinfo    | get sqlserver information (and useful settings) 
* systeminfo    | get system information summary using 'systeminfo'

todo
---
- [ ] usage
- [x] cmdcheck.bat
- [x] sql 2012 -> 2000
- [ ] write log


- - - 
フォルダってどうやって作るの…？  
わはははは  
消せない(´；ω；｀)ﾌﾞﾜｯ  
shellから消すのか…  
shellはcloud9でいいね。  
悩む… むーんむーん  
共依存でもいいよね…  
各バッチで呼び出すコマンドは conf\cmds_spec に集約  
makelist.bat で対象をフィルタできるように  
systeminfo 復活  
よしよし  
あれだな、採取するやつは選べるようにしないといかんな  
conf\selection.txt で選べるようになりました  

