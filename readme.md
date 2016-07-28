# Hubot Web Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work via HTTP. Great for your custom web chat interface.

## Setup

Set `HUBOT_REST_SEND_URL` as an environment variable to send hubot responses to.

Hubot response are sent in json format for easy managment of the data, and has the following format:

    {
      from: 'nickname string',
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