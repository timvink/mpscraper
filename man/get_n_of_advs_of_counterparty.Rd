% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/common.R
\name{get_n_of_advs_of_counterparty}
\alias{get_n_of_advs_of_counterparty}
\title{Get the number of advs of a counterparty}
\usage{
get_n_of_advs_of_counterparty(html)
}
\arguments{
\item{html}{Xml_document containing the html content of an advertisement
page.}
}
\value{
a numeric object.
}
\description{
\code{get_n_of_advs_of_counterparty} gets the number of advertisements that a
counterparty is currently hosting.
}
\details{
The function uses the html of a marktplaats advertisement to get the total
number of advertisements that the counterparty of the advertisement is
hosting on marktplaats.
}
