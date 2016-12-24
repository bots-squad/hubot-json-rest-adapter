# Hubot Rest Json Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work via HTTP using Json as data format. 

Useful for headless chat.

## Setup

Set `HUBOT_REST_SEND_URL` as an environment variable to send hubot responses to.

Hubot response is sent in json format, with the following structure:

    {
      from: 'botname',
      message: 'message body string'
    }

## Send message to Hubot

Typically messages to Hubot have three parameters: Message, User and Room.

To send options, when posting to Hubot use the following hash:

    // post: /receive/:room
    {
      from: 'nickname string',
      message: 'message body string'
    }
