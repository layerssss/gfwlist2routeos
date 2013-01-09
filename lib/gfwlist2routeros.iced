api = require 'mikronode'
gfwlist2ip = require 'gfwlist2ip'
module.exports= (options)->
  new api(options.host,options.username,options.password).connect (conn)->
    c1 = conn.openChannel()
    c1.write ['/ip/route/rule/print'],->
    c1.on 'done',(data)->
      data=api.parseItems data
      for rule,i in data
        console.log data.length+" #{i}"
        if rule.table==options.routingmark
          console.log "rule #{rule['.id']} deleted..."
          await c1.write ['/ip/route/rule/remove',"=.id=#{rule['.id']}"],defer()
          await c1.on 'done',defer()
      c1.close()


      gfwlist2ip.onResolved = (address)->
        chan = conn.openChannel()
        chan.write ['/ip/route/rule/add',"=dst-address=#{address}","=table=#{options.routingmark}",'=action=lookup'],()->
          chan.on 'done',()->
            chan.close()
            console.log "#{address} added to rules..."
      gfwlist2ip.initGfwlist (err)->
        setTimeout (->conn.close()),5000
