
# Instachat

A simple chat system implemented in ruby on rails. This was created as a part of a recruitment process and it follows the general guidelines set by the given task.


## Tech stack (with versions)

This project mainly consists of these technologies and they are the main building blocks of the functionalities of the project.

| Tech           | Version |
| -------------  | ------------- |
| Ruby           | 2.5.9     |
| Rails          | ~> 5.2.8  |
| MySQL          | 5.7.29    |
| ElasticSearch  | 7.14.0    |
| Redis          | latest    |
| Docker         | latest    |

This was created using RubyMine IDE.

## Run Locally

[ 1 ] Pull the github code. \
[ 2 ] open a command prompt and cd to the code repo folder.

```bash
    cd instachat_rb
```
[ 3 ] run docker compose up with build.

```bash
    docker-compose up -d --build
```

[ 4 ] when it's done building and starting, you should see:

```bash
    Creating instachat_rb_elasticsearch_1 ... done
    Creating instachat_rb_redis_1         ... done
    Creating instachat_rb_mysql_1         ... done
    Creating instachat_rb_web_1           ... done
``` 


## General Information


### Routes
The Instachat API application consists of several routes
#### User Application

CRUD:
- `GET`   `/api/v1/applications/{token}`
- `POST`  `/api/v1/applications`
- `PUT`   `/api/v1/applications/{token}`
- `PATCH` `/api/v1/applications/{token}`

Request Body for `POST`, `PUT` and `PATCH`:

```
{
    "name": "This is an application name."
}
``` 

#### Chat ( branched from User application routes )

CRUD:
- `GET`   `/api/v1/applications/{token}/chats/{chat_number}`
- `POST`  `/api/v1/applications/{token}/chats`
- `PUT`   `/api/v1/applications/{token}/chats/{chat_number}`
- `PATCH` `/api/v1/applications/{token}/chats/{chat_number}`


#### Messages ( branched from Chat routes )

CRUD:
- `GET`   `/api/v1/applications/{token}/chats/{chat_number}/messages/{msg_number}`
- `POST`  `/api/v1/applications/{token}/chats/{chat_number}/messages`
- `PUT`   `/api/v1/applications/{token}/chats/{chat_number}/messages/{msg_number}`
- `PATCH` `/api/v1/applications/{token}/chats/{chat_number}/messages/{msg_number}`

Search with ElasticSearch:
- `POST`  `/api/v1/applications/{token}/chats/{chat_number}/messages/search`

Request Body for `POST`, `PUT`, `PATCH` and search `POST`:


```
{
    "text": "This is a message."
}
``` 
