#' Create a DBI or pool connection to a database.
#'
#' @param dbname character string specifying the database you want to connect to. Use \code{\link{get_databases}} to get a list of available databases.
#' @param cache boolean that specifies whether or not to fetch and store the credentials in a local cache.
#' @param cache_folder if caching is enabled, where to store and fetch the credentials
#' @name create_connection


#' @rdname create_connection
#' @export
#' @importFrom DBI dbConnect
create_connection <- function(dbname = "main-app", cache = FALSE, cache_folder = "~/.datacamp") {
  creds <- get_creds(dbname, cache, cache_folder)
  do.call(DBI::dbConnect, transform_creds(creds))
}

#' @rdname create_connection
#' @export
#' @importFrom pool dbPool
create_connection_pool <- function(dbname = "main-app", cache = FALSE, cache_folder = "~/.datacamp") {
  creds <- get_creds(dbname, cache, cache_folder)
  do.call(pool::dbPool, transform_creds(creds))
}

#' Get a list of all databases.
#'
#' @export
get_databases <- function() {
  dbstring <- get_parameter("/dbconnect/dbnames")
  strsplit(dbstring, split = ",")[[1]]
}

#' Open up the documentation of a database
#'
#' @param dbname character string specifying the database you want to connect to. Use \code{\link{get_databases}} to get a list of available databases.
#' @param open boolean denoting whether or not to open the URL.
#' @return The database documentation URL (invisibly).
#' @export
#' @importFrom utils browseURL
get_docs <- function(dbname = "main-app", open = TRUE) {
  url <- get_parameter(sprintf("/dbconnect/%s/docs", dbname))
  message("Opening database documentation...")
  if (open) browseURL(url)
  invisible(url)
}

