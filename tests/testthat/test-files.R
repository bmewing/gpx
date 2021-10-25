context("Check individual files")

test_names = c("bayes", "beauty", "cotswold", "cranberry", "greasy", "palmetto", "salins")
test_files = c("Bayes_Mountain_Fire_Tower_TN", "Beauty_Spot_TN", "cotswold-way",
               "Cranberry_Lake_NY", "greasy-creek-to-roan-high-knob", "Palmetto_Trail_SC",
               "Salins-les-Bains")

for (i in 1:length(test_names)) { #nolint
  test_that(test_names[i], {
    expect_equal(class(test <- read_gpx(paste0("testdata/", test_files[i], ".gpx"))), "list") #nolint
    expect_equal(class(check_route <- read.csv(paste0("testdata/", test_files[i], "_route.csv"))), "data.frame") #nolint
    expect_equal(class(check_track <- read.csv(paste0("testdata/", test_files[i], "_track.csv"))), "data.frame") #nolint
    expect_equal(nrow(check_route), nrow(test$routes[[1]]))
    expect_equal(nrow(check_track), nrow(test$tracks[[1]]))
    expect_equal(test$tracks[[1]]$Latitude, check_track$Latitude)
    expect_equal(test$tracks[[1]]$Longitude, check_track$Longitude)
    expect_equal(test$tracks[[1]]$Elevation, check_track$Elevation)
    expect_equal(test$routes[[1]]$Latitude, check_route$Latitude)
    expect_equal(test$routes[[1]]$Longitude, check_route$Longitude)
    expect_equal(test$routes[[1]]$Elevation, check_route$Elevation)
  })
}
