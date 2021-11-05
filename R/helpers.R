extract_tracks = function(data) {
  tracks = rvest::html_nodes(data, "trk")
  segments = lapply(tracks, rvest::html_nodes, "trkseg")
  points = lapply(segments, rvest::html_nodes, "trkpt")
  if (length(points) == 0) {
    output = generate_empty()
  } else {
    output = lapply(points, process_points)
    output = lapply(seq_along(output), function(i){output[[i]][["Segment ID"]] = i;return(output[[i]])}) #nolint
  }
  return(output)
}

extract_routes = function(data) {
  routes = rvest::html_nodes(data, "rte")
  points = lapply(routes, rvest::html_nodes, "rtept")
  if (length(points) == 0) {
    output = generate_empty()
  } else {
    output = lapply(points, process_points)
  }
  return(output)
}

extract_waypoints = function(data) {
  points = rvest::html_nodes(data, "wpt")
  if (length(points) == 0) {
    output = generate_empty()
  } else {
    output = process_waypoints(points)
  }
  return(output)
}

generate_empty = function() {
  empty = data.frame("Elevation" = logical()
                   , "Time" = logical()
                   , "Latitude" = logical()
                   , "Longitude" = logical()
                   , stringsAsFactors = FALSE)
  return(list(empty))
}

process_points = function(points) {
  attrs = rvest::html_attrs(points)
  df = do.call(rbind, attrs)
  ele = as.numeric(extract_feature(points, "ele"))
  time = lubridate::as_datetime(extract_feature(points, "time"))
  lat = as.numeric(extract_feature(points, "lat"))
  lon = as.numeric(extract_feature(points, "lon"))
  output = data.frame("Elevation" = ele
                     , "Time" = time
                     , "Latitude" = lat
                     , "Longitude" = lon
                     , stringsAsFactors = FALSE)
  extensions = extract_extensions(points)
  output = cbind(output, extensions)
  return(output)
}

extract_feature = function(points, feature) {
  attr = rvest::html_attr(points, feature)
  node = rvest::html_text(rvest::html_node(points, feature))
  output = coalesce(attr, node)
  return(output)
}

extract_extensions = function(points) {
  extensions = rvest::html_nodes(points, "extensions")
  if (length(extensions) == 0) {
    output = rep(NA, length(points))
  } else {
    children = rvest::html_children(extensions)
    output = xml2::as_list(children)
    output = lapply(output, unlist)
    output = do.call(rbind, output)
  }
  return(output)
}

process_waypoints = function(points) {
  attrs = rvest::html_attrs(points)
  df = do.call(rbind, attrs)
  ele = as.numeric(extract_feature(points, "ele"))
  time = lubridate::as_datetime(extract_feature(points, "time"))
  lat = as.numeric(extract_feature(points, "lat"))
  lon = as.numeric(extract_feature(points, "lon"))
  name = extract_feature(points, "name")
  desc = extract_feature(points, "desc")
  output = data.frame("Elevation" = ele
                      , "Time" = time
                      , "Latitude" = lat
                      , "Longitude" = lon
                      , "Name" = name
                      , "Description" = desc
                      , stringsAsFactors = FALSE)
  return(output)
}

coalesce = function(...) {
  Reduce(function(x, y) {
    i = which(is.na(x))
    x[i] = y[i]
    x},
    list(...))
}
