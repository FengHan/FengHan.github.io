---
layout: post
title: "Ubuntu Octopress"
date: 2015-12-17 09:55:39 +0000
comments: true
categories:  octopress
---
root 用户权限
- 添加ssh-key到github上

- apt-get install git ruby ruby-dev nodejs 

	
- git clone -b source https://github.com/FengHan/fenghan.github.io octo
- gem install bundler  
- bundle install  
- rake setup_github_pages 
- 输入https://github.com/FengHan/fenghan.github.io




- rm -rf _deploy

- git clone  https://github.com/FengHan/fenghan.github.io _deploy

- rake deploy 
- 输入github的用户名和密码



