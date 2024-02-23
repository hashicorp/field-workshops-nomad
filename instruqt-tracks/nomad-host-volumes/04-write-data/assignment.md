---
slug: write-data
id: mlcqxqaegtmb
type: challenge
title: Write Data to the MySQL Database
teaser: |
  Write some data to the MySQL database.
notes:
- type: text
  contents: |-
    In this challenge, you will examine the tables and data of the MySQL database that your Nomad job is running.

    You will then write some data to a table in the MySQL database. This data should still be in the database table in the next challenge after you stop and re-run the job.
tabs:
- title: Client 1
  type: terminal
  hostname: nomad-client-1
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1200
---

In this challenge, you will examine the tables and data of the MySQL database that your Nomad job is running. You will then write some data to the MySQL database.

Start by connecting to the MySQL database by running this command on the "Client 1" tab:

```bash,run
mysql -h mysql-server.service.consul -u web -ppassword -D itemcollection
```

This is using the DNS, "mysql-server.service.consul", that was registered by the job in Consul, the username "web", the password "password", and the database "itemcollection".

You should end up with a `mysql>` prompt that will allow you to issue the SQL commands below.

Check the tables in the "itemcollection" database with this command:

```bash,run
show tables;
```

This should show this:

```nocopy
+--------------------------+
| Tables_in_itemcollection |
+--------------------------+
| items                    |
+--------------------------+
1 row in set (0.00 sec)
```

Next, read the rows of the table with this query:

```bash,run
select * from items;
```

This should return this:

```nocopy
+----+----------+
| id | name     |
+----+----------+
|  1 | bike     |
|  2 | baseball |
|  3 | chair    |
+----+----------+
3 rows in set (0.00 sec)
```

Please insert an item into the table with this command:

```bash,run
INSERT INTO items (name) VALUES ('glove');
```

This should return "Query OK, 1 row affected (0.00 sec)".

If you want, run the query, `select * from items;`, again to verify that "glove" is now in the "items" table.

The new row (and any others you might add) should all be visible in the next challenge after you stop and restart the job.

Quit MySQL by typing

```bash,run
exit
```

In the next challenge, you will stop and re-run the "mysql-server" job and verify that the data you wrote is still in the database table.
