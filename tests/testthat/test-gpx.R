test_that("basic functionality", {
  expect_error(read_gpx("testdata/fake"))
  expect_equal(class(greasy_test <- read_gpx("testdata/greasy-creek-to-roan-high-knob.gpx")), "list") #nolint
  expect_length(greasy_test, 3)
  expect_length(greasy_test$tracks, 1)
  expect_length(greasy_test$routes, 1)
  expect_length(greasy_test$waypoints, 1)
  expect_named(greasy_test, c("routes", "tracks", "waypoints"))
  expect_equal(nrow(greasy_test$tracks[[1]]), 0)
  expect_equal(ncol(greasy_test$tracks[[1]]), 4)
  expect_equal(nrow(greasy_test$routes[[1]]), 563)
  expect_equal(ncol(greasy_test$routes[[1]]), 5)
  expect_true(all(is.na(greasy_test$routes[[1]][["extensions"]])))
  expect_true(all(is.na(greasy_test$routes[[1]][["Time"]])))
  expect_true(all(is.numeric(greasy_test$routes[[1]][["Elevation"]])))
  expect_true(all(is.numeric(greasy_test$routes[[1]][["Latitude"]])))
  expect_true(all(is.numeric(greasy_test$routes[[1]][["Longitude"]])))

  expect_equal(class(track_name <- read_gpx("testdata/Bayes_Mountain_Fire_Tower_TN.gpx")), "list") #nolint
  expect_named(track_name$tracks, "Kingsport Hiking")
})
