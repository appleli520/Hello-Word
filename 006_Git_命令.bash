###-- 2020-9-17  星期四
# Git的升级方法
查看版本
git --version
卸载旧版git
yum remove git
安装yum源
c6
yum install http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm
c7
yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
安装
sudo yum install git
检查：
git version 2.22.0



#  常用命令
# 初始化
cd maven-webapp-master
git init
git config --local user.name "kf"
git config --local user.email "kf@qq.com"
git remote add origin http://kf:12345678@10.0.0.26/group_01/02_webapp.git
git pull origin master
# 切换分支，快速推送
git branch dev_test
git checkout dev_test
echo 1 >> push.txt
git add .
git commit -m "push.txt  dev_test +1"
git push -u origin dev_test





#  新项目开发步骤
01. 开发者将远端的 master分支，克隆到本地
02. 在本地新建一个 dev 分支
03. 在本地的dev分支上进行开发
04. 将开发完毕的 dev分支，推送到 远程仓库的 dev分支
05. 开发者登录gitlab，在gitlab页面上发起dev分支与master分支的合并请求
06. 开发主管登录gitlab，在该项目的合并请求下，将dev分支与master分支进行合并（分支合并后可以删除）
07. 待 master分支 与 dev分支 合并完成后，远端的 master分支 将会是最新的状态
08. 开发者在开发下一个功能时，需要先切换到本地的 master分支，将远端最新的 master分支 拉取到本地
09. 然后将本地的旧的 dev分支 删除掉，根据新功能的内容，新建一个新的分支 dev02
10. 然后在本地的新分支 dev02 上进行新功能的开发。


#  开发新分支前的准备
切换并同步消息
git checkout master   切换到分支master
git fetch                      将远端master的HEAD指向 同步到本地
git remote prune origin   将远端分支列表 同步到本地
拉取并查看信息
git pull origin master   将远端master的代码拉取到本地
git branch -avv            查看 本地 和 远端 所有分支
git log --oneline --decorate --graph   查看简版日志+HEAD指向
创建开发新分支
git checkout -b fz_01   新建并切换到分支fz_02



#  在本地解决可能存在的冲突
查看并测试，在本地将 dev分支 与 master合并，解决冲突后，再将 dev分支 推送到远端，再发起合并请求。

方法1：缓存克隆法（无需切换分支，方便）
1. 将远程的全部信息  拉取到本地的 “远程暂存区”
git fetch
2. 创建 “远程暂存区”的临时分支
git branch fz_temp origin/master   新建分支fz_temp
3. 将 本地开发分支 与 临时分支 进行对比
git checkout fz_04     切换到分支fz_04
git diff fz_temp
4. 将 临时分支 合并到 本地开发分支
git checkout fz_04     切换到分支fz_04
git rebase fz_temp
5. 查看冲突文件
git status命令
Unmerged paths:下面列出的就是全部冲突文件，挨个解决即可
6. 解决冲突后，继续rebase的合并
git add *
git rebase --continue
7. 合并完成后，清理临时分支
git branch -d fz_temp   删除本地的临时分支fz_temp
8. 将 本地开发分支 推送到远端gitlab的 fz_04
git push -u origin fz_04
9. 在gitlab网页发起 fz_04 和 master 的合并请求
10. 管理员批准，合并通过。

注：如果在 git rebase 的过程中，如果出现了无法解决的冲突，可以使用如下命令，使当前的 本地开发分支 回退到git rebase之前的状态。
git rebase --abort

















# Git 的使用方法


#  1.  Git 本地基础设置
    1) 本地用户名设置（全局变量：global）
            git config --global user.name "lyw"
            git config --global user.email "lyw@qq.com"
        为某个项目单独设置一个用户名（局部变量：local）
            git config --local user.name "kf"
            git config --local user.email "kf@qq.com"
                情景1：项目用户和全局用户的ssh秘钥一致
                          无需其他设置即可。
                情景2：项目用户和全局用户的ssh秘钥 不一致
                          由于两个用户使用的ssh秘钥不一致，所以即便单独为项目设置了局部用户，也是无法推送代码的，所以要将局部项目的远程地址由 ssh 方式更换为 http方式，这样当推送代码的时候，手动输入用户名和密码，即可。
    2) 察看配置
            git config -l --local
            git config -l --global
            编辑-配置
            git config -e --local
            git config -e --global
            取消-配置
            git config --local --unset user.name
    3) 显示颜色
            git config --global color.ui true
    4) 设置别名
            (直接用 git st 就可以做 git status 的事了)
            git config --global alias.st "status"
            git config --global alias.s "status -s"
            git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)%s%Creset %Cgreen(%cr) <%an>%Creset' --abbrev-commit --date=relative"
            git config --global alias.lgs "log --graph --stat"
            git config --global alias.f "fetch"
            git config --global alias.r "remote prune origin"
            git config --global alias.b "branch -avv"
    5) 设置-代码格式-检测到什么格式就提交为什么格式
            git config --global core.autocrlf false
    6) 忽略文件
        说明：
            本地不提交的文件（忽略追踪，不加入版本库） .gitignore 文件示例
            .gitignore 文件本身不可忽略，要在项目的根目录下，共享给所有开发者
        内容示例：
            !.gitignore
            .env
            .settings/
            */.settings/
            .DS_Store
            */.DS_Store
            .idea/
            */.idea/
            *.log
            #  忽略 .gitignore 所在目录的 vpn 目录，但不忽略 /vpn/1.jpg 这个文件
            /vpn
            !/vpn/1.jpg

