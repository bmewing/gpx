#' @export

read_gpx = function(file) {
  #' @title Read a .gpx file into a data.frame
  #'
  #' @description Read a .gpx file into a list of data.frames, one each for tracks, routes and waypoints.
  #' The named element 'tracks' is a named list of tracks present in the file. It will always contain columns for Elevation, Time, Latitude, Longitude, and Segment ID.
  #' The named element 'routes' is an unnamed list of routes present in the file. It will always contain columns for Elevation, Time, Latitude, and Longitude.
  #' The named element 'waypoints' is an unnamed list of routes present in the file. It will always contain columns for Elevation, Time, Latitude, and Longitude.
  #' In each case, if there are extensions in the file within the record type, it will attempt to include them as columns as well. If there are no points of the specified type, it will contain a 0-row data.frame with all the standard column names.
  #'
  #' @param file A path to a .gpx file
  #'
  #' @return List of data frames
  #'
  #' @examples
  #' \dontrun{
  #' hikes = read_gpx('hiking_file.gpx')
  #' hikes$tracks
  #' hikes$routes
  #' hikes$waypoints
  #' }

  if (!file.exists(file)) stop("Specified file does not exist")
  data = xml2::read_html(file)
  routes = extract_routes(data)
  tracks = extract_tracks(data)
  waypoints = extract_waypoints(data)
  output = list(routes = routes
              , tracks = tracks
              , waypoints = waypoints)
  return(output)
}
