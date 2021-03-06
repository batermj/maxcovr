#' facility_user_dist
#'
#' Uses haversines formula to calculate the distance between lat/long
#'   co-ordinates of every facility and every user, returning a data_frame. You
#'   can think of "facilities" as something like mobile towers, police centres,
#'   or AED locations, and "users" as something like individual houses, crime
#'   locations, or heart attack locations. The motivating example for this
#'   function was finding the distance from Automatic Electronic Defibrillators
#'   (AEDs) to each Out of Hospital Cardiac Arrest (OHCA), where the locations
#'   for AEDs and OHCAs are in separate dataframes. Currently
#'   facifacility_user_dist makes the strict assumption that the facility and
#'   user dataframes have columns named aed_id, lat, and long, and ohca_id, lat,
#'   and long. This will be updated soon.
#'
#' @param facility a dataframe containing columns named "lat", and "long".
#' @param user a dataframe containing columns "lat", and "long".
#' @param coverage_distance numeric indicating the coverage level for the
#'   facilities to be within in metres to a user. Default value is 100 metres.
#' @param nearest character Can be "facility", "user", and "both". Defaults to
#'   "facility". When set to "facility", returns a dataframe where every row is
#'   every crime, and the closest building to each crime. When set to "user",
#'   returns a dataframe where every row is every building, and the closest
#'   crime to each building. set to "both", which will return every pairwise
#'   combination of distances. Be careful whenDefault is "facility"
#'
#' @return a data frame containing the two datasets joined together with columns
#'   named facility_id, lat_facility, long_facility, user_id, lat_user,
#'   long_user, distance in meters between each the given facility and user in a
#'   row.
#'
#' @export
#'
facility_user_dist <- function(facility,
                               user,
                               coverage_distance = 100,
                               nearest = "facility"){

    # do a dodgy cross product by adding a column of 1
    # and then joining on this column
    facility <- dplyr::mutate(facility, key = 1) %>%
        dplyr::rename(lat_facility = lat,
                      long_facility = long) %>%
        # create an ID for each row
        dplyr::mutate(facility_id = 1:n())

    user <- dplyr::mutate(user, key = 1) %>%
        dplyr::rename(lat_user = lat,
                      long_user = long) %>%
        dplyr::mutate(user_id = 1:n())

    dist_df <- user %>%
        dplyr::left_join(facility,
                         by = "key") %>%
        dplyr::mutate(distance = spherical_distance(lat1 = lat_user,
                                                    long1 = long_user,
                                                    lat2 = lat_facility,
                                                    long2 = long_facility)) %>%
        # drop key
        dplyr::select(-key)

    # calculate information about coverage for the users to facilities:
      # finding the nearest facility to each user
      # finding the nearest user to each facility

    if (nearest == "facility"){

        dist_df <- dist_df %>%
            dplyr::arrange(distance) %>%
            dplyr::group_by(user_id) %>%
            # find those closest to each other
            dplyr::mutate(rank_distance = 1:n()) %>%
            dplyr::ungroup() %>%
            dplyr::filter(rank_distance == 1) %>%
            dplyr::select(-rank_distance) %>%
            dplyr::mutate(is_covered = (distance < coverage_distance))

        return(dist_df)

    }

    if (nearest == "user") {

        dist_df <- dist_df %>%
            dplyr::group_by(facility_id) %>%
            dplyr::arrange(distance) %>%
            dplyr::mutate(rank_distance = 1:n()) %>%
            dplyr::ungroup() %>%
            dplyr::filter(rank_distance == 1) %>%
            dplyr::select(-rank_distance) %>%
            dplyr::mutate(is_covered = (distance < coverage_distance))

        return(dist_df)

    }

    if (nearest == "both") {

        dist_df <- dist_df %>%
            dplyr::mutate(is_covered = (distance < coverage_distance))

        return(dist_df)

    }

}
