#!/usr/bin/python3

from yr.libyr import Yr

weather = Yr(location_name='Germany/Berlin/Berlin')
data = weather.now()

weather = data['symbol']['@name']
temperature = data['temperature']['@value']

print ("<fc=#FFFFFF>%s %s °C</fc>" % (weather, temperature))
