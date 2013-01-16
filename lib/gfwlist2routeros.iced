api = require 'mikronode'
gfwlist2ip = require 'gfwlist2ip'
fs = require 'fs'
http = require 'http'
module.exports= (options)->
  next=(cb)->
    new api(options.host,options.username,options.password).connect (conn)->
      c1 = conn.openChannel()
      c1.write ['/ip/route/rule/print'],->
      c1.on 'done',(data)->
        data=api.parseItems data
        for rule,i in data
          if rule.table==options.routingmark
            console.log "rule #{rule['.id']} deleted..."
            await c1.write ['/ip/route/rule/remove',"=.id=#{rule['.id']}"],defer()
            await c1.on 'done',defer()
        c1.close()


        gfwlist2ip.onResolved = (address)->
          chan = conn.openChannel()
          chan.write ['/ip/route/rule/add',"=dst-address=#{address}","=table=#{options.routingmark}",'=action=lookup-only-in-table'],()->
            chan.on 'done',()->
              chan.close()
              console.log "#{address} added to rules..."
        await gfwlist2ip.initGfwlist defer err
        conn.close()
        cb()
  if options.file
    server = http.createServer (req, res)->
      fs.readFile options.file, 'utf8', (err, data)->
        res.writeHead 200, 
          'Content-Type': 'text/plain'
        res.end new Buffer(data, 'utf8').toString('base64'), 'utf8'
    server.listen 0
    gfwlist2ip.gfwlistSource = "http://localhost:#{server.address().port}/"
    console.log "serving `gfwlist` from #{gfwlist2ip.gfwlistSource}"
    await next defer()
    server.close()
  else
    await next defer()

