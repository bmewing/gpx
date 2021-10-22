#' @export

read_gpx = function(file){
  #' @title Read a .gpx file into a data.frame
  #'
  #' @description Read a .gpx file into a list of data.frames
  #'
  #' @param file A path to a .gpx file
  #'
  #' @return List of data frames.

  if(!file.exists(file)) stop("Specified file does not exist")
  data = xml2::read_html(file)
  routes = extract_routes(data)
  tracks = extract_tracks(data)
  output = list(routes = routes
               ,tracks = tracks)
  return(output)
}

extract_tracks = function(data){
  tracks = rvest::html_nodes(data,"trk")
  segments = lapply(tracks,rvest::html_nodes,"trkseg")
  points = lapply(segments,rvest::html_nodes,"trkpt")
  output = lapply(points,process_points)
  output = lapply(seq_along(output),function(i){output[[i]][["Segment ID"]] = i;return(output[[i]])})
  return(output)
}

extract_routes = function(data){
  routes = rvest::html_nodes(data,"rte")
  points = lapply(routes,rvest::html_nodes,"rtept")
  output = lapply(points,process_points)
  return(output)
}

process_points = function(points){
  attrs = rvest::html_attrs(points)
  df = do.call(rbind,attrs)
  ele = as.numeric(extract_feature(points,"ele"))
  time = lubridate::as_datetime(extract_feature(points,"time"))
  lat = as.numeric(extract_feature(points,"lat"))
  lon = as.numeric(extract_feature(points,"lon"))
  output = data.frame("Elevation" = ele
                     ,"Time" = time
                     ,"Latitude" = lat
                     ,"Longitude" = lon
                     ,stringsAsFactors = FALSE)
  extensions = extract_extensions(points)
  output = cbind(output,extensions)
  return(output)
}

extract_feature = function(points,feature){
  attr = rvest::html_attr(points,feature)
  node = rvest::html_text(rvest::html_node(points,feature))
  output = coalesce(attr,node)
  return(output)
}

extract_extensions = function(points){
  extensions = rvest::html_nodes(points,"extensions")
  if (length(extensions) == 0) {
    output = rep(NA, length(points))
  } else {
    children = rvest::html_children(extensions)
    output = xml2::as_list(children)
    output = lapply(output,unlist)
    output = do.call(rbind,output)
  }
  return(output)
}

coalesce <- function(...) {
  Reduce(function(x, y) {
    i <- which(is.na(x))
    x[i] <- y[i]
    x},
    list(...))
}
