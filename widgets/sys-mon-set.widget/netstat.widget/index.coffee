command: "sys-mon-set.widget/netstat.widget/scripts/netst"

refreshFrequency: 1000

style: """
  -webkit-font-smoothing: antialiased
  top: 7px
  left: 280px
  color: #fff
  font-family: Input Sans Narrow

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 11px
    font-weight: normal

  p
    margin: 0

  p > span
    font-weight: normal


"""


render: -> """
  <div class='netstat'>
  	<p>In: <span id="in"></span></p>
  	<p>Out: <span id="out"></span></p>
  </div>
"""


update: (output, domEl) ->
  bytesToSize = (bytes) ->
    if bytes <= 0
      return "0 Bytes"
    k = 1024
    sizes = [
      "b/s"
      "kb/s"
      "mb/s"
      "gb/s"
      "gb/s"
      "pb/s"
      "eb/s"
      "zb/s"
      "yb/s"
    ]
    i = Math.floor(Math.log(bytes) / Math.log(k))
    (bytes / Math.pow(k, i)).toPrecision(3) + " " + sizes[i]
  values = output.split(' ')
  $(domEl).find('#in').text(bytesToSize(values[0]))
  $(domEl).find('#out').text(bytesToSize(values[1]))


