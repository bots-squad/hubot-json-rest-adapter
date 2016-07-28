Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')
string = require("string")

# sendmessageURL domain.com/messages/new/channel/ + user.channel
sendMessageUrl = process.env.HUBOT_REST_SEND_URL

class WebAdapter extends Adapter
  createUser: (username, room) ->
    user = @robot.brain.userForName username
    unless user?
      id = new Date().getTime().toString()
      user = @robot.brain.userForId id
      user.name = username

    user.room = room

    user

  send: (user, strings...) ->    
    if strings.length > 0
      data = JSON.stringify({
        message: strings.shift(),
        from: "#{@robot.name}"
      })
      url = "#{sendMessageUrl}/message/#{user.room}"
      options = {
        url = url,
        method: 'POST',
        json = data
      }
      request options, (err, res, body) -> 
          if err
            console.log "There was an error sending the request to: #{url}"
      @send user, strings...

  reply: (user, strings...) ->
    @send user, strings.map((str) -> "#{user.user}: #{str}")...

  run: ->
    self = @

    options = {}

    @robot.router.post '/receive/:room', (req, res) ->
      user = self.createUser(req.body.from, req.params.room)

      if req.body.options
        user.options = JSON.parse(req.body.options)
      else
        user.options = {}

      console.log "[#{req.params.room}] #{user.name} => #{req.body.message}"

      res.setHeader 'content-type', 'text/html'
      self.receive new TextMessage(user, req.body.message)
      res.end 'received'

    self.emit "connected"

exports.use = (robot) ->
  new WebAdapter robot