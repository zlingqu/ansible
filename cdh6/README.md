# 1 介绍

## 1.1 CDH
CDH(Cloudera’s Distribution，including Apache Hadoop)，是 Hadoop 分支中的一种，由 Cloudera 维护，基于稳定版本的 Apache hadoop 构建，并继承了许多补丁，可以直接用于生产环境。


## 1.2 运行此项目，需要了解以下基础知识：

- linux
- docker
- hadoop生态圈
- ansible
- mysql

## 1.3 版本
- CentOS 7.6 X64
- CM-6.3.1
- CDH-6.3.2
- JDK-1.8.0_181
- MySQL-5.7.24

## 1.4 环境


IP             | HostName | OS                | Memory  | CPU  |Sys Disk | Data Disk| role
---------------|----------|-------------------|-------  |------|-------- |----------|------------
|192.168.3.223 | cdh-223  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Server & Agent|
|192.168.3.224 | cdh-224  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.225 | cdh-225  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.226 | cdh-226  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.227 | cdh-227  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.228 | cdh-228  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.229 | cdh-229  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.230 | cdh-230  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.231 | cdh-231  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.232 | cdh-232  | CentOS 7.6 x86_64 | 16GB    | 8core|  100GB  |200GB     | Agent|
|192.168.3.199 | mysql    | CentOS 7.6 x86_64 | 4GB     | 2core|  5GB    |100GB     | mysql|

# 2 MySQL安装

在192.168.3.199上安装docker和docker-compose
使用docker-compose部署mysql，其中账号密码等信息，可见docker-compose.yml

```
mkdir -pv /data/mysql/data
cp mysql/* /data/mysql
cd /data/mysql
docker-compose up -d
```

根据需要创建数据库，scm用于cm，另外三个是相关组件使用的，也可以先不创建，等部署完成通过web初始化时创建

```sql
create database db_cdh6_scm; 
create database db_cdh6_hive;
create database db_cdh6_report_manager;
create database db_cdh6_oozie; 
```

# 3 cdh安装

## 3.1 下载大文件

整个部署过程中有些大的问题需要下载，为了加快部署速度，将其下载到ansible服务器，再通过内分发。准备好以下两个目录
### 3.1.1 cloudera-manager-daemons缓存目录，我这里是/home,hosts.ini中定义的
我选择的是6.3.1版本，所以到 [cm6](https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/)下载，只需要下载cloudera-manager-daemons即可，另外两个包比较小，可以不下载

```
cd /home
wget clou***rpm
```

### 3.1.2 CDH-....parcel的缓存目录，我这里是/home/parcel-repo/，hosts.ini中定义的

我选择的是6.3.2 版本，所以到[cdh6](https://archive.cloudera.com/cdh6/6.3.2/parcels/)下载，下载
CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel和CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1

```
cd /home/parcel-repo/
wget CDH***parcel
wget CDH***parcel.sha1
mv CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1 CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha
```
# 3.2 部署

## 3.2.2 部署准备

```
cd ansible
ansible-playbook 01-prepare.yml
```

## 3.2.3 部署cm

```
ansible-playbook 02-cm.yml
```

## 3.2.4 部署cdh

```
ansible-playbook 03-cdh.yml
```
# 4 配置

上面步骤都完成后，访问 Web 控制台进行配置，http://192.168.3.223:7180/cmf/login ，默认用户名密码都是：admin

具体的操作我这里不再演示，按照步骤一步步配置即可，需要提醒的是

1）有些组件需要数据库,在配置时需要填入，如果上面没有创建，请创建

2）NN和SNN不应位于同一个节点，否则会有告警

3）应该有JournalNode且多余一个，数据应是奇数，比如3或者5

4）默认的配置中内存可能是不够的，应该根据提示进行扩展