#  2. 忽略已被记录的文件
    1) 说明：
            如果已有文件想从版本库中取消跟踪，可以使用如下命令,取消某文件的版本库追踪，只删除版本库中的文件，本地不删
    2) 示例：
            git rm -r --cached xxx （xxx即为待删除的远端文件（版本库中的文件））
            git add .
            git commit -m "删除远端的 xxx 文件"
            git push -u origin master

#  3. 创建一个新的项目、然后推送
            mkdir test001
            cd test001
            git init
            touch README.md
            git add README.md
            git commit -m "first commit"
            git remote add origin https://github.com/appleli520/text001
            git push -u origin master

#  4. 推送一个已有的项目
            cd test001
            ----  添加一个远程仓库，名称设置为 origin ，地址为：https 或 ssh
            git remote add origin https://github.com/appleli520/text001
            ----  把本地的 master 分支的数据，推送到名称为 origin 的远程仓库
            git push -u origin master
            ----  把本地的 dev 分支的数据，推送到名称为 origin 的远程仓库
            git push -u origin dev

#  5. 远程仓库地址-相关操作 
    1) 查看
            git remote -v
    2) 添加
            git remote add [远程仓库名] [远程git服务器地址]
    3) 清除
            git remote rm [远程仓库名]
#  5.1  http方式免密码提交
    1) 在添加http远端地址的时候，直接加上用户名和密码即可
            git remote add origin https://账号:密码@github.com/appleli520/text001


#  6. 常用操作
    1) 察看本地状态
            git status
    2) 提交本地仓库
            git add .
            git commit -m "创建了一个文件txt"
    3) 拉取代码
            cd test001
            git init
            git remote add origin https://github.com/appleli520/text001
            git pull origin master
    4) 删除文件
            git rm xxx
            git commit -m "删除 xxx文件"
    5) 撤销对某一个文件的修改（未提交）
            git checkout 1.txt
            清空所有修改
                git checkout .
                git status

#  7. 日志
    1) 详细版
            git log
    2) 简版
            git log --oneline  或者（git log --pretty=oneline）
    3) 简版+HEAD
            git log --oneline --decorate
    4) 简版+HEAD + 树状图
            git log --oneline --decorate --graph
    5) 简版+HEAD + 树状图 + 最近的10次
            git log --oneline --decorate --graph -10

#  8. 更新-回滚
    1) 查看本地更新的记录
            git reflog
    2) 清空本地修改，回到修改前的版本
            git reset --hard
    3) 回滚到之前的指定版本
            git reset --hard fd35h567

#  9. 跨版本提交（强制提交）
git push -u origin master -f


#  10. 分支
    1) 查看-分支
            git branch 查看本地当前分支 
            git branch -r    查看远端所有分支
            git branch -avv    查看 本地 和 远端 所有分支（方便）
            git branch aaa 新建分支aaa  
    2) 新建-分支
            git checkout aaa 切换到分支aaa  
            git checkout -b aaa 新建并切换到aaa  
    3) 合并-分支（用 rebase替代merge 更好，更简洁）
            git merge aaa 把aaa分支的代码合并过来(当前所在分支，比如master) 
            git merge origin/master
            将 临时分支fz_temp 合并到 本地开发分支fz_04（推荐）
            git checkout fz_04     切换到分支fz_04
            git rebase fz_temp
            解决冲突后，继续rebase的合并（推荐）
            git add *
            git rebase --continue
    4) 删除-分支 
            git branch -d aaa 删除本地分支aaa
            git branch -D aaa 强制本地分支aaa
            git branch -d -r origin/aaa  删除本地保存的 远程分支aaa的缓存（一般不用）
            git push origin --delete aaa  远程删除git服务器上的分支（一般不用）
    5) 同步-远程分支列表到本地
            git remote prune origin   （清理远程不存在的分支）
            git remote prune origin --dry-run   （尝试运行）
            
    6) 合并分支
        常用开发步骤：
            01. 开发者将远端的 master分支，克隆到本地
            02. 在本地新建一个 dev 分支
            03. 在本地的dev分支上进行开发
            04. 将开发完毕的 dev分支，推送到 远程仓库的 dev分支
            05. 开发者登录gitlab，在gitlab页面上发起dev分支与master分支的合并请求
            06. 开发主管登录gitlab，在该项目的合并请求下，将dev分支与master分支进行合并（分支合并后可以删除）
            07. 待 master分支 与 dev分支 合并完成后，远端的 master分支 将会是最新的状态
            08. 开发者在开发下一个功能时，需要先切换到本地的 master分支，将远端最新的 master分支 拉取到本地
            09. 然后将本地的旧的 dev分支 删除掉，根据新功能的内容，新建一个新的分支 dev02
            10. 然后在本地的新分支 dev02 上进行新功能的开发。
            
    7) GitLab的使用
            1. 安装包使用 ce 社区版即可
            2. 安装完成后，在设置里取消自主注册账号的功能
            3. 先创建一个组，然后在组内创建项目
            4. 新建的用户，设置归属的某个组
            5. 新建的用户的项目的权限中使用 develop 权限即可
            6. 管理员可以拥有master权限，可以合并分支请求。
            7. 如果master是生产环境专用，那么可以设置master分支保护，即 develop权限的用户不能向 master分支 推送代码，只能向 dev分支推送代码
            8. 由 master用户 将申请的合并请求进行合并。


