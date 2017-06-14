# LAMP環境

## Vagrant

### プラグインのインストール

```
$ vagrant plugin install vagrant-proxyconf
$ vagrant plugin install vagrant-hostsupdater
$ vagrant plugin install vagrant-cachier
```

### 起動コマンド

```
$ vagrant up
```

### プロビジョニングコマンド

```
$ vagrant provision
```

### SSH接続

```
$ vagrant ssh
```

## LAMP

### WEB Server

* Apache

### PHP

* バージョン：5.5.37

### MySQL

* バージョン：5.6.31

rootのパスワードの設定（mysqladminでrootのパスワードを設定する：※平文になってしまいますが、ローカル環境のためこちらのコマンドで設定）

```

$ vagrant ssh
$ sudo -s
# mysqladmin -u root password 'root用の任意パスワード'
```

#### Socketのエラーが起きた場合

```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock'
```

socketファイルがあるか確認、なかった場合は作成し所有者を変更をかける

```
$ ls -al /var/lib/mysql/
$ sudo touch /var/lib/mysql/mysql.sock
$ sudo chown mysql:mysql /var/lib/mysql
$ sudo /etc/init.d/mysqld restart
```

rootのパスワードで接続できるか確認

```
# mysql -u root -p
Enter password:
```

### phpMyAdmin

* バージョン：4.4.15.7

http://local.dev/phpMyAdmin/

