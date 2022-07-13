## DevOps Projects 中文版本
等一下再把原本翻成中文

# 概念説明
本倉庫的目標是給我多實際經驗使用各種各類DevOps科技，以及使用git所發佈。有一些項目以這樣的科技為實現個人目的 ，比如發佈網站應用還是設置媒體服務器 ，另外一些更類似在企業環境裏可遇到的 ，像kubernetes cluster 、 堆棧 、 聯網等。科技企業中有存在的話 ，我會找到辦法把它自動化。

# 下一些目標
* 寫完本説明件。
* 為所有項目檔案而寫完説明件
* 創造實驗工作流程由推實驗性python應用的更改以推出新有實驗性標簽的docker immage

# 使用科技
* Terraform
* Docker
* Kubernetes
* Ansible
* Python
* Linux and shell scripting

# 如何使用
因爲各工具有各的用法 ，所以沒一個副文件夾有更詳細怎麽運行的描述。不過有一些過程用著相同的文件合并。每當一個文件參考另外一個文件 ， 此編碼假設原來目錄的模型是一樣的。
例如：Digital Ocean init 檔案參考在同一個目錄特定的 cloud-init 檔案。爲收到最順利體驗，千萬 clone 全部倉庫。

# 學習心得
 * Linux -  
   我排查故障以及OS知識都進步了很多。我正在可以更仔細的描述電腦構件運作及應用和形成跟實體構件互動， 包括引導/init (systemd and sysVinit), deamons, 二進文件, 如何安裝程序 (編碼包裹管理, cURL, 或者從源自編碼編輯), 聯網概念和如何改善或者排查聯網選項, SSH 和鑰匙管理, 和火成設計. 
 * Docker -  
   用互動模式的命令而發動一個容器 `docker run CONTAINER_NAME -it /bin/bash` is a very helpful way to troubleshoot networking and file permission issues from inside a container.  
 * Ansible -  
   When I first used ansible to copy over the config files for my media server, I accidentally set the ownership to Root. Being able to use the YAML file to see where I had gone wrong and fix the issue gave me my first taste of how useful infrastructure as code is. 
 * Kubernetes -  
   I have already learned the basic setup of a Kubernetes cluster and many of the objects available. Each master node requires ETCD, the API server, the scheduler, and the controller manager; while each worker node requires docker, kubelet, and kube proxy, and I understand the concepts of how these work together. I have hands on experience creating ingress, secrets, config maps, services and deployments, and volumes. I have also looked at Helm charts, but haven't used or written one, yet.  
   So far, I have done all of this through the console and haven't needed to use a 3rd party API. Some important debugging tools I've learned are:  
   * `kubectl api-resources` to check which API version is used with each object
   * `kubectl exec -it NAME-REPLICASET-POD --/bin/bash` to run a pod interactively
   * `kubectl get` nodes, services, deployments, pods, etc.  

   Configuring certificates, stateful sets, and setting up a cluster from scratch are still on the road ahead.  
   
# 幫助鏈接
雖然把本來的編碼而改到適合我的需求，我卻沒有一些的YouTuber的幫助就不會做本倉庫。
* DB Tech 的 Docker 的媒體服務器  
https://www.youtube.com/playlist?list=PLhMI0SExGwfAdXDmYJ9jt_SxjkEfcUwEB  
* Tech World with Nana 的 Kubernetes 的走查  
https://www.youtube.com/watch?v=X48VuDVv0do&t=12399s  
   