#  11. 加版本号(标签)（仅本地有效）
    1) 方法1：
            指定当前状态为标签（加版本号，并添加注释 ）
                git tag -a v1.0 -m "合并 master 和 02 分支"  
    2) 方法2：
            指定某一次提交为标签（加版本号，并添加注释，并指定某一次提交的哈希值）
                git tag -a v1.0 -m "合并 master 和 02 分支" fd35h567
    3) 删除标签
            git tag -d v1.0
    4) 查看版本号
            git tag 查看当前版本号
            git show v1.0  查看某一个版本的详细信息
    5) 切换版本
            git checkout v1.0 切换到版本v1.0  
    6) 直接还原数据到某个版本
            git reset --hard v1.0


#  12. 只拉取部分站点目录
    1) 说明：
            git 1.7 之后的版本支持 ， sparse-checkout 功能，采用白名单的方式拉取指定站点目录
    2) 开启本地白名单功能
            git remote add -f origin https://git.calistar.cn/cali/InvoicingSystem.git
            git config core.sparsecheckout true
    3) 将不需要拉取的 文件 或 目录，写入 sparse-checkout 文件
            echo "CaliThink Management Center/Stocktake/dingtalk" >> .git/info/sparse-checkout
            git pull origin master



#  ==========================
#  案例1：线上 与 本地 的异步处理  
#  ==========================
1) 简介：
        当线上的master库被强制回退之后，在本地已有的库中会出现log不同步的状况，即使git pull origin master 、会提示：Already up to date.
        但使用 git diff master origin/master 将远端与本地进行对比时，会发现，文件还是没有同步。
        此时可以使用如下方法解决
        
2) 解决方法：
        git fetch
        git reset --hard origin/master
        git log





#  ==========================
#  案例1：两个人同时修改了同一个文件
#  ==========================
1) 简介：
        第一个人推送成功
        第二个人推送：报错
        [root@Cs6_15 02]# git push -u origin master
        To git@github.com:appleli520/t01.git
         ! [rejected]        master -> master (fetch first)
        error: failed to push some refs to 'git@github.com:appleli520/t01.git'
        hint: Updates were rejected because the remote contains work that you do
        hint: not have locally. This is usually caused by another repository pushing
        hint: to the same ref. You may want to first integrate the remote changes
        hint: (e.g., 'git pull ...') before pushing again.
        hint: See the 'Note about fast-forwards' in 'git push --help' for details.

2) 解决方法：
方法1：（推荐）
    把本地修改过的文件（即修改的同一个文件）移出本地目录，用线上最新的版本拉取到本地进行覆盖，然后手动对比，修改后，再次推送提交。

方法2：
    强制将线上最新的版本拉取到本地进行合并，然后根据提示报错信息，修改有冲突的文件
git add .
git commit -m "创建了一个文件txt"
git pull origin master
[root@Cs6_15 02]# git pull origin master
From github.com:appleli520/t01
 * branch            master     -> FETCH_HEAD
Auto-merging 3
CONFLICT (content): Merge conflict in 3
Automatic merge failed; fix conflicts and then commit the result.
[root@Cs6_15 02]# echo $?
1
[root@Cs6_15 02]# 
[root@Cs6_15 02]# cat 3
<<<<<<< HEAD # （HEAD本地）
333333333333333333333333333333333
44
=======       #  （对比分割线）
3dd33333333333333333333333333333333
2
>>>>>>> 26f4fd4421a2310084e44b99df9990f9a8ef795e  #（线上最新版本）  
[root@Cs6_15 02]#

[root@Cs6_15 02]# git status  #  查看状态
On branch master
Your branch and 'origin/master' have diverged,
and have 1 and 1 different commit each, respectively.
  (use "git pull" to merge the remote branch into yours)
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   3   #  待手动合并冲突的文件

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	3-3
	4

no changes added to commit (use "git add" and/or "git commit -a")
[root@Cs6_15 02]#













