# Hubot Rest Json Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work via HTTP using Json as data format. 

Useful for web chat interfaces.

## Setup

Set `HUBOT_REST_SEND_URL` as an environment variable to send hubot responses to.

Hubot response is sent in json format, with the following structure:

    {
      from: 'botname',
      message: 'message body string'
    }

## Special Options Hash

Typically messages to Hubot have three parameters: Message, User and Room. This
adapter allows for an extendable options has to be sent with the message.

To send options, when posting to Hubot use the following hash:

    // post: /receive/:room
    {
      from: 'nickname string',
      message: 'message body string',
      options: {
        "javascript": "object"
      }
    }

The `options` hash can be accessed in a script with `msg.message.user.options`.
