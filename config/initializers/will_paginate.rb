# coding: utf-8
require 'will_paginate'
WillPaginate::ViewHelpers.pagination_options[:prev_label] = "&#8592; Předchozí"
WillPaginate::ViewHelpers.pagination_options[:next_label] = "Další &#8594;"
if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        alias_method :per, :per_page
        alias_method :num_pages, :total_pages
      end
    end
  end
end
