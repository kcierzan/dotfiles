command: "curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"

refreshFrequency: 43000000

style: """
  -webkit-font-smoothing: antialiased
  top: 5px
  left: 40px
  color: #fff
  font-family: Input Sans Narrow

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 26px
    font-weight: normal

"""


render: -> """
  <div class='ip_address'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.ip_address').html(output)

