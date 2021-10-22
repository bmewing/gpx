import gpxpy
import pandas as pd
import glob
import ntpath


def parsetracks(f):
    # Parse a GPX file into a list of dictionaries.
    # Each dict is one row of the final dataset

    points2 = []
    with open(f, 'r') as gpxfile:
        # print f
        gpx = gpxpy.parse(gpxfile)
        for track in gpx.tracks:
            for segment in track.segments:
                for point in segment.points:
                    dict = {'Timestamp': point.time,
                            'Latitude': point.latitude,
                            'Longitude': point.longitude,
                            'Elevation': point.elevation
                            }
                    points2.append(dict)
    return points2


def parseroutes(f):
    # Parse a GPX file into a list of dictionaries.
    # Each dict is one row of the final dataset

    points2 = []
    with open(f, 'r') as gpxfile:
        # print f
        gpx = gpxpy.parse(gpxfile)
        for t in gpx.routes:
            for point in t.points:
                dict = {'Latitude': point.latitude,
                        'Longitude': point.longitude,
                        'Elevation': point.elevation
                        }
                points2.append(dict)
    return points2


files = glob.glob('../tests/testthat/testdata/*.gpx')
for fi in files:
    outdir = '../tests/testthat/testdata/check/'
    basename = ntpath.basename(fi).split('.')[0]
    track = pd.DataFrame(parsetracks(fi))
    route = pd.DataFrame(parseroutes(fi))
    if len(track) == 0:
        track = pd.DataFrame(columns = ['Timestamp', 'Latitude', 'Longitude', 'Elevation'])
    if len(route) == 0:
        route = pd.DataFrame(columns = ['Latitude', 'Longitude', 'Elevation'])
    track.to_csv(outdir+basename+'_track.csv')
    route.to_csv(outdir+basename+'_route.csv')