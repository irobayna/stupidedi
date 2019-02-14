# frozen_string_literal: true
module Stupidedi
  module Contrib
    module ThirtyTen
      module TransactionSetDefs

        SegmentReqs = Versions::FunctionalGroups::ThirtyTen::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::ThirtyTen::SegmentDefs

        autoload :IN810, # Public Voucher (Invoice)
          "stupidedi/contrib/003010/transaction_set_defs/IN810"

        autoload :RA820, # Remittance Advice
          "stupidedi/contrib/003010/transaction_set_defs/RA820"

        autoload :PO850, # Purchase Order
          "stupidedi/contrib/003010/transaction_set_defs/PO850"

        autoload :PC860, # Purchase Order Change
          "stupidedi/contrib/003010/transaction_set_defs/PC860"

        autoload :PS830, # Planning Schedule with Release Capability
          "stupidedi/contrib/003010/transaction_set_defs/PS830"

      end
    end
  end
end
