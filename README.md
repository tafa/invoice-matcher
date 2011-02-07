
## Invoice
<pre>
{
    // Amount must be a string. {En,De}code with extreme paranoia!
    // TODO: example {en,de}coder function
    amount: "0.034"
    currency: "BTC"
    bitcoin_address: "..."
    
    info: {
        // all optional
        memo: "XL Coffee, 5 Timbits"
        hub: "https://bitcoin-central.net"  // To expedite payment
        lat:  ""
        lng:  ""
        acc:  ""                            // In meters.
        code: ""                            // Arbitrary, usualy just digits.
        t: ms-since-1970                    // Set by server
    }
}
</pre>


## API

Requests:

* POST
* <code>Content-Type</code>: <code>application/json</code> or <code>application/x-www-form-urlencoded</code>

Responses:

* <code>Content-Type</code>: <code>application/json</code>

<pre>
/api/post.js
    invoice_json: JSON({...})
    -------------
    secret_invoice_token: ""

/api/withdraw.js
    secret_invoice_token: ""
    -------------

/api/search.js
    // a subset of fields, e.g. {code} or {lat,lng,acc}
    "info_json": JSON({...})
    -------------
    invoices: [...]
    t: ms-since-1970  // time on server just before the response was sent
</pre>


## Storage
<pre>
redis_misc                  numInvoices --> (incr)
redis_invoices              msgpack(id) --> JSON(invoice)
redis_secret_tokens         token       --> msgpack(id)
redis_ztime                 t           --> ZSET: (score=t, v=msgpack(id))
redis_code                  code        --> SET: msgpack(id)

// When node-z-order gets released, we can use a single ZSET
redis_zgeo                  {x,y,z}     --> ZSET: (coord, v=maspack(id))
</pre>

