#!/usr/bin/env Rscript
#
# File:   render.R
# Author: Matteo Spanio <matteo.spanio97@gmail.com>
#
# Generate a simple report from input data

library("optparse")
library("rmarkdown")

# argparser options
args_list = list(
  make_option(c("-i", "--input"), type="character", default="../data/speed_data.csv", 
              help="output file name [default=%default]", metavar="character"),
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="dataset file name", metavar="character"),
  make_option(c("-o", "--output"), type="character", default="out.txt", 
              help="output file name [default=%default]", metavar="character")
);

opt_parser = OptionParser(option_list=args_list);
opt = parse_args(opt_parser);

portfolio_name <- "Tech portfolio"

rmarkdown::render(
  input = "",
  output_format = "pdf_document",
  output_file = opt$output,
  output_dir = "../reports",
  params = list(
    portfolio_name = portfolio_name,
    show_code = FALSE
  )
)