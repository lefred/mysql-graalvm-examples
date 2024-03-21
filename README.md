# mysql-graalvm-examples

This repository contains examples of functions using GraalVM (MLE) for
MySQL Enterprise or MySQL HeatWave.

# JS

The current examples are writen in Javascript, the only supported language for the momement.

## UUIDv1

These functions provides support to extrace the timestamp information of native UUID format (v1)
used in MySQL.

* `js_uuid_to_unixtime(<uuid>)`: it returns the unixtime of the UUID.

```
MySQL > select js_uuid_to_unixtime(uuid());
+-----------------------------+
| js_uuid_to_unixtime(uuid()) |
+-----------------------------+
| 1710957383.554              |
+-----------------------------+
1 row in set (0.0020 sec)

MySQL > select from_unixtime(js_uuid_to_unixtime(uuid()));
+--------------------------------------------+
| from_unixtime(js_uuid_to_unixtime(uuid())) |
+--------------------------------------------+
| 2024-03-20 17:56:31.555000                 |
+--------------------------------------------+
1 row in set (0.0008 sec)
```

* `js_uuid_to_datetime(<uuid>)`: this function return the date time of the UUID in a more human readable format.

```
MySQL > select js_uuid_to_datetime(uuid());
+-----------------------------+
| js_uuid_to_datetime(uuid()) |
+-----------------------------+
| 2024-03-20 17:56:39.118     |
+-----------------------------+
1 row in set (0.0027 sec)
```

* `js_uuid_to_datetime_log(<uuid>)`: same as the previous function but with even more details.

```
MySQL > select js_uuid_to_datetime_long(uuid());
+---------------------------------------------+
| js_uuid_to_datetime_long(uuid())            |
+---------------------------------------------+
| Wednesday, March 20, 2024 at 5:56:46 PM GMT |
+---------------------------------------------+
1 row in set (0.0063 sec)
```

## UUIDv7

This set of functions provides the creation and the time stamp's extraction of UUIDv7.

* `js_uuidv7()`: generates a UUIDv7.

```
MySQL > select js_uuidv7();
+--------------------------------------+
| js_uuidv7()                          |
+--------------------------------------+
| 018e6064-a472-7511-e89b-e9f5141b86ec |
+--------------------------------------+
1 row in set (0.0007 sec)
```

* `js_uuidv7_to_unixtime(<uuid>)`: it returns the unixtime of the UUIDv7.

```MySQL > select js_uuidv7_to_unixtime("018e5e04-ba34-780f-6a68-3ba37f00ca27");
+---------------------------------------------------------------+
| js_uuidv7_to_unixtime("018e5e04-ba34-780f-6a68-3ba37f00ca27") |
+---------------------------------------------------------------+
| 1710974351.924                                                |
+---------------------------------------------------------------+
1 row in set (0.0009 sec)
```

* `js_uuidv7_to_datetime(<uuid>)`: this function return the date time of the UUIDv7 in a more human readable format.

```
MySQL > select js_uuidv7_to_datetime("018e5e04-ba34-780f-6a68-3ba37f00ca27");
+---------------------------------------------------------------+
| js_uuidv7_to_datetime("018e5e04-ba34-780f-6a68-3ba37f00ca27") |
+---------------------------------------------------------------+
| 2024-03-20 22:39:11.924                                       |
+---------------------------------------------------------------+
1 row in set (0.0009 sec)
```
* `js_uuidv7_to_datetime_long(<uuid>)`: same as the previous function but with even more details.

```
MySQL > select js_uuidv7_to_datetime_long("018e5e04-ba34-780f-6a68-3ba37f00ca27");
+--------------------------------------------------------------------+
| js_uuidv7_to_datetime_long("018e5e04-ba34-780f-6a68-3ba37f00ca27") |
+--------------------------------------------------------------------+
| Wednesday, March 20, 2024 at 10:39:11 PM GMT                       |
+--------------------------------------------------------------------+
1 row in set (0.0013 sec)
```

