hs.redshift.start(3300, '20:00', '7:00', '2h')
prefix.bind('', 'n', hs.redshift.toggle)
prefix.bind('','i', hs.redshift.toggleInvert)

