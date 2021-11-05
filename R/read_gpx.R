#' @export

read_gpx = function(file) {
  #' @title Read a .gpx file into a data.frame
  #'
  #' @description Read a .gpx file into a list of data.frames
  #'
  #' @param file A path to a .gpx file
  #'
  #' @return List of data frames.
  #'
  #' @examples
  #' \dontrun{
  #' hikes = read_gpx('hiking_file.gpx')
  #' hikes$tracks
  #' hikes$routes
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
