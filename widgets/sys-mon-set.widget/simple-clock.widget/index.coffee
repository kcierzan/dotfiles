format = '%d %a %l:%M %p'

command: "date +\"#{format}\""

# the refresh frequency in milliseconds
refreshFrequency: 300

render: (output) -> """
  <h1>#{output}</h1>
"""

style: """
  color: #FFFFFF
  font-family: Input Sans Narrow
  left: 40px
  bottom: 0px

  h1
    font-size: 5em
    font-weight: 100
    letter-spacing: -5px
    margin: 0
    padding: 0
  """
