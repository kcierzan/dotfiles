command: "pmset -g batt | grep -o '[0-9]*%'"

refreshFrequency: 60000

style: """
  top: 3px
  right: 40px
  color: #fff
  font-family: Input Sans Narrow

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 26px
    font-weight: normal


"""


render: -> """
  <div class='battery'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.battery').html(output)

